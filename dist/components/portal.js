
import { assert } from '@ember/debug';
import { schedule } from '@ember/runloop';
import { buildWaiter } from '@ember/test-waiters';
import { modifier } from 'ember-modifier';
import { resourceFactory, cell, resource } from 'ember-resources';
import { isElement } from '../narrowing.js';
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
  if (isElement(query)) {
    return query;
  }
  let found = document.getElementById(query);
  found ??= document.querySelector(query);
  return found;
}
const anchor = modifier((element, [to, update]) => {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call
  const found = findNearestTarget(element, to);
  // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
  update(found);
});
const ElementValue = () => cell();
const waiter = buildWaiter("ember-primitives:portal");
function wormholeCompat(selector) {
  const target = wormhole(selector);
  if (target) return target;
  return resource(() => {
    const target = cell();
    const token = waiter.beginAsync();
    // eslint-disable-next-line ember/no-runloop
    schedule("afterRender", () => {
      const result = wormhole(selector);
      waiter.endAsync(token);
      target.current = result;
      assert(`Could not find element with id/selector \`${typeof selector === "string" ? selector : "<Element>"}\``, result);
    });
    return () => target.current;
  });
}
resourceFactory(wormholeCompat);
const Portal = setComponentTemplate(precompileTemplate("\n  {{#if (isElement @to)}}\n    <ToElement @to={{@to}} @append={{@append}}>\n      {{yield}}\n    </ToElement>\n  {{else if @wormhole}}\n    {{#let (wormholeCompat @wormhole) as |target|}}\n      {{#if target}}\n        {{#in-element target insertBefore=null}}\n          {{yield}}\n        {{/in-element}}\n      {{/if}}\n    {{/let}}\n  {{else if @to}}\n    <Nestable @to={{@to}} @append={{@append}}>\n      {{yield}}\n    </Nestable>\n  {{else}}\n    {{assert \"either @to or @wormhole is required. Received neither\"}}\n  {{/if}}\n", {
  strictMode: true,
  scope: () => ({
    isElement,
    ToElement,
    wormholeCompat,
    Nestable,
    assert
  })
}), templateOnly());
const ToElement = setComponentTemplate(precompileTemplate("\n  {{#if @append}}\n    {{#in-element @to insertBefore=null}}\n      {{yield}}\n    {{/in-element}}\n  {{else}}\n    {{#in-element @to}}\n      {{yield}}\n    {{/in-element}}\n  {{/if}}\n", {
  strictMode: true
}), templateOnly());
const Nestable = setComponentTemplate(precompileTemplate("\n  {{#let (ElementValue) as |target|}}\n    {{!-- This div is always going to be empty,\n          because it'll either find the portal and render content elsewhere,\n          it it won't find the portal and won't render anything.\n      --}}\n    {{!-- template-lint-disable no-inline-styles --}}\n    <div style=\"display:contents;\" {{anchor @to target.set}}>\n      {{#if target.current}}\n        {{#if @append}}\n          {{#in-element target.current insertBefore=null}}\n            {{yield}}\n          {{/in-element}}\n        {{else}}\n          {{#in-element target.current}}\n            {{yield}}\n          {{/in-element}}\n        {{/if}}\n      {{/if}}\n    </div>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    ElementValue,
    anchor
  })
}), templateOnly());

export { Portal, Portal as default, wormhole };
//# sourceMappingURL=portal.js.map
