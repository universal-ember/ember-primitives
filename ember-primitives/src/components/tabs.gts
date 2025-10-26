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
import type { ComponentLike, WithBoundArgs } from "@glint/template";

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
  };
  Blocks: {
    default: [];
  };
}> = <template>
  <button
    role="tab"
    type="button"
    aria-controls={{@panelId}}
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
     * for portalling the content to the correct location in the DOM
     * (since the tabs pattern (and most HTML patterns), don't support co-located definitions)
     */
    portalId: string;
    /**
     * @internal
     */
    isActive: boolean;
  };
  Blocks: {
    default: [];
  };
}> = <template>
  <Portal @to="[data-tabs-portal-id='{{@portalId}}']" @append={{true}}>
    {{#if @isActive}}
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
     * for portalling the content
     */
    portalId: string;
    /**
     * @internal
     * for coordinate state
     */
    active: string;

    /**
     * @internal
     * for coordinate state
     */
    handleClick: (selected: string) => void;

    /**
     * optional user-passable label
     */
    label?: string;
  };
  Blocks: {
    default: [
      trigger: WithBoundArgs<typeof TabButton, "panelId" | "id" | "handleClick">,
      content: WithBoundArgs<typeof TabContent, "id">,
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

  get isActive() {
    return this.args.active === this.tabId;
  }

  get label() {
    return this.args.label ?? this.tabId;
  }

  <template>
    {{#if @label}}
      <TabButton
        @id={{this.tabId}}
        @panelId={{this.panelId}}
        @handleClick={{fn @handleClick this.tabId}}
      >
        {{@label}}
      </TabButton>

      <TabContent
        @isActive={{this.isActive}}
        @id={{this.panelId}}
        @tabId={{this.tabId}}
        @portalId={{@portalId}}
      >
        {{yield}}
      </TabContent>
    {{else}}
      {{yield
        (makeTab
          (component
            TabButton id=this.tabId panelId=this.panelId handleClick=(fn @handleClick this.tabId)
          )
          TabLink
        )
        (component
          TabContent isActive=this.isActive id=this.panelId tabId=this.tabId portalId=@portalId
        )
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
    portalId: string;
  };
  Blocks: { default: [] };
}> = <template>
  <Portal @to="#{{@portalId}}">
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

export class Tabs extends Component<Signature> {
  id = `ember-primitives-${uniqueId()}`;

  @tracked _active: string | null = null;

  get active() {
    return this._active ?? "first?";
  }

  handleChange = (selected: string) => {
    const previous = this.active;

    this._active = selected;

    this.args.onChange?.(selected, previous);
  };

  get labelId() {
    return `${this.id}__label`;
  }

  get tabpanelId() {
    return `${this.id}__tabpanel`;
  }

  <template>
    <div class="ember-primitives__tabs" ...attributes data-active={{this.active}}>
      {{#unless @label}}
        {{! This element will be portaled in to and replaced if tabs.Label is invoked }}
        <div class="ember-primitives__tabl__label" id={{this.labelId}}>
          {{@label}}
        </div>
      {{/unless}}
      <div
        class="ember-primitives__tabs__tablist"
        ...attributes
        role="tablist"
        aria-labelledby={{this.labelId}}
        data-tabster={{TABSTER_CONFIG}}
      >
        {{yield
          (makeAPI
            (component
              TabContainer portalId=this.id active=this.active handleClick=this.handleChange
            )
          )
          (component Label portalId=this.labelId)
        }}
      </div>
      {{!
        Tab's contents are portaled in to this element
      }}
      <div class="ember-primitives__tabs__tabpanel" id={{this.tabpanelId}}></div>
    </div>
  </template>
}
