import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { next } from '@ember/runloop';
import { getTabsterAttribute, MoverDirections } from 'tabster';
import { uniqueId } from '../utils.js';
import { Portal } from './portal.js';
import { buildWaiter } from '@ember/test-waiters';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { g, i } from 'decorator-transforms/runtime';

/**
 * References:
 * - https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/tablist_role
 * - https://www.w3.org/WAI/ARIA/apg/patterns/tabs/
 *
 *
 * Keyboard behaviors (optionally) provided by tabster
 */
const UNSET = Symbol.for("ember-primitives:tabs:unset");
const TABSTER_CONFIG = getTabsterAttribute({
  mover: {
    direction: MoverDirections.Both,
    cyclic: true,
    hasDefault: true,
    memorizeCurrent: true
  },
  deloser: {}
}, true);
const TABSTER_SELECTED_TAB = getTabsterAttribute({
  focusable: {
    isDefault: true
  }
}, true);
function tabsterFor(isSelected) {
  return isSelected ? TABSTER_SELECTED_TAB : undefined;
}
const TabLink = setComponentTemplate(precompileTemplate("<a href=\"##missing##\" ...attributes role=\"tab\" aria-controls={{@panelId}} aria-selected={{String (@state.isActive @id @value)}} id={{@id}}>\n  {{yield}}\n</a>", {
  strictMode: true,
  scope: () => ({
    String
  })
}), templateOnly());
const TabButton = setComponentTemplate(precompileTemplate("<button ...attributes role=\"tab\" type=\"button\" aria-controls={{@panelId}} aria-selected={{String (@state.isActive @id @value)}} data-tabster={{tabsterFor (@state.isActive @id @value)}} id={{@id}} {{on \"click\" @handleClick}} {{!-- The Types for modifier are wrong --}} {{!-- @glint-expect-error--}} {{(if @state.isAutomatic (modifier on \"focus\" @handleClick))}}>\n  {{yield}}\n</button>", {
  strictMode: true,
  scope: () => ({
    String,
    tabsterFor,
    on
  })
}), templateOnly());
const TabContent = setComponentTemplate(precompileTemplate("{{#if (@state.isActive @tabId)}}\n  <div tabindex=\"0\" ...attributes role=\"tabpanel\" aria-labelledby={{@tabId}} id={{@id}}>\n    {{yield}}\n  </div>\n{{/if}}", {
  strictMode: true
}), templateOnly());
/**
 * Stands in for a part of a tab that the current pass does not render.
 */
const Nothing = setComponentTemplate(precompileTemplate("", {
  strictMode: true
}), templateOnly());
function isString(x) {
  return typeof x === "string";
}
function makeTab(tabButton, tabLink) {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
  tabButton.Link = tabLink;
  return tabButton;
}
class TabContainer extends Component {
  id = this.args.state.nextTabId(this.args.inPanel ?? false);
  get tabId() {
    return `${this.id}__tab`;
  }
  get panelId() {
    return `${this.id}__panel`;
  }
  get label() {
    return this.args.label ?? this.tabId;
  }
  static {
    setComponentTemplate(precompileTemplate("{{!--\n  <Tabs> renders its block two times, and each <Tab> renders one time in each pass:\n\n    1. the tablist pass (@inPanel is false), which renders only the tab button\n    2. the tabpanel pass (@inPanel is true), which renders only the panel\n\n  A user can invoke <Tab> in three ways:\n\n    <Tab @label=\"npm\" @content=\"npm add ember-primitives\" />\n\n    <Tab @label=\"npm\">npm add ember-primitives</Tab>\n\n    <Tab as |Label Content|>\n      <Label>npm</Label>\n      <Content>npm add ember-primitives</Content>\n    </Tab>\n\n  The first two ways pass @label, and the third way does not.\n  So each pass has one branch for @label and one branch for the yielded block.\n\n  Why two passes:\n  before, the panel rendered through a Portal into the tabpanel element.\n  The Portal finds its target in a modifier, so the panel appeared only in a second render.\n  When the client rehydrated server-rendered HTML, the first client render had no panel.\n  Rehydration then deleted the server panel, and the second render built it again.\n  The user saw the panel flash.\n--}}\n{{#if @inPanel}}\n  {{!--\n    Tabpanel pass of:\n      <Tab @label=\"npm\" @content=\"npm add ember-primitives\" />\n      <Tab @label=\"npm\">npm add ember-primitives</Tab>\n\n    The @label renders in the tablist pass, so this branch ignores it.\n  --}}\n  {{#if @label}}\n    <TabContent @state={{@state}} @id={{this.panelId}} @tabId={{this.tabId}}>\n      {{#if @content}}\n        {{#if (isString @content)}}\n          {{@content}}\n        {{else}}\n          <@content />\n        {{/if}}\n      {{else}}\n        {{yield}}\n      {{/if}}\n    </TabContent>\n  {{else}}\n    {{!--\n      Tabpanel pass of:\n        <Tab as |Label Content|>\n          <Label>npm</Label>\n          <Content>npm add ember-primitives</Content>\n        </Tab>\n\n      The block runs again in this pass, so it calls <Label> (or <Label.Link>) again.\n      (makeTab Nothing Nothing) makes <Label> and <Label.Link> render nothing here.\n\n      Without Nothing, each tab button renders a second time, inside the tabpanel element.\n      The page then has two elements with the same id, and a role=\"tab\" outside of the tablist.\n    --}}\n    {{yield (makeTab Nothing Nothing) (component TabContent state=@state id=this.panelId tabId=this.tabId)}}\n  {{/if}}\n{{else if @label}}\n  {{!--\n    Tablist pass of:\n      <Tab @label=\"npm\" @content=\"npm add ember-primitives\" />\n      <Tab @label=\"npm\">npm add ember-primitives</Tab>\n\n    This branch does not yield, so the content renders only in the tabpanel pass.\n  --}}\n  <TabButton @state={{@state}} @id={{this.tabId}} @value={{@value}} @panelId={{this.panelId}} @handleClick={{fn @state.handleChange this.tabId @value}}>\n    {{#if (isString @label)}}\n      {{@label}}\n    {{else}}\n      <@label />\n    {{/if}}\n  </TabButton>\n{{else}}\n  {{!--\n    Tablist pass of:\n      <Tab as |Label Content|>\n        <Label>npm</Label>\n        <Content>npm add ember-primitives</Content>\n      </Tab>\n\n    The block calls <Content> in this pass too, so Content is Nothing here.\n    Without Nothing, the panel renders inside the tablist element,\n    where only role=\"tab\" elements are valid, and it renders a second time in the tabpanel pass.\n  --}}\n  {{yield (makeTab (component TabButton state=@state value=@value id=this.tabId panelId=this.panelId handleClick=(fn @state.handleChange this.tabId @value)) (component TabLink state=@state value=@value id=this.tabId panelId=this.panelId)) Nothing}}\n{{/if}}", {
      strictMode: true,
      scope: () => ({
        TabContent,
        isString,
        makeTab,
        Nothing,
        TabButton,
        fn,
        TabLink
      })
    }), this);
  }
}
const Label = setComponentTemplate(precompileTemplate("<Portal @to=\"#{{@state.labelId}}\">\n  {{yield}}\n</Portal>", {
  strictMode: true,
  scope: () => ({
    Portal
  })
}), templateOnly());
/**
 * We're doing old skool hax with this, so we don't need to care about what the types think, really
 */
function makeAPI(tabContainer, labelComponent) {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-assignment
  tabContainer.Label = labelComponent;
  return tabContainer;
}
const stateWaiter = buildWaiter("ember-primitives:tabs");
/**
 * State bucket passed around to all the sub-components.
 *
 * Sort of a "Context", but with a bit of prop-drilling (which is more efficient than dom-context)
 */
class TabState {
  static {
    g(this.prototype, "_active", [tracked], function () {
      return null;
    });
  }
  #_active = (i(this, "_active"), void 0);
  static {
    g(this.prototype, "_label", [tracked]);
  }
  #_label = (i(this, "_label"), void 0);
  #first = null;
  id;
  labelId;
  tabpanelId;
  #token;
  #tabCount = 0;
  #panelCount = 0;
  constructor(args) {
    this.args = args;
    this.id = `ember-primitives-${uniqueId()}`;
    this.labelId = `${this.id}__label`;
    this.tabpanelId = `${this.id}__tabpanel`;
  }
  /**
  * The block of <Tabs> renders two times:
  * one time in the tablist for the tabs,
  * and one time after the tablist for the panels.
  *
  * The n-th tab and the n-th panel get the same id,
  * so that the aria attributes link them.
  */
  nextTabId(inPanel) {
    const index = inPanel ? this.#panelCount++ : this.#tabCount++;
    return `${this.id}__tab-${index}`;
  }
  get activationMode() {
    return this.args.activationMode ?? "automatic";
  }
  get isAutomatic() {
    return this.activationMode === "automatic";
  }
  /**
  * This function relies on the fact that during rendering,
  * the first component to be rendered will be first,
  * and it will be the one to set the secret first value,
  * which means all other tabs will not be first.
  *
  */
  isActive = (tabId, tabValue) => {
    /**
    * When users pass the @value to a tab, we use that for managing
    * the "active state" instead of the DOM ID.
    *
    * NOTE: DOM IDs must be unique across the whole document, but @value
    *     does not need to be unqiue.
    *          `@value` *should* be unique for the Tabs component though
    */
    const isSelected = x => {
      if (tabValue) return x === tabValue;
      return x === tabId;
    };
    if (this.active === UNSET) {
      if (this.#first) return isSelected(this.#first);
      this.#first = tabValue ?? tabId;
      this.#token = stateWaiter.beginAsync();
      // eslint-disable-next-line ember/no-runloop
      next(() => {
        if (!this.#token) return;
        stateWaiter.endAsync(this.#token);
        if (this._active) return;
        if (isDestroyed(this) || isDestroying(this)) return;
        this._label = tabValue ?? tabId;
      });
      return true;
    }
    return isSelected(this.active);
  };
  get active() {
    return this._active ?? this.args.activeTab ?? UNSET;
  }
  get activeLabel() {
    /**
    * This is only needed during the first set
    * because we prioritize rendering first, and then updating metadata later
    * (next render)
    *
    * NOTE: this does not mean that the a11y tree is updated later.
    *       it is correct on initial render
    */
    if (this._label) {
      return this._label;
    }
    if (this.active === UNSET) {
      return "Pending";
    }
    return this.active;
  }
  handleChange = (tabId, tabValue) => {
    const previous = this.active;
    const next = tabValue ?? tabId;
    // No change, no need to be noisy
    if (next === previous) return;
    this._active = this._label = next;
    this.args.onChange?.(next, previous === UNSET ? null : previous);
  };
}
class Tabs extends Component {
  state;
  // eslint-disable-next-line @typescript-eslint/no-empty-object-type
  constructor(owner, args) {
    super(owner, args);
    this.state = new TabState(args);
  }
  static {
    setComponentTemplate(precompileTemplate("<div class=\"ember-primitives__tabs\" ...attributes data-active={{this.state.activeLabel}}>\n  {{!-- This element will be portaled in to and replaced if tabs.Label is invoked --}}\n  <div class=\"ember-primitives__tabs__label\" id={{this.state.labelId}}>\n    {{#if (isString @label)}}\n      {{@label}}\n    {{else}}\n      <@label />\n    {{/if}}\n  </div>\n  <div class=\"ember-primitives__tabs__tablist\" role=\"tablist\" aria-labelledby={{this.state.labelId}} data-tabster={{TABSTER_CONFIG}}>\n    {{yield (makeAPI (component TabContainer state=this.state) (component Label state=this.state))}}\n  </div>\n  {{!--\n    The block renders again here for the panels,\n    so that the panels are in the first render, without a second pass.\n    That keeps the DOM of a server render when the client rehydrates it.\n    In this pass, the <Tabs> Label (the label of the whole tablist) is Nothing,\n    because the first pass already rendered it.\n    Without Nothing, a block that calls <Label> renders the label two times.\n  --}}\n  <div class=\"ember-primitives__tabs__tabpanel\" id={{this.state.tabpanelId}}>\n    {{yield (makeAPI (component TabContainer state=this.state inPanel=true) (component Nothing))}}\n  </div>\n</div>", {
      strictMode: true,
      scope: () => ({
        isString,
        TABSTER_CONFIG,
        makeAPI,
        TabContainer,
        Label,
        Nothing
      })
    }), this);
  }
}

export { Tabs };
//# sourceMappingURL=tabs.js.map
