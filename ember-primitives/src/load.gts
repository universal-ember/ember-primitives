import Component from "@glimmer/component";

// Have to use these until min ember version is like 6.3 or something
import { precompileTemplate } from "@ember/template-compilation";
import { setComponentTemplate } from "@ember/component";
import templateOnly from "@ember/component/template-only";
import { cell } from "ember-resources";

import type Owner from "@ember/owner";

interface State {
  isLoading: boolean;
  error: null | string;
  component: undefined | ComponentLike;
}
const promiseCache = new WeakMap<unknown, State>();

function getState() {}
function getResolved() {}
function getError() {}
function getisPending() {}

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

function getPromiseState<Value>(valueOrFn: Value | (() => Value) | (() => Promise<Value>)) {
  if (typeof valueOrFn !== "function") {
    return {
      isLoading: false,
      error: null,
      component: valueOrFn,
    };
  }

  let value: (() => Value) | (() => Promise<Value>);

  return new Proxy(valueOrFn, {
    get(target, key, receiver) {
      if (key === "isLoading") {
        value ||= valueOrFn();

        if ("then" in value) {
          let isLoading = cell(true);
          value.then(() => (isLoading.current = false));
          return isLoading.current;
        }
        return false;
      }
      if (key === "error") {
        value ||= valueOrFn();
        if ("then" in value) {
          let error = cell(null);
          value.catch((e) => (error.current = e));
          return error.current;
        }
        return null;
      }
      if (key === "component") {
        value ||= valueOrFn();
        if ("then" in value) {
          let component = cell();
          value.then((result) => (component.current = result));
          return component.current;
        }

        return value;
      }
    },
  });
}

const and = (a: unknown, b: unknown) => a && b;

export function load<Value>(fn: () => Promise<Value>) {
  return setComponentTemplate(
    precompileTemplate(
      `{{#let (getPromiseState fn) as |state|}}
  {{#if (and (has-block 'idle') state.isIdle)}}{{yield to="idle"}}

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
  );
}
