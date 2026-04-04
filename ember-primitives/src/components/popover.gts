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

export interface Signature {
  Args: {
    /**
     * @deprecated Flip behavior is now handled automatically by CSS Anchor Positioning
     * via `position-try-fallbacks`. This argument is accepted but ignored.
     */
    flipOptions?: Record<string, unknown>;
    /**
     * @deprecated Floating UI middleware is no longer used. Positioning is handled
     * by CSS Anchor Positioning. This argument is accepted but ignored.
     */
    middleware?: unknown[];
    /**
     * Offset distance between the reference and floating elements.
     * Can be a number (pixels) or an object with `mainAxis` and/or `crossAxis` values.
     */
    offsetOptions?: number | { mainAxis?: number; crossAxis?: number };
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
     */
    placement?: Placement;
    /**
     * @deprecated Shift behavior is now handled automatically by CSS Anchor Positioning.
     * This argument is accepted but ignored.
     */
    shiftOptions?: Record<string, unknown>;
    /**
     * CSS position property, either `fixed` or `absolute`.
     * Default is 'fixed'.
     */
    strategy?: "fixed" | "absolute";
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
        Content: WithBoundArgs<
          typeof Content,
          "anchorName" | "placement" | "strategy" | "offsetOptions"
        >;
        data: undefined;
        arrow: ModifierLike<{ Element: HTMLElement }>;
      },
    ];
  };
}

function getElementTag(tagName: undefined | string) {
  return tagName || "div";
}

/**
 * Maps a placement to CSS position-area and self-alignment values.
 *
 * The position-area grid has the anchor element at center.
 * For -start/-end variants, we use span-right/span-left (or span-bottom/span-top)
 * to create an area starting at the anchor's edge, then align within that area.
 */
function getAnchorStyles(placement: Placement): {
  positionArea: string;
  selfProp: string;
  selfValue: string;
} {
  const side = placement.split("-")[0] as Direction;
  const alignment = placement.split("-")[1] as "start" | "end" | undefined;
  const isVertical = side === "top" || side === "bottom";

  if (!alignment) {
    return {
      positionArea: side,
      selfProp: isVertical ? "justify-self" : "align-self",
      selfValue: "anchor-center",
    };
  }

  if (isVertical) {
    return {
      positionArea: alignment === "start" ? `${side} span-right` : `${side} span-left`,
      selfProp: "justify-self",
      selfValue: alignment === "start" ? "start" : "end",
    };
  }

  return {
    positionArea: alignment === "start" ? `${side} span-bottom` : `${side} span-top`,
    selfProp: "align-self",
    selfValue: alignment === "start" ? "start" : "end",
  };
}

const OFFSET_MARGIN: Record<Direction, string> = {
  bottom: "margin-top",
  top: "margin-bottom",
  left: "margin-right",
  right: "margin-left",
};

const CROSS_OFFSET_MARGIN: Record<Direction, string> = {
  bottom: "margin-left",
  top: "margin-left",
  left: "margin-top",
  right: "margin-top",
};

/**
 * Modifier applied to the floating element to set CSS Anchor Positioning styles.
 */
const cssAnchorPosition = eModifier<{
  Element: HTMLElement;
  Args: {
    Named: {
      anchorName: string;
      placement: Placement;
      strategy: "fixed" | "absolute";
      offsetOptions?: number | { mainAxis?: number; crossAxis?: number };
    };
  };
}>((element, _: [], named) => {
  const placement = named.placement;
  const { positionArea, selfProp, selfValue } = getAnchorStyles(placement);
  const side = placement.split("-")[0] as Direction;

  const offsetOptions = named.offsetOptions ?? 0;
  const mainAxis =
    typeof offsetOptions === "number" ? offsetOptions : (offsetOptions?.mainAxis ?? 0);
  const crossAxis = typeof offsetOptions === "number" ? 0 : (offsetOptions?.crossAxis ?? 0);

  element.style.setProperty("position", named.strategy);
  element.style.setProperty("position-anchor", named.anchorName);
  element.style.setProperty("position-area", positionArea);
  element.style.setProperty(selfProp, selfValue);
  element.style.setProperty("width", "max-content");
  element.style.setProperty("margin", "0");
  element.style.setProperty(
    "position-try-fallbacks",
    "flip-block, flip-inline, flip-block flip-inline",
  );
  element.style.setProperty("position-visibility", "anchors-visible");

  if (mainAxis) {
    element.style.setProperty(OFFSET_MARGIN[side], `${mainAxis}px`);
  }

  if (crossAxis) {
    element.style.setProperty(CROSS_OFFSET_MARGIN[side], `${crossAxis}px`);
  }
});

const ARROW_OPPOSITE_SIDES: Record<Direction, string> = {
  top: "bottom",
  bottom: "top",
  left: "right",
  right: "left",
};

/**
 * Modifier applied to the arrow element to position it at the edge of the floating element,
 * centered relative to the anchor element using CSS Anchor Positioning.
 */
const attachArrow = eModifier<{
  Element: HTMLElement;
  Args: {
    Named: {
      anchorName: string;
      placement: Placement;
    };
  };
}>((element, _: [], { anchorName, placement }) => {
  const side = placement.split("-")[0] as Direction;
  const isVertical = side === "top" || side === "bottom";

  element.style.setProperty("position", "absolute");
  element.style.setProperty("position-anchor", anchorName);

  if (isVertical) {
    element.style.setProperty("left", "anchor(center)");
    element.style.setProperty("translate", "-50% 0");
  } else {
    element.style.setProperty("top", "anchor(center)");
    element.style.setProperty("translate", "0 -50%");
  }

  element.style.setProperty(ARROW_OPPOSITE_SIDES[side], "-4px");
});

/**
 * Allows lazy evaluation of the portal target (do nothing until rendered).
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    anchorName: string;
    placement: Placement;
    strategy: "fixed" | "absolute";
    offsetOptions?: number | { mainAxis?: number; crossAxis?: number };
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
      <El
        {{cssAnchorPosition
          anchorName=@anchorName
          placement=@placement
          strategy=@strategy
          offsetOptions=@offsetOptions
        }}
        ...attributes
      >
        {{yield}}
      </El>
    {{else}}
      <Portal @to={{TARGETS.popover}}>
        {{! @glint-ignore
              https://github.com/tildeio/ember-element-helper/issues/91
              https://github.com/typed-ember/glint/issues/610
        }}
        <El
          {{cssAnchorPosition
            anchorName=@anchorName
            placement=@placement
            strategy=@strategy
            offsetOptions=@offsetOptions
          }}
          ...attributes
        >
          {{yield}}
        </El>
      </Portal>
    {{/if}}
  {{/let}}
</template>;

/**
 * Modifier applied to the reference element — calls setReference to apply anchor-name.
 */
const applyReference = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: {
    Positional: [setRef: (element: HTMLElement | SVGElement) => void];
  };
}>((element: HTMLElement | SVGElement, [setRef]) => {
  setRef(element);
});

/**
 * Popover component using CSS Anchor Positioning for placement.
 *
 * Positions a floating element relative to a reference element using the native
 * [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning)
 * API, with automatic flip fallbacks via `position-try-fallbacks` and viewport-aware
 * visibility via `position-visibility`.
 *
 * Example usage:
 * ```gjs
 * import { PortalTargets, Popover } from 'ember-primitives';
 *
 * <template>
 *   <PortalTargets />
 *   <Popover @placement="bottom" @offsetOptions={{8}} as |p|>
 *     <button {{p.reference}}>Anchor</button>
 *     <p.Content>Floating content</p.Content>
 *   </Popover>
 * </template>
 * ```
 */
export class Popover extends Component<Signature> {
  anchorName = `--ep-${guidFor(this)}`;
  data = undefined;

  get placement(): Placement {
    return this.args.placement ?? "bottom";
  }

  get strategy(): "fixed" | "absolute" {
    return this.args.strategy ?? "fixed";
  }

  setReference = (element: HTMLElement | SVGElement) => {
    if (element instanceof HTMLElement) {
      element.style.setProperty("anchor-name", this.anchorName);
    }
  };

  <template>
    {{#let
      (modifier applyReference this.setReference)
      (modifier attachArrow anchorName=this.anchorName placement=this.placement)
      as |referenceModifier arrowModifier|
    }}
      {{yield
        (hash
          reference=referenceModifier
          setReference=this.setReference
          Content=(component
            Content
            anchorName=this.anchorName
            placement=this.placement
            strategy=this.strategy
            offsetOptions=@offsetOptions
            inline=@inline
          )
          data=this.data
          arrow=arrowModifier
        )
      }}
    {{/let}}
  </template>
}

export default Popover;
