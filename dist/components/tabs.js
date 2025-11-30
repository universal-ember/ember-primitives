
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
    memorizeCurrent: true
  },
  deloser: {}
}, true);
const TabLink = setComponentTemplate(precompileTemplate("\n  <a href=\"##missing##\" ...attributes role=\"tab\" aria-controls={{@panelId}} id={{@id}}>\n    {{yield}}\n  </a>\n", {
  strictMode: true
}), templateOnly());
const TabButton = setComponentTemplate(precompileTemplate("\n  <button ...attributes role=\"tab\" type=\"button\" aria-controls={{@panelId}} aria-selected={{String (@state.isActive @id @value)}} id={{@id}} {{on \"click\" @handleClick}} {{!-- The Types for modifier are wrong --}} {{!-- @glint-expect-error--}} {{(if @state.isAutomatic (modifier on \"focus\" @handleClick))}}>\n    {{yield}}\n  </button>\n", {
  strictMode: true,
  scope: () => ({
    String,
    on
  })
}), templateOnly());
const TabContent = setComponentTemplate(precompileTemplate("\n  <Portal @to=\"#{{@state.tabpanelId}}\" @append={{true}}>\n    {{#if (@state.isActive @tabId)}}\n      <div ...attributes role=\"tabpanel\" aria-labelledby={{@tabId}} id={{@id}}>\n        {{yield}}\n      </div>\n    {{/if}}\n  </Portal>\n", {
  strictMode: true,
  scope: () => ({
    Portal
  })
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
  id = `ember-primitives__tab-${uniqueId()}`;
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
    setComponentTemplate(precompileTemplate("\n    {{#if @label}}\n      <TabButton @state={{@state}} @id={{this.tabId}} @value={{@value}} @panelId={{this.panelId}} @handleClick={{fn @state.handleChange this.tabId @value}}>\n        {{#if (isString @label)}}\n          {{@label}}\n        {{else}}\n          <@label />\n        {{/if}}\n      </TabButton>\n\n      <TabContent @state={{@state}} @id={{this.panelId}} @tabId={{this.tabId}}>\n        {{#if @content}}\n          {{#if (isString @content)}}\n            {{@content}}\n          {{else}}\n            <@content />\n          {{/if}}\n        {{else}}\n          {{yield}}\n        {{/if}}\n      </TabContent>\n    {{else}}\n      {{yield (makeTab (component TabButton state=@state value=@value id=this.tabId panelId=this.panelId handleClick=(fn @state.handleChange this.tabId @value)) (component TabLink state=@state id=this.tabId panelId=this.panelId)) (component TabContent state=@state id=this.panelId tabId=this.tabId)}}\n    {{/if}}\n  ", {
      strictMode: true,
      scope: () => ({
        TabButton,
        fn,
        isString,
        TabContent,
        makeTab,
        TabLink
      })
    }), this);
  }
}
const Label = setComponentTemplate(precompileTemplate("\n  <Portal @to=\"#{{@state.labelId}}\">\n    {{yield}}\n  </Portal>\n", {
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
  constructor(args) {
    this.args = args;
    this.id = `ember-primitives-${uniqueId()}`;
    this.labelId = `${this.id}__label`;
    this.tabpanelId = `${this.id}__tabpanel`;
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
    setComponentTemplate(precompileTemplate("\n    <div class=\"ember-primitives__tabs\" ...attributes data-active={{this.state.activeLabel}}>\n      {{!-- This element will be portaled in to and replaced if tabs.Label is invoked --}}\n      <div class=\"ember-primitives__tabs__label\" id={{this.state.labelId}}>\n        {{#if (isString @label)}}\n          {{@label}}\n        {{else}}\n          <@label />\n        {{/if}}\n      </div>\n      <div class=\"ember-primitives__tabs__tablist\" role=\"tablist\" aria-labelledby={{this.state.labelId}} data-tabster={{TABSTER_CONFIG}}>\n        {{yield (makeAPI (component TabContainer state=this.state) (component Label state=this.state))}}\n      </div>\n      {{!--\n        Tab's contents are portaled in to this element\n      --}}\n      <div class=\"ember-primitives__tabs__tabpanel\" id={{this.state.tabpanelId}}></div>\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        isString,
        TABSTER_CONFIG,
        makeAPI,
        TabContainer,
        Label
      })
    }), this);
  }
}

export { Tabs };
//# sourceMappingURL=tabs.js.map
