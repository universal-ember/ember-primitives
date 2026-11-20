import "./resizable.css";
import Component from "@glimmer/component";
import { GroupState } from "./resizable/state.ts";
import type { Orientation } from "./resizable/state.ts";
import type { TOC } from "@ember/component/template-only";
export type { Orientation };
export interface PanelSignature {
    Element: HTMLDivElement;
    Args: {
        /**
         * The smallest size (in % of the group) this panel may be resized to.
         * Defaults to 0.
         */
        minSize?: number;
        /**
         * The largest size (in % of the group) this panel may be resized to.
         * Defaults to 100.
         */
        maxSize?: number;
        /**
         * The initial size (in % of the group).
         * Panels without a size share the remaining space equally.
         */
        size?: number;
        /**
         * When true, pressing Enter on the handle after this panel
         * collapses the panel to 0 (and restores it on the next press),
         * and dragging well past `@minSize` snaps it closed.
         *
         * While collapsed, the panel has a `data-collapsed` attribute.
         */
        collapsible?: boolean;
    };
    Blocks: {
        default: [];
    };
}
export declare const Panel: TOC<PanelSignature>;
export interface HandleSignature {
    Element: HTMLDivElement;
    Blocks: {
        default: [];
    };
}
/**
 * The draggable (and keyboard-operable) divider between two Panels.
 *
 * Follows the WAI-ARIA window-splitter pattern, and controls the Panel
 * immediately before it. Finds its group via DOM context, so it must be
 * rendered inside a `<Resizable>`.
 *
 * Give each handle an accessible name (e.g. `aria-label="Resize sidebar"`).
 */
export declare const Handle: TOC<HandleSignature>;
export interface Signature {
    Element: HTMLDivElement;
    Args: {
        /**
         * Which direction the panels are laid out in.
         *
         * `horizontal` (the default) places panels side-by-side (resizing along the x-axis),
         * `vertical` stacks them (resizing along the y-axis).
         *
         * May be changed while rendered; panels keep their sizes.
         */
        orientation?: Orientation;
        /**
         * Called with the panels' sizes (percentages, in document order)
         * whenever the layout changes.
         *
         * Useful for persisting the layout.
         */
        onLayoutChange?: (sizes: number[]) => void;
    };
    Blocks: {
        default: [];
    };
}
/**
 * A group of resizable panels, separated by draggable handles.
 *
 * Render `<Panel>` and `<Handle>` components inside -- they are their
 * own imports, and find the group via DOM context / DOM queries.
 *
 * Groups can be nested (a `<Resizable>` inside a Panel) to build
 * tree-shaped tiling layouts, i3 / tmux style.
 */
export declare class Resizable extends Component<Signature> {
    state: GroupState;
    attach: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLElement;
    }>;
}
//# sourceMappingURL=resizable.d.ts.map