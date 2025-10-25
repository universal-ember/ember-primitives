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

import { uniqueId } from "../utils.ts";

import type { TOC } from "@ember/component/template-only";
import type { ComponentLike, WithBoundArgs } from "@glint/template";
import Portal from "./portal.gts";

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
  };
  Blocks: {
    default: [];
  };
}> = <template>
  <Portal @to="[data-tabs-portal-id='{{@portalId}}']" @append={{true}}>
    <div ...attributes role="tabpanel" aria-labelledby={{@tabId}} id={{@id}}>
      {{yield}}
    </div>
  </Portal>
</template>;

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
    {{#if this.isActive}}
      {{yield
        (component
          TabButton id=this.tabId panelId=this.panelId handleClick=(fn @handleClick this.tabId)
        )
        (component TabContent id=this.panelId buttonId=this.tabId portalId=@portalId)
      }}
    {{/if}}
  </template>
}

const Label: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
     * @internal
     * for linking of aria
     */
    tablistId: string;
  };
  Blocks: { default: [] };
}> = <template>
  <div ...attributes id="{{@tablistId}}-label">{{yield}}</div>
</template>;

const List: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
     * @internal
     * for linking of aria
     */
    tablistId: string;
    /**
     * @internal
     * for portaling
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
  };
  Blocks: {
    default: [tab: WithBoundArgs<typeof TabContainer, "portalId">];
  };
}> = <template>
  <div ...attributes role="tablist" aria-labelledby="{{@tablistId}}-label">
    {{yield (component TabContainer portalId=@portalId active=@active handleClick=@handleClick)}}
  </div>
</template>;

const ContentPortal: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
     * @internal
     * for linking of aria
     */
    id: string;
    /**
     * @internal
     * for portaling
     */
    portalId: string;
  };
}> = <template>
  <div ...attributes data-tabs-portal-id={{@portalId}} id={{@id}}></div>
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
     * When the tab changes, this function will be called.
     * The function receives both the newly selected tab as well as the previous tab.
     *
     * However, if the tabs are not configured with names, these values will be null.
     */
    onChange?: (selectedTab?: string, previousTab?: string) => void;
  };
  Blocks: {
    default: [
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
function makeListAPI(listComponent: any, labelComponent: any, contentCompoent: any): any {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
  listComponent.Label = labelComponent;
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-member-access
  listComponent.Content = contentCompoent;

  return listComponent;
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

  get tablistId() {
    return `${this.id}__tablist`;
  }

  <template>
    <div ...attributes data-active={{this.active}}>
      {{yield
        (makeListAPI
          (component
            List
            tablistId=this.tablistId
            portalId=this.id
            active=this.active
            handleClick=this.handleChange
          )
          (component Label tablistId=this.tablistId)
          (component ContentPortal portalId=this.id id=this.tablistId)
        )
      }}
    </div>
  </template>
}
