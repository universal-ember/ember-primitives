import { hash } from '@ember/helper';
import { arrow } from '@floating-ui/dom';
import { element } from 'ember-element-helper';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { F as FloatingUI } from '../component-CYAq0W14.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const showPopover = modifier(element => {
  const el = element;
  // Reset [popover] UA overflow default that clips arrows positioned outside
  el.style.setProperty("overflow", "visible");
  // Don't promote to top layer if already inside a popover — the parent
  // popover already handles layering. Adding both to the top layer causes
  // stacking issues where the parent renders on top of the child.
  if (el.parentElement?.closest("[popover]")) {
    el.removeAttribute("popover");
    // <dialog> elements are hidden by default — ensure they're visible
    // when opting out of the top layer.
    if (el instanceof HTMLDialogElement) {
      el.setAttribute("open", "");
    }
  } else {
    el.showPopover();
  }
  return () => {
    try {
      el.hidePopover();
    } catch {
      /* already hidden */}
  };
});
function getElementTag(tagName) {
  return tagName || "div";
}
/**
 * Content uses `popover="manual"` + `showPopover()` to promote
 * the element to the browser's top layer. This escapes all ancestor
 * overflow clipping and stacking contexts — the same guarantee that
 * portalling provided, but using the browser's native mechanism.
 */
const Content = setComponentTemplate(precompileTemplate("{{#let (element (getElementTag @as)) as |El|}}\n  {{!-- @glint-ignore\n        https://github.com/tildeio/ember-element-helper/issues/91\n        https://github.com/typed-ember/glint/issues/610\n  --}}\n  <El popover=\"manual\" {{showPopover}} {{@floating}} ...attributes>\n    {{yield}}\n  </El>\n{{/let}}", {
  strictMode: true,
  scope: () => ({
    element,
    getElementTag,
    showPopover
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
    elementContext: "both",
    ...options
  };
}
const Popover = setComponentTemplate(precompileTemplate("{{#let (ArrowElement) as |arrowElement|}}\n  <FloatingUI @placement={{@placement}} @strategy={{@strategy}} @middleware={{maybeAddArrow @middleware arrowElement.current}} @flipOptions={{flipOptions @flipOptions}} @shiftOptions={{@shiftOptions}} @offsetOptions={{@offsetOptions}} as |reference floating extra|>\n    {{#let (modifier attachArrow arrowElement=arrowElement data=extra.data) as |arrow|}}\n      {{yield (hash reference=reference setReference=extra.setReference Content=(component Content floating=floating) data=extra.data arrow=arrow)}}\n    {{/let}}\n  </FloatingUI>\n{{/let}}", {
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
