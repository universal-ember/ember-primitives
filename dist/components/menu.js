
import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { guidFor } from '@ember/object/internals';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { getTabsterAttribute, MoverDirections, getTabster, setTabsterAttribute } from 'tabster';
import { Popover } from './popover.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const TABSTER_CONFIG_CONTENT = getTabsterAttribute({
  mover: {
    direction: MoverDirections.Both,
    cyclic: true
  },
  deloser: {}
}, true);
const TABSTER_CONFIG_TRIGGER = {
  deloser: {}
};
const Separator = setComponentTemplate(precompileTemplate("\n  <div role=\"separator\" ...attributes>\n    {{yield}}\n  </div>\n", {
  strictMode: true
}), templateOnly());
/**
 * We focus items on `pointerMove` to achieve the following:
 *
 * - Mouse over an item (it focuses)
 * - Leave mouse where it is and use keyboard to focus a different item
 * - Wiggle mouse without it leaving previously focused item
 * - Previously focused item should re-focus
 *
 * If we used `mouseOver`/`mouseEnter` it would not re-focus when the mouse
 * wiggles. This is to match native menu implementation.
 */
function focusOnHover(e) {
  const item = e.currentTarget;
  if (item instanceof HTMLElement) {
    item?.focus();
  }
}
const Item = setComponentTemplate(precompileTemplate("\n  {{!-- @glint-expect-error --}}\n  {{#let (if @onSelect (modifier on \"click\" @onSelect)) as |maybeClick|}}\n    <button type=\"button\" role=\"menuitem\" {{!-- @glint-expect-error --}} {{maybeClick}} {{on \"pointermove\" focusOnHover}} ...attributes>\n      {{yield}}\n    </button>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    on,
    focusOnHover
  })
}), templateOnly());
const installContent = modifier((element, _, {
  isOpen,
  triggerElement
}) => {
  // focus first focusable element on the content
  const tabster = getTabster(window);
  const firstFocusable = tabster?.focusable.findFirst({
    container: element
  });
  firstFocusable?.focus();
  // listen for "outside" clicks
  function onDocumentClick(e) {
    if (isOpen.current && e.target && !element.contains(e.target) && !triggerElement.current?.contains(e.target)) {
      isOpen.current = false;
    }
  }
  // listen for the escape key
  function onDocumentKeydown(e) {
    if (isOpen.current && e.key === "Escape") {
      isOpen.current = false;
    }
  }
  document.addEventListener("click", onDocumentClick);
  document.addEventListener("keydown", onDocumentKeydown);
  return () => {
    document.removeEventListener("click", onDocumentClick);
    document.removeEventListener("keydown", onDocumentKeydown);
  };
});
const Content = setComponentTemplate(precompileTemplate("\n  {{#if @isOpen.current}}\n    <@PopoverContent id={{@contentId}} role=\"menu\" data-tabster={{TABSTER_CONFIG_CONTENT}} tabindex=\"0\" {{installContent isOpen=@isOpen triggerElement=@triggerElement}} {{on \"click\" @isOpen.toggle}} ...attributes>\n      {{yield (hash Item=Item Separator=Separator)}}\n    </@PopoverContent>\n  {{/if}}\n", {
  strictMode: true,
  scope: () => ({
    TABSTER_CONFIG_CONTENT,
    installContent,
    on,
    hash,
    Item,
    Separator
  })
}), templateOnly());
const trigger = modifier((element, _, {
  triggerElement,
  isOpen,
  contentId,
  setReference,
  stopPropagation,
  preventDefault
}) => {
  element.setAttribute("aria-haspopup", "menu");
  if (isOpen.current) {
    element.setAttribute("aria-controls", contentId);
    element.setAttribute("aria-expanded", "true");
  } else {
    element.removeAttribute("aria-controls");
    element.setAttribute("aria-expanded", "false");
  }
  setTabsterAttribute(element, TABSTER_CONFIG_TRIGGER);
  const onTriggerClick = event => {
    if (stopPropagation) {
      event.stopPropagation();
    }
    if (preventDefault) {
      event.preventDefault();
    }
    isOpen.toggle();
  };
  element.addEventListener("click", onTriggerClick);
  triggerElement.current = element;
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  setReference(element);
  return () => {
    element.removeEventListener("click", onTriggerClick);
  };
});
const Trigger = setComponentTemplate(precompileTemplate("\n  <button type=\"button\" {{@triggerModifier stopPropagation=@stopPropagation preventDefault=@preventDefault}} ...attributes>\n    {{yield}}\n  </button>\n", {
  strictMode: true
}), templateOnly());
const IsOpen = () => cell(false);
const TriggerElement = () => cell();
class Menu extends Component {
  contentId = guidFor(this);
  static {
    setComponentTemplate(precompileTemplate("\n    {{#let (IsOpen) (TriggerElement) as |isOpen triggerEl|}}\n      <Popover @flipOptions={{@flipOptions}} @middleware={{@middleware}} @offsetOptions={{@offsetOptions}} @placement={{@placement}} @shiftOptions={{@shiftOptions}} @strategy={{@strategy}} @inline={{@inline}} as |p|>\n        {{#let (modifier trigger triggerElement=triggerEl isOpen=isOpen contentId=this.contentId setReference=p.setReference) as |triggerModifier|}}\n          {{yield (hash trigger=triggerModifier Trigger=(component Trigger triggerModifier=triggerModifier) Content=(component Content PopoverContent=p.Content isOpen=isOpen triggerElement=triggerEl contentId=this.contentId) arrow=p.arrow isOpen=isOpen.current)}}\n        {{/let}}\n      </Popover>\n    {{/let}}\n  ", {
      strictMode: true,
      scope: () => ({
        IsOpen,
        TriggerElement,
        Popover,
        trigger,
        hash,
        Trigger,
        Content
      })
    }), this);
  }
}

export { Menu, Menu as default };
//# sourceMappingURL=menu.js.map
