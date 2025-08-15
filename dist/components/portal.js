import { assert } from '@ember/debug';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { findNearestTarget } from './portal-targets.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

/* eslint-disable @typescript-eslint/no-redundant-type-constituents */
/**
 * Polyfill for ember-wormhole behavior
 *
 * Example usage:
 * ```gjs
 * import { wormhole, Portal } from 'ember-primitives/components/portal';
 *
 * <template>
 *   <div id="the-portal"></div>
 *
 *   <Portal @to={{wormhole "the-portal"}}>
 *     content renders in the above div
 *   </Portal>
 * </template>
 *
 * ```
 */
function wormhole(query) {
  assert(`Expected query/element to be truthy.`, query);
  if (query instanceof Element) {
    return query;
  }
  let found = document.getElementById(query);
  found ??= document.querySelector(query);
  assert(`Could not find element with id/selector ${query}`, found);
  return found;
}
const anchor = modifier((element, [to, update]) => {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call
  const found = findNearestTarget(element, to);
  // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
  update(found);
});
const ElementValue = () => cell();
function isElement(x) {
  return x instanceof Element;
}
const Portal = setComponentTemplate(precompileTemplate("\n  {{#if (isElement @to)}}\n    {{#if @append}}\n      {{#in-element @to insertBefore=null}}\n        {{yield}}\n      {{/in-element}}\n    {{else}}\n      {{#in-element @to}}\n        {{yield}}\n      {{/in-element}}\n    {{/if}}\n  {{else}}\n    {{#let (ElementValue) as |target|}}\n      {{!-- This div is always going to be empty,\n          because it'll either find the portal and render content elsewhere,\n          it it won't find the portal and won't render anything.\n      --}}\n      {{!-- template-lint-disable no-inline-styles --}}\n      <div style=\"display:contents;\" {{anchor @to target.set}}>\n        {{#if target.current}}\n          {{#if @append}}\n            {{#in-element target.current insertBefore=null}}\n              {{yield}}\n            {{/in-element}}\n          {{else}}\n            {{#in-element target.current}}\n              {{yield}}\n            {{/in-element}}\n          {{/if}}\n        {{/if}}\n      </div>\n    {{/let}}\n  {{/if}}\n", {
  strictMode: true,
  scope: () => ({
    isElement,
    ElementValue,
    anchor
  })
}), templateOnly());

export { Portal, Portal as default, wormhole };
//# sourceMappingURL=portal.js.map
