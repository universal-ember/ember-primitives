
import { hash } from '@ember/helper';
import { arrow } from '@floating-ui/dom';
import { element } from 'ember-element-helper';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { F as FloatingUI } from '../component-Bs3N-G9z.js';
import { Portal } from './portal.js';
import { TARGETS } from './portal-targets.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

function getElementTag(tagName) {
  return tagName || "div";
}
/**
 * Allows lazy evaluation of the portal target (do nothing until rendered)
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
const Content = setComponentTemplate(precompileTemplate("\n  {{#let (element (getElementTag @as)) as |El|}}\n    {{#if @inline}}\n      {{!-- @glint-ignore\n            https://github.com/tildeio/ember-element-helper/issues/91\n            https://github.com/typed-ember/glint/issues/610\n      --}}\n      <El {{@floating}} ...attributes>\n        {{yield}}\n      </El>\n    {{else}}\n      <Portal @to={{TARGETS.popover}}>\n        {{!-- @glint-ignore\n              https://github.com/tildeio/ember-element-helper/issues/91\n              https://github.com/typed-ember/glint/issues/610\n        --}}\n        <El {{@floating}} ...attributes>\n          {{yield}}\n        </El>\n      </Portal>\n    {{/if}}\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    element,
    getElementTag,
    Portal,
    TARGETS
  })
}), templateOnly());
const arrowSides = {
  top: "bottom",
  right: "left",
  bottom: "top",
  left: "right"
};
const attachArrow = modifier((element, _, named) => {
  if (element === named.arrowElement.current) {
    if (!named.data) return;
    if (!named.data.middlewareData) return;
    const {
      arrow
    } = named.data.middlewareData;
    const {
      placement
    } = named.data;
    if (!arrow) return;
    if (!placement) return;
    const {
      x: arrowX,
      y: arrowY
    } = arrow;
    const otherSide = placement.split("-")[0];
    const staticSide = arrowSides[otherSide];
    Object.assign(named.arrowElement.current.style, {
      left: arrowX != null ? `${arrowX}px` : "",
      top: arrowY != null ? `${arrowY}px` : "",
      right: "",
      bottom: "",
      [staticSide]: "-4px"
    });
    return;
  }
  void (async () => {
    await Promise.resolve();
    named.arrowElement.set(element);
  })();
});
const ArrowElement = () => cell();
function maybeAddArrow(middleware, element) {
  const result = [...(middleware || [])];
  if (element) {
    result.push(arrow({
      element
    }));
  }
  return result;
}
function flipOptions(options) {
  return {
    elementContext: "reference",
    ...options
  };
}
const Popover = setComponentTemplate(precompileTemplate("\n  {{#let (ArrowElement) as |arrowElement|}}\n    <FloatingUI @placement={{@placement}} @strategy={{@strategy}} @middleware={{maybeAddArrow @middleware arrowElement.current}} @flipOptions={{flipOptions @flipOptions}} @shiftOptions={{@shiftOptions}} @offsetOptions={{@offsetOptions}} as |reference floating extra|>\n      {{#let (modifier attachArrow arrowElement=arrowElement data=extra.data) as |arrow|}}\n        {{yield (hash reference=reference setReference=extra.setReference Content=(component Content floating=floating inline=@inline) data=extra.data arrow=arrow)}}\n      {{/let}}\n    </FloatingUI>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    ArrowElement,
    FloatingUI,
    maybeAddArrow,
    flipOptions,
    attachArrow,
    hash,
    Content
  })
}), templateOnly());

export { Popover, Popover as default };
//# sourceMappingURL=popover.js.map
