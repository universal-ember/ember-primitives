import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { guidFor } from "@ember/object/internals";

import { element } from "ember-element-helper";
import { modifier as eModifier } from "ember-modifier";

import { Portal } from "./portal.gts";
import { TARGETS } from "./portal-targets.gts";

import type { TOC } from "@ember/component/template-only";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

type Direction = "top" | "bottom" | "left" | "right";
type Placement = `${Direction}${"" | "-start" | "-end"}`;

export type ShiftOptions = boolean | number | { padding?: number };

export interface Signature {
  Args: {
    /**
     * Where to place the floating element relative to its reference element.
     * The default is 'bottom'.
     *
     * Possible values are
     * - top
     * - bottom
     * - right
     * - left
     *
     * And may optionally have `-start` or `-end` added to adjust position along the side.
     *
     * Uses CSS anchor positioning (`position-area`) under the hood.
     */
    placement?: Placement;

    /**
     * Gap in pixels between the anchor element and the floating content.
     * Applied as CSS margin on the side facing the anchor.
     *
     * @example
     * ```gjs
     * <Popover @offset={{8}} as |p|>…</Popover>
     * ```
     */
    offset?: number;

    /**
     * When truthy, slides the floating element along its placement axis to keep it
     * within the viewport. Pass a number or `{ padding }` to set the minimum
     * distance (in pixels) from the viewport edge.
     *
     * Implemented via a `requestAnimationFrame` correction after initial placement —
     * the CSS Anchor Positioning API has no native shift equivalent yet.
     *
     * @example
     * ```gjs
     * <Popover @shift={{true}} as |p|>…</Popover>
     * <Popover @shift={{8}} as |p|>…</Popover>
     * <Popover @shift={{hash padding=8}} as |p|>…</Popover>
     * ```
     */
    shift?: ShiftOptions;

    /**
     * By default, the popover is portaled.
     * If you don't control your CSS, and the positioning of the popover content
     * is misbehaving, you may pass "@inline={{true}}" to opt out of portalling.
     *
     * Inline may also be useful in nested menus, where you know exactly how the nesting occurs
     */
    inline?: boolean;
  };
  Blocks: {
    default: [
      {
        reference: ModifierLike<{ Element: HTMLElement | SVGElement }>;
        setReference: (element: HTMLElement | SVGElement) => void;
        Content: WithBoundArgs<typeof Content, "floating" | "inline">;
      },
    ];
  };
}

function getElementTag(tagName: undefined | string) {
  return tagName || "div";
}

/**
 * Allows lazy evaluation of the portal target (do nothing until rendered)
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    floating: ModifierLike<{ Element: HTMLElement }>;
    inline?: boolean;
    /**
     * By default the popover content is wrapped in a div.
     * You may change this by supplying the name of an element here.
     *
     * For example:
     * ```gjs
     * <Popover as |p|>
     *  <p.Content @as="dialog">
     *    this is now focus trapped
     *  </p.Content>
     * </Popover>
     * ```
     */
    as?: string;
  };
  Blocks: { default: [] };
}> = <template>
  {{#let (element (getElementTag @as)) as |El|}}
    {{#if @inline}}
      {{! @glint-ignore
            https://github.com/tildeio/ember-element-helper/issues/91
            https://github.com/typed-ember/glint/issues/610
      }}
      <El {{@floating}} ...attributes>
        {{yield}}
      </El>
    {{else}}
      <Portal @to={{TARGETS.popover}}>
        {{! @glint-ignore
              https://github.com/tildeio/ember-element-helper/issues/91
              https://github.com/typed-ember/glint/issues/610
        }}
        <El {{@floating}} ...attributes>
          {{yield}}
        </El>
      </Portal>
    {{/if}}
  {{/let}}
</template>;

const PLACEMENT_TO_POSITION_AREA: Record<string, string> = {
  bottom: "bottom",
  top: "top",
  left: "left",
  right: "right",
  "bottom-start": "bottom left",
  "bottom-end": "bottom right",
  "top-start": "top left",
  "top-end": "top right",
  "left-start": "left top",
  "left-end": "left bottom",
  "right-start": "right top",
  "right-end": "right bottom",
};

const applyAnchorName = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: { Named: { anchorName: string } };
}>((el, _, { anchorName }) => {
  el.style.setProperty("anchor-name", anchorName);

  return () => {
    el.style.removeProperty("anchor-name");
  };
});

// Maps each primary placement side to the CSS margin property that creates a gap
// between the anchor edge and the floating element.
const SIDE_TO_OFFSET_MARGIN: Record<Direction, string> = {
  bottom: "margin-top",
  top: "margin-bottom",
  left: "margin-right",
  right: "margin-left",
};

function getShiftPadding(shift: ShiftOptions): number {
  if (typeof shift === "boolean") return 0;
  if (typeof shift === "number") return shift;
  if (typeof shift === "object" && shift !== null && shift.padding !== undefined) return shift.padding;

  return 0;
}

const applyAnchorPositioning = eModifier<{
  Element: HTMLElement;
  Args: { Named: { anchorName: string; placement?: Placement; offset?: number; shift?: ShiftOptions } };
}>((el, _, { anchorName, placement = "bottom", offset, shift }) => {
  const side = placement.split("-")[0] as Direction;
  const positionArea = PLACEMENT_TO_POSITION_AREA[placement] ?? "bottom";

  el.style.setProperty("position", "fixed");
  el.style.setProperty("position-anchor", anchorName);
  el.style.setProperty("position-area", positionArea);
  // Try flipping along the block axis, inline axis, or both before overflowing — analogous
  // to the flip/shift middleware from Floating UI.
  el.style.setProperty("position-try-fallbacks", "flip-block, flip-inline, flip-block flip-inline");

  // Offset: add a pixel gap between the anchor and the floating element via margin.
  if (offset) {
    el.style.setProperty(SIDE_TO_OFFSET_MARGIN[side], `${offset}px`);
  }

  // Shift: after layout, slide the element along its axis to keep it in the viewport.
  // CSS Anchor Positioning has no native shift equivalent, so we use a rAF correction.
  let rafId: ReturnType<typeof requestAnimationFrame> | undefined;

  if (shift) {
    const padding = getShiftPadding(shift);

    rafId = requestAnimationFrame(() => {
      const rect = el.getBoundingClientRect();
      const vw = window.innerWidth;
      const vh = window.innerHeight;

      if (side === "bottom" || side === "top") {
        // Shift along the horizontal (inline) axis.
        const overflowRight = rect.right - (vw - padding);
        const overflowLeft = padding - rect.left;

        if (overflowRight > 0) {
          el.style.setProperty("margin-left", `${-overflowRight}px`);
        } else if (overflowLeft > 0) {
          el.style.setProperty("margin-left", `${overflowLeft}px`);
        }
      } else {
        // Shift along the vertical (block) axis for left/right placements.
        const overflowBottom = rect.bottom - (vh - padding);
        const overflowTop = padding - rect.top;

        if (overflowBottom > 0) {
          el.style.setProperty("margin-top", `${-overflowBottom}px`);
        } else if (overflowTop > 0) {
          el.style.setProperty("margin-top", `${overflowTop}px`);
        }
      }
    });
  }

  return () => {
    if (rafId !== undefined) cancelAnimationFrame(rafId);
    el.style.removeProperty("position");
    el.style.removeProperty("position-anchor");
    el.style.removeProperty("position-area");
    el.style.removeProperty("position-try-fallbacks");
    el.style.removeProperty("margin-top");
    el.style.removeProperty("margin-bottom");
    el.style.removeProperty("margin-left");
    el.style.removeProperty("margin-right");
  };
});

export class Popover extends Component<Signature> {
  anchorName = `--popover-${guidFor(this)}`;

  setReference = (el: HTMLElement | SVGElement) => {
    // Programmatic alternative to the `{{reference}}` modifier — used when the caller manages
    // the element reference directly (e.g. the Menu trigger modifier) rather than via template.
    el.style.setProperty("anchor-name", this.anchorName);
  };

  <template>
    {{#let
      (modifier applyAnchorName anchorName=this.anchorName)
      (modifier applyAnchorPositioning anchorName=this.anchorName placement=@placement offset=@offset shift=@shift)
      as |reference floating|
    }}
      {{yield
        (hash
          reference=reference
          setReference=this.setReference
          Content=(component Content floating=floating inline=@inline)
        )
      }}
    {{/let}}
  </template>
}

export default Popover;
