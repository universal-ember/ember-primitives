/**
 * References:
 * - https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Roles/tablist_role
 * - https://www.w3.org/WAI/ARIA/apg/patterns/tabs/
 *
 *
 * Keyboard behaviors (optionally) provided by tabster
 */
import Component from "@glimmer/component";
import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { ComponentLike, WithBoundArgs } from "@glint/template";
declare const UNSET: unique symbol;
export type ButtonType = ComponentLike<ButtonSignature>;
export interface ButtonSignature {
    Element: HTMLButtonElement;
    Blocks: {
        default: [];
    };
}
declare const TabButton: TOC<{
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
         * for managing state
         */
        value: string | undefined;
        /**
         * @internal
         */
        state: TabState;
    };
    Blocks: {
        default: [];
    };
}>;
export type ContentType = ComponentLike<ContentSignature>;
export interface ContentSignature {
    /**
     * the [role=tabpanel] element
     */
    Element: HTMLDivElement;
    Blocks: {
        default: [];
    };
}
declare const TabContent: TOC<{
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
}>;
export type ContainerType = ComponentLike<ContainerSignature>;
export type ContainerSignature = {
    Blocks: {
        default: [];
    };
} | {
    Args: {
        label: string | ComponentLike;
        content: string | ComponentLike;
    };
} | {
    Args: {
        label: string | ComponentLike;
    };
    Blocks: {
        /**
         * The content for the tab
         */
        default: [];
    };
};
declare class TabContainer extends Component<{
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
        label?: string | ComponentLike;
        /**
         * optional user-passable content.
         */
        content?: string | ComponentLike;
    };
    Blocks: {
        default: [
            Label: WithBoundArgs<typeof TabButton, "state" | "id" | "panelId" | "handleClick" | "value">,
            Content: WithBoundArgs<typeof TabContent, "state" | "id" | "tabId">
        ];
    };
}> {
    id: string;
    get tabId(): string;
    get panelId(): string;
    get label(): string | ComponentLike;
}
declare const Label: TOC<{
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
    Blocks: {
        default: [];
    };
}>;
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
        label?: string | ComponentLike;
        /**
         * When the tab changes, this function will be called.
         * The function receives both the newly selected tab as well as the previous tab.
         *
         * However, if the tabs are not configured with names, these values will be null.
         */
        onChange?: (selectedTab: string, previousTab: string | null) => void;
        /**
         * When activationMode is set to "automatic", tabs are activated when receiving focus. When set to "manual", tabs are activated when clicked (or when "enter" is pressed via the keyboard).
         */
        activationMode?: "automatic" | "manual";
    };
    Blocks: {
        default: [
            Tab: WithBoundArgs<typeof TabContainer, "state"> & {
                Label: WithBoundArgs<typeof Label, "state">;
            }
        ];
    };
}
/**
 * State bucket passed around to all the sub-components.
 *
 * Sort of a "Context", but with a bit of prop-drilling (which is more efficient than dom-context)
 */
declare class TabState {
    #private;
    args: {
        activeTab?: string;
        activationMode?: "automatic" | "manual";
        onChange?: (selected: string, previous: string | null) => void;
    };
    _active: string | null;
    _label: string | undefined;
    id: string;
    labelId: string;
    tabpanelId: string;
    constructor(args: {
        activeTab?: string;
        onChange?: () => void;
    });
    get activationMode(): "automatic" | "manual";
    get isAutomatic(): boolean;
    /**
     * This function relies on the fact that during rendering,
     * the first component to be rendered will be first,
     * and it will be the one to set the secret first value,
     * which means all other tabs will not be first.
     *
     */
    isActive: (tabId: string, tabValue: undefined | string) => boolean;
    get active(): string | typeof UNSET;
    get activeLabel(): string;
    handleChange: (tabId: string, tabValue: string | undefined) => void;
}
export declare class Tabs extends Component<Signature> {
    state: TabState;
    constructor(owner: Owner, args: {});
}
export {};
//# sourceMappingURL=tabs.d.ts.map