
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { precompileTemplate } from '@ember/template-compilation';
import { getPromiseState } from 'reactiveweb/get-promise-state';

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
function load(fn) {
  return setComponentTemplate(precompileTemplate("{{#let (getPromiseState fn) as |state|}}\n  {{#if state.isLoading}}\n    {{yield to=\"loading\"}}\n  {{else if state.error}}\n    {{yield state.error to=\"error\"}}\n  {{else if state.resolved}}\n    {{#if (has-block \"success\")}}\n      {{yield state.resolved to=\"success\"}}\n    {{else}}\n      <state.component />\n    {{/if}}\n  {{/if}}\n{{/let}}", {
    strictMode: true,
    /**
     * The old setComponentTemplate + precompileTemplate combo
     * does not allow defining things in this scope object,
     * we _have_ to use the shorthand.
     */
    scope: () => ({
      fn,
      getPromiseState
    })
  }), templateOnly());
}

export { load };
//# sourceMappingURL=load.js.map
