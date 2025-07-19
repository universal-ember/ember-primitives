import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import type { ComponentLike } from "@glint/template";
import { waitForPromise } from "@ember/test-waiters";

// Have to use these until min ember version is like 6.3 or something
import { precompileTemplate } from "@ember/template-compilation";
import { setComponentTemplate } from "@ember/component";
import templateOnly from "@ember/component/template-only";
import { cell } from "ember-resources";

import type Owner from "@ember/owner";

interface State<Value> {
  isLoading: boolean;
  error: undefined | null | string;
  component: Value | undefined;
}

type Invokable<Value> = (() => Value) | (() => Promise<Value>);
const promiseCache = new WeakMap<Invokable<unknown>, State<unknown>>();

class StateImpl<Value> implements State<Value> {
  /**
   * @private
   */
  @tracked _isLoading: undefined | boolean;
  /**
   * @private
   */
  @tracked _error: undefined | null | string;
  /**
   * @private
   */
  @tracked _component: undefined | Value;

  #fn: Invokable<Value>;
  #initial: Partial<State<Value>>;

  constructor(fn: Invokable<Value>, initial: Partial<State<Value>>) {
    this.#fn = fn;
    this.#initial = initial;

    this.#ensure();
  }

  #promise: unknown;
  #ensure() {
    if (this.#promise !== undefined) return;
    let maybePromise = this.#fn();

    if (typeof maybePromise === "object" && maybePromise !== null && "then" in maybePromise) {
      this.#promise = waitForPromise(
        maybePromise
          .then((component) => (this._component = component))
          .catch((error) => (this._error = error))
          .finally(() => (this._isLoading = false)),
      );
      return;
    }

    this._isLoading = false;
    this._component = maybePromise;
    this.#promise = false;
  }

  get isLoading() {
    return this._isLoading ?? this.#initial.isLoading ?? false;
  }
  get error() {
    return this._error ?? this.#initial.error;
  }
  get component() {
    return this._component ?? this.#initial.component;
  }
}

function getPromiseState<Value>(fn: Value | Invokable<Value>): State<Value> {
  if (typeof fn !== "function") {
    return {
      isLoading: false,
      error: null,
      component: fn,
    };
  }

  let existing = promiseCache.get(fn as Invokable<Value>);
  if (existing) return existing as State<Value>;

  let state = new StateImpl(fn as Invokable<Value>, { isLoading: true });

  promiseCache.set(fn as Invokable<Value>, state);

  return state;
}

/**
 * The `<Throw />` component is used to throw an error in a template.
 *
 * That's all it does. So don't use it unless the application should
 * throw an error if it reaches this point in the template.
 *
 * ```hbs
 * <Throw @error={{anError}} />
 * ```
 *
 * @class <Throw />
 * @public
 */
export class Throw<E> extends Component<{
  Args: {
    error: E;
  };
}> {
  constructor(owner: Owner, args: { error: E }) {
    super(owner, args);
    // this error is opaque (user supplied) so we don't validate it
    // as an Error instance.
    throw this.args.error;
  }
  <template></template>
}

const and = (a: unknown, b: unknown) => a && b;

interface LoadSignature {
  Blocks: {
    loading: [];
    error: [reason: unknown];
    success?: [component: ComponentLike];
  };
}

export function load<Value>(fn: Value | Invokable<Value>): ComponentLike<LoadSignature> {
  return setComponentTemplate(
    precompileTemplate(
      `{{#let (getPromiseState fn) as |state|}}
{{log state}}
{{log state.component}}
  {{#if state.isLoading}}
    {{yield to="loading"}}
  {{else if state.error}}
    {{yield state.error to="error"}}
  {{else if state.component}}
    {{#if (has-block "success")}}
      {{yield state.component to="success"}}
    {{else}}
      <state.component />
    {{/if}}
  {{/if}}
{{/let}}`,
      {
        strictMode: true,
        /**
         * The old setComponentTemplate + precompileTemplate combo
         * does not allow defining things in this scope object,
         * we _have_ to use the shorthand.
         */
        scope: () => ({ fn, and, getPromiseState }),
      },
    ),
    templateOnly(),
  ) as ComponentLike<LoadSignature>;
}
