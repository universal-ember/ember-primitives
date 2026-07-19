import "./resizable.css";

import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

import { modifier } from "ember-modifier";

import { GroupState, HandleState, PanelState } from "./resizable/state.ts";

import type { Orientation } from "./resizable/state.ts";
import type { WithBoundArgs } from "@glint/template";

export type { Orientation };

export interface PanelSignature {
  Element: HTMLDivElement;
  Args: {
    /**
     * @internal
     * Provided by the containing `<Resizable>`.
     */
    state: GroupState;
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
     * Panels without a defaultSize share the remaining space equally.
     */
    defaultSize?: number;
    /**
     * When true, pressing Enter on the handle after this panel
     * collapses the panel to 0 (and restores it on the next press).
     */
    collapsible?: boolean;
  };
  Blocks: {
    default: [
      {
        /**
         * Whether this panel is currently collapsed.
         */
        isCollapsed: boolean;
      },
    ];
  };
}

class Panel extends Component<PanelSignature> {
  panelState = new PanelState({
    minSize: () => this.args.minSize,
    maxSize: () => this.args.maxSize,
    defaultSize: () => this.args.defaultSize,
    collapsible: () => this.args.collapsible,
  });

  register = modifier((element: HTMLElement) => {
    this.panelState.element = element;
    this.args.state.registerPanel(this.panelState);

    return () => this.args.state.unregisterPanel(this.panelState);
  });

  <template>
    <div
      id={{this.panelState.id}}
      class="ember-primitives__resizable__panel"
      data-collapsed={{if this.panelState.isCollapsed "true"}}
      style={{this.panelState.style}}
      {{this.register}}
      ...attributes
    >
      {{yield (hash isCollapsed=this.panelState.isCollapsed)}}
    </div>
  </template>
}

export interface HandleSignature {
  Element: HTMLDivElement;
  Args: {
    /**
     * @internal
     * Provided by the containing `<Resizable>`.
     */
    state: GroupState;
  };
  Blocks: {
    default: [];
  };
}

class Handle extends Component<HandleSignature> {
  handleState = new HandleState(this.args.state);

  register = modifier((element: HTMLElement) => {
    this.handleState.element = element;
  });

  onPointerDown = (event: PointerEvent) => {
    if (this.handleState.element) {
      this.args.state.startDrag(this.handleState.element, event);
    }
  };

  onKeyDown = (event: KeyboardEvent) => {
    if (this.handleState.element) {
      this.args.state.handleKeyDown(this.handleState.element, event);
    }
  };

  <template>
    <div
      class="ember-primitives__resizable__handle"
      role="separator"
      tabindex="0"
      data-orientation={{this.args.state.orientation}}
      aria-orientation={{this.handleState.ariaOrientation}}
      aria-valuenow={{this.handleState.valueNow}}
      aria-valuemin={{this.handleState.valueMin}}
      aria-valuemax={{this.handleState.valueMax}}
      aria-controls={{this.handleState.controls}}
      {{this.register}}
      {{on "pointerdown" this.onPointerDown}}
      {{on "keydown" this.onKeyDown}}
      ...attributes
    >
      {{yield}}
    </div>
  </template>
}

export interface Signature {
  Element: HTMLDivElement;
  Args: {
    /**
     * Which direction the panels are laid out in.
     *
     * `horizontal` (the default) places panels side-by-side (resizing along the x-axis),
     * `vertical` stacks them (resizing along the y-axis).
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
    default: [
      {
        /**
         * A resizable region.
         *
         * A `<Resizable>` may be rendered inside a Panel to
         * create nested (tree-shaped) layouts.
         */
        Panel: WithBoundArgs<typeof Panel, "state">;
        /**
         * The draggable (and keyboard-operable) divider between two Panels.
         *
         * Follows the WAI-ARIA window-splitter pattern, and controls
         * the Panel immediately before it.
         */
        Handle: WithBoundArgs<typeof Handle, "state">;
      },
    ];
  };
}

/**
 * A group of resizable panels, separated by draggable handles.
 *
 * Groups can be nested (a `<Resizable>` inside a Panel) to build
 * tree-shaped tiling layouts, i3 / tmux style.
 */
export class Resizable extends Component<Signature> {
  state = new GroupState({
    orientation: () => this.args.orientation,
    onLayoutChange: () => this.args.onLayoutChange,
  });

  <template>
    <div
      class="ember-primitives__resizable"
      data-orientation={{this.state.orientation}}
      ...attributes
    >
      {{yield
        (hash Panel=(component Panel state=this.state) Handle=(component Handle state=this.state))
      }}
    </div>
  </template>
}

export default Resizable;
