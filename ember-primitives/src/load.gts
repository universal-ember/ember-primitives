import { setComponentTemplate } from "@ember/component";
import templateOnly from "@ember/component/template-only";
// Have to use these until min ember version is like 6.3 or something
import { precompileTemplate } from "@ember/template-compilation";

import { getPromiseState } from "reactiveweb/get-promise-state";

import type { ComponentLike } from "@glint/template";

interface LoadSignature {
  Blocks: {
    loading: [];
    error: [reason: unknown];
    success?: [component: ComponentLike<any>];
  };
}

/**
 * Loads a value / promise / function providing state for the lifetime of that value / promise / function.
 *
 * Can be used for manual bundle splitting via await importing components.
 *
 * @example
 * ```gjs
 * import { load } from 'ember-primitives/load';
 *
 * const Loader = load(() => import('./routes/sub-route.gts'));
 *
 * <template>
 *   <Loader>
 *     <:loading> ... loading ... </:loading>
 *     <:error as |error|> ... error! {{error.reason}} </:error>
 *     <:success as |component|> <component /> </:success>
 *   </Loader>
 * </template>
 * ```
 */
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
