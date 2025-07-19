import Component from "@glimmer/component";
import { setComponentTemplate } from "@ember/component";
import templateOnly from "@ember/component/template-only";
// Have to use these until min ember version is like 6.3 or something
import { precompileTemplate } from "@ember/template-compilation";

import { getPromiseState } from "reactiveweb/get-promise-state";

import type Owner from "@ember/owner";
import type { ComponentLike } from "@glint/template";

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

interface LoadSignature {
  Blocks: {
    loading: [];
    error: [reason: unknown];
    success?: [component: ComponentLike];
  };
}

export function load<Value>(
  fn: Value | Promise<Value> | (() => Promise<Value>) | (() => Value),
): ComponentLike<LoadSignature> {
  return setComponentTemplate(
    precompileTemplate(
      `{{#let (getPromiseState fn) as |state|}}
  {{#if state.isLoading}}
    {{yield to="loading"}}
  {{else if state.error}}
    {{yield state.error to="error"}}
  {{else if state.resolved}}
    {{#if (has-block "success")}}
      {{yield state.resolved to="success"}}
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
        scope: () => ({ fn, getPromiseState }),
      },
    ),
    templateOnly(),
  ) as ComponentLike<LoadSignature>;
}
