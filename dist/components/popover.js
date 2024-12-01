import { hash } from '@ember/helper';
import { arrow } from '@floating-ui/dom';
import { element } from 'ember-element-helper';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { FloatingUI } from '../floating-ui/component.js';
import '../floating-ui/modifier.js';
import { Portal } from './portal.js';
import { TARGETS } from './portal-targets.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

function getElementTag(tagName1) {
  return tagName1 || 'div';
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
  top: 'bottom',
  right: 'left',
  bottom: 'top',
  left: 'right'
};
const attachArrow = modifier((element1, _1, named1) => {
  if (element1 === named1.arrowElement.current) {
    if (!named1.data) return;
    if (!named1.data.middlewareData) return;
    let {
      arrow: arrow1
    } = named1.data.middlewareData;
    let {
      placement: placement1
    } = named1.data;
    if (!arrow1) return;
    if (!placement1) return;
    let {
      x: arrowX1,
      y: arrowY1
    } = arrow1;
    let otherSide1 = placement1.split('-')[0];
    let staticSide1 = arrowSides[otherSide1];
    Object.assign(named1.arrowElement.current.style, {
      left: arrowX1 != null ? `${arrowX1}px` : '',
      top: arrowY1 != null ? `${arrowY1}px` : '',
      right: '',
      bottom: '',
      [staticSide1]: '-4px'
    });
    return;
  }
  (async () => {
    await Promise.resolve();
    named1.arrowElement.set(element1);
  })();
});
const ArrowElement = () => cell();
function maybeAddArrow(middleware1, element1) {
  let result1 = [...(middleware1 || [])];
  if (element1) {
    result1.push(arrow({
      element: element1
    }));
  }
  return result1;
}
function flipOptions(options1) {
  return {
    elementContext: 'reference',
    ...options1
  };
}
const Popover = setComponentTemplate(precompileTemplate("\n  {{#let (ArrowElement) as |arrowElement|}}\n    <FloatingUI @placement={{@placement}} @strategy={{@strategy}} @middleware={{maybeAddArrow @middleware arrowElement.current}} @flipOptions={{flipOptions @flipOptions}} @shiftOptions={{@shiftOptions}} @offsetOptions={{@offsetOptions}} as |reference floating extra|>\n      {{yield (hash reference=reference setReference=extra.setReference Content=(component Content floating=floating inline=@inline) data=extra.data arrow=(modifier attachArrow arrowElement=arrowElement data=extra.data))}}\n    </FloatingUI>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    ArrowElement,
    FloatingUI,
    maybeAddArrow,
    flipOptions,
    hash,
    Content,
    attachArrow
  })
}), templateOnly());

export { Popover, Popover as default };
//# sourceMappingURL=popover.js.map
