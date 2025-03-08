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
function focusOnHover(e1) {
  const item1 = e1.currentTarget;
  if (item1 instanceof HTMLElement) {
    item1?.focus();
  }
}
const Item = setComponentTemplate(precompileTemplate("\n  <button type=\"button\" role=\"menuitem\" {{!-- @glint-ignore !--}} {{(if @onSelect (modifier on \"click\" @onSelect))}} {{on \"pointermove\" focusOnHover}} ...attributes>\n    {{yield}}\n  </button>\n", {
  strictMode: true,
  scope: () => ({
    on,
    focusOnHover
  })
}), templateOnly());
const installContent = modifier((element1, _1, {
  isOpen: isOpen1,
  triggerElement: triggerElement1
}) => {
  // focus first focusable element on the content
  const tabster1 = getTabster(window);
  const firstFocusable1 = tabster1?.focusable.findFirst({
    container: element1
  });
  firstFocusable1?.focus();
  // listen for "outside" clicks
  function onDocumentClick1(e1) {
    if (isOpen1.current && e1.target && !element1.contains(e1.target) && !triggerElement1.current?.contains(e1.target)) {
      isOpen1.current = false;
    }
  }
  // listen for the escape key
  function onDocumentKeydown1(e1) {
    if (isOpen1.current && e1.key === 'Escape') {
      isOpen1.current = false;
    }
  }
  document.addEventListener('click', onDocumentClick1);
  document.addEventListener('keydown', onDocumentKeydown1);
  return () => {
    document.removeEventListener('click', onDocumentClick1);
    document.removeEventListener('keydown', onDocumentKeydown1);
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
const trigger = modifier((element1, _1, {
  triggerElement: triggerElement1,
  isOpen: isOpen1,
  contentId: contentId1,
  setReference: setReference1,
  stopPropagation: stopPropagation1,
  preventDefault: preventDefault1
}) => {
  element1.setAttribute('aria-haspopup', 'menu');
  if (isOpen1.current) {
    element1.setAttribute('aria-controls', contentId1);
    element1.setAttribute('aria-expanded', 'true');
  } else {
    element1.removeAttribute('aria-controls');
    element1.setAttribute('aria-expanded', 'false');
  }
  setTabsterAttribute(element1, TABSTER_CONFIG_TRIGGER);
  const onTriggerClick1 = event1 => {
    if (stopPropagation1) {
      event1.stopPropagation();
    }
    if (preventDefault1) {
      event1.preventDefault();
    }
    isOpen1.toggle();
  };
  element1.addEventListener('click', onTriggerClick1);
  triggerElement1.current = element1;
  setReference1(element1);
  return () => {
    element1.removeEventListener('click', onTriggerClick1);
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
