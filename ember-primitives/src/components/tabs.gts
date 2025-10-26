/**
 * References:
 * - https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/tablist_role
 * - https://www.w3.org/WAI/ARIA/apg/patterns/tabs/
 *
 *
 * Keyboard behaviors (optionally) provided by tabster
 */

import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";

import { getTabsterAttribute, MoverDirections } from "tabster";

import { uniqueId } from "../utils.ts";
import Portal from "./portal.gts";

import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { ComponentLike, WithBoundArgs } from "@glint/template";

const UNSET = Symbol.for("ember-primitives:tabs:unset");

const TABSTER_CONFIG = getTabsterAttribute(
  {
    mover: {
      direction: MoverDirections.Both,
      cyclic: true,
    },
    deloser: {},
  },
  true,
);

const TabLink: TOC<{
  Element: HTMLAnchorElement;
  Args: {
    /**
     * @internal
     * for linking of aria
     */
    id: string;
    /**
     * @internal
     * for linking of aria
     */
    panelId: string;
  };
  Blocks: { default: [] };
}> = <template>
  <a ...attributes role="tab" aria-controls={{@panelId}} id={{@id}}>
    {{yield}}
  </a>
</template>;

const TabButton: TOC<{
  Args: {
    /**
     * @internal
     * for linking of aria
     */
    id: string;
    /**
     * @internal
     * for linking of aria
     */
    panelId: string;

    /**
     * @internal
     * for managing state
     */
    handleClick: () => void;

    /**
     * @internal
     */
    state: TabState;
  };
  Blocks: {
    default: [];
  };
}> = <template>
  <button
    role="tab"
    type="button"
    aria-controls={{@panelId}}
    aria-selected={{String (@state.isActive @id)}}
    id={{@id}}
    {{on "click" @handleClick}}
  >
    {{yield}}
  </button>
</template>;

const TabContent: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
     * @internal
     * for linking of aria
     */
    id: string;
    /**
     * @internal
     * for linking of aria
     */
    tabId: string;
    /**
     * @internal
     */
    state: TabState;
  };
  Blocks: {
    default: [];
  };
}> = <template>
  <Portal @to="#{{@state.tabpanelId}}" @append={{true}}>
    {{#if (@state.isActive @tabId)}}
      <div ...attributes role="tabpanel" aria-labelledby={{@tabId}} id={{@id}}>
        {{yield}}
      </div>
    {{/if}}
  </Portal>
</template>;

function makeTab(tabButton: any, tabLink: any): any {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
  tabButton.Link = tabLink;

  return tabButton;
}

class TabContainer extends Component<{
  Args: {
    /**
     * @internal
     */
    state: TabState;

    /**
     * When opting for a "controlled component",
     * the value will be needed to make sense of the selected tab.
     *
     * The default value used for communication within the Tabs component (and eventually emitted via the @onChange argument) is a unique random id.
     * So while that could still be used for controlling the tabs component, it may be more easy to grok with user-managed values.
     */
    value?: string;

    /**
     * optional user-passable label
     */
    label?: string;
  };
  Blocks: {
    default: [
      trigger: WithBoundArgs<typeof TabButton, "state">,
      content: WithBoundArgs<typeof TabContent, "state">,
    ];
  };
}> {
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

  <template>
    {{#if @label}}
      <TabButton
        @state={{@state}}
        @id={{this.tabId}}
        @panelId={{this.panelId}}
        @handleClick={{fn @state.handleChange this.tabId}}
      >
        {{@label}}
      </TabButton>

      <TabContent @state={{@state}} @id={{this.panelId}} @tabId={{this.tabId}}>
        {{yield}}
      </TabContent>
    {{else}}
      {{yield
        (makeTab
          (component
            TabButton
            state=@state
            id=this.tabId
            panelId=this.panelId
            handleClick=(fn @state.handleChange this.tabId)
          )
          (component TabLink state=@state id=this.tabId panelId=this.panelId)
        )
        (component TabContent state=@state id=this.panelId tabId=this.tabId)
      }}
    {{/if}}
  </template>
}

const Label: TOC<{
  /**
   * The label wiring (id, aria, etc) are handled for you.
   * If you'd like to use a heading element (h3, etc), place that in the block content
   * when invoking this Label component.
   */
  Element: null;
  Args: {
    /**
     * @internal
     */
    state: TabState;
  };
  Blocks: { default: [] };
}> = <template>
  <Portal @to="#{{@state.tabpanelId}}">
    {{yield}}
  </Portal>
</template>;

export interface Signature {
  /**
   * The wrapping element for the overall Tabs component.
   * This should be used for styling the layout of the tabs.
   */
  Element: HTMLDivElement;
  Args: {
    /**
     * Sets the active tab.
     * If not passed, the first tab will be selected
     */
    activeTab?: string;
    /**
     * Optional label for the overall TabList
     */
    label?: string;
    /**
     * When the tab changes, this function will be called.
     * The function receives both the newly selected tab as well as the previous tab.
     *
     * However, if the tabs are not configured with names, these values will be null.
     */
    onChange?: (selectedTab?: string, previousTab?: string) => void;
  };
  Blocks: {
    default: [
      Tab: WithBoundArgs<typeof TabContainer, "portalId"> & {
        Label: WithBoundArgs<typeof Label, "portalId">;
      },
      TabList: ComponentLike<{
        Element: HTMLDivElement;
        Blocks: {
          default: [
            /**
             * This is an element-less component that acts as a way to organize / co-locate
             * the definition of the tab, and the content for that tab
             */
            tab: ComponentLike<{
              Element: null;
              Blocks: {
                default: [
                  /**
                   * The Tab button
                   */
                  trigger: ComponentLike<{
                    Element: HTMLDivElement;
                    Blocks: { default: [] };
                  }>,
                  /**
                   * The content for the tab.
                   * This will be rendered in the correct place in the DOM
                   */
                  content: ComponentLike<{
                    Element: HTMLDivElement;
                    Blocks: { default: [] };
                  }>,
                ];
              };
            }>,
          ];
        };
      }> & {
        Label: ComponentLike<{
          Element: HTMLDivElement;
          Blocks: { default: [] };
        }>;
        Content: ComponentLike<{
          /**
           * The element of the portal target may be styled
           */
          Element: HTMLDivElement;
        }>;
      },
    ];
  };
}

/**
 * We're doing old skool hax with this, so we don't need to care about what the types think, really
 */
function makeAPI(tabContainer: any, labelComponent: any): any {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
  tabContainer.Label = labelComponent;

  return tabContainer;
}

/**
 * State bucket passed around to all the sub-components.
 *
 * Sort of a "Context", but with a bit of prop-drilling (which is more efficient than dom-context)
 */
class TabState {
  declare args: {
    activeTab?: string;
    onChange?: (selected: string, previous: string | null) => void;
  };

  @tracked _active: string | null = null;

  #first: string | null = null;
  id: string;
  labelId: string;
  tabpanelId: string;

  constructor(args: { activeTab?: string; onChange?: () => void }) {
    this.args = args;

    this.id = `ember-primitives-${uniqueId()}`;
    this.labelId = `${this.id}__label`;
    this.tabpanelId = `${this.id}__tabpanel`;
  }

  /**
   * This function relies on the fact that during rendering,
   * the first component to be rendered will be first,
   * and it will be the one to set the secret first value,
   * which means all other tabs will not be first.
   *
   */
  isActive = (tabId: string) => {
    if (this.active === UNSET) {
      if (this.#first) return tabId === this.#first;

      this.#first = tabId;

      return true;
    }

    return this.active == tabId;
  };

  get active() {
    return this._active ?? this.args.activeTab ?? UNSET;
  }

  handleChange = (selected: string) => {
    const previous = this.active;

    this._active = selected;

    this.args.onChange?.(selected, previous === UNSET ? null : previous);
  };
}

export class Tabs extends Component<Signature> {
  state: TabState;

  // eslint-disable-next-line @typescript-eslint/no-empty-object-type
  constructor(owner: Owner, args: {}) {
    super(owner, args);

    this.state = new TabState(args);
  }

  <template>
    <div class="ember-primitives__tabs" ...attributes data-active={{this.state.active}}>
      {{! This element will be portaled in to and replaced if tabs.Label is invoked }}
      <div class="ember-primitives__tabl__label" id={{this.state.labelId}}>
        {{@label}}
      </div>
      <div
        class="ember-primitives__tabs__tablist"
        ...attributes
        role="tablist"
        aria-labelledby={{this.state.labelId}}
        data-tabster={{TABSTER_CONFIG}}
      >
        {{yield
          (makeAPI (component TabContainer state=this.state))
          (component Label state=this.state)
        }}
      </div>
      {{!
        Tab's contents are portaled in to this element
      }}
      <div class="ember-primitives__tabs__tabpanel" id={{this.state.tabpanelId}}></div>
    </div>
  </template>
}
