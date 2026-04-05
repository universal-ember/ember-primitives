import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { guidFor } from "@ember/object/internals";
import { htmlSafe } from "@ember/template";

import { modifier as eModifier } from "ember-modifier";

import type { TOC } from "@ember/component/template-only";
import type { SafeString } from "@ember/template";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

type Placement =
  | "top"
  | "top-start"
  | "top-end"
  | "bottom"
  | "bottom-start"
  | "bottom-end"
  | "left"
  | "left-start"
  | "left-end"
  | "right"
  | "right-start"
  | "right-end";

export interface Signature {
  Args: {
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
  };
  Blocks: {
    default: [
      {
        reference: ModifierLike<{ Element: HTMLElement | SVGElement }>;
        setReference: (element: HTMLElement | SVGElement) => void;
        Content: WithBoundArgs<typeof Content, "style">;
        data: undefined;
        arrow: ModifierLike<{ Element: HTMLElement }>;
      },
    ];
  };
}

interface PlacementConfig {
  positionArea: string;
  selfProp: string;
  selfValue: string;
  offsetMargin: string;
  crossOffsetMargin: string;
  arrowSide: string;
  arrowIsVertical: boolean;
}

/**
 * Static lookup for CSS Anchor Positioning properties per placement.
 *
 * The position-area grid has the anchor element at center.
 * For -start/-end variants, we use span-right/span-left (or span-bottom/span-top)
 * to create an area starting at the anchor's edge, then align within that area.
 */
const PLACEMENT_CONFIG: Record<Placement, PlacementConfig> = {
  top: {
    positionArea: "top",
    selfProp: "justify-self",
    selfValue: "anchor-center",
    offsetMargin: "margin-bottom",
    crossOffsetMargin: "margin-left",
    arrowSide: "bottom",
    arrowIsVertical: true,
  },
  "top-start": {
    positionArea: "top span-right",
    selfProp: "justify-self",
    selfValue: "start",
    offsetMargin: "margin-bottom",
    crossOffsetMargin: "margin-left",
    arrowSide: "bottom",
    arrowIsVertical: true,
  },
  "top-end": {
    positionArea: "top span-left",
    selfProp: "justify-self",
    selfValue: "end",
    offsetMargin: "margin-bottom",
    crossOffsetMargin: "margin-left",
    arrowSide: "bottom",
    arrowIsVertical: true,
  },
  bottom: {
    positionArea: "bottom",
    selfProp: "justify-self",
    selfValue: "anchor-center",
    offsetMargin: "margin-top",
    crossOffsetMargin: "margin-left",
    arrowSide: "top",
    arrowIsVertical: true,
  },
  "bottom-start": {
    positionArea: "bottom span-right",
    selfProp: "justify-self",
    selfValue: "start",
    offsetMargin: "margin-top",
    crossOffsetMargin: "margin-left",
    arrowSide: "top",
    arrowIsVertical: true,
  },
  "bottom-end": {
    positionArea: "bottom span-left",
    selfProp: "justify-self",
    selfValue: "end",
    offsetMargin: "margin-top",
    crossOffsetMargin: "margin-left",
    arrowSide: "top",
    arrowIsVertical: true,
  },
  left: {
    positionArea: "left",
    selfProp: "align-self",
    selfValue: "anchor-center",
    offsetMargin: "margin-right",
    crossOffsetMargin: "margin-top",
    arrowSide: "right",
    arrowIsVertical: false,
  },
  "left-start": {
    positionArea: "left span-bottom",
    selfProp: "align-self",
    selfValue: "start",
    offsetMargin: "margin-right",
    crossOffsetMargin: "margin-top",
    arrowSide: "right",
    arrowIsVertical: false,
  },
  "left-end": {
    positionArea: "left span-top",
    selfProp: "align-self",
    selfValue: "end",
    offsetMargin: "margin-right",
    crossOffsetMargin: "margin-top",
    arrowSide: "right",
    arrowIsVertical: false,
  },
  right: {
    positionArea: "right",
    selfProp: "align-self",
    selfValue: "anchor-center",
    offsetMargin: "margin-left",
    crossOffsetMargin: "margin-top",
    arrowSide: "left",
    arrowIsVertical: false,
  },
  "right-start": {
    positionArea: "right span-bottom",
    selfProp: "align-self",
    selfValue: "start",
    offsetMargin: "margin-left",
    crossOffsetMargin: "margin-top",
    arrowSide: "left",
    arrowIsVertical: false,
  },
  "right-end": {
    positionArea: "right span-top",
    selfProp: "align-self",
    selfValue: "end",
    offsetMargin: "margin-left",
    crossOffsetMargin: "margin-top",
    arrowSide: "left",
    arrowIsVertical: false,
  },
};

function anchorPositionStyle(
  placement: Placement,
  anchorName: string,
  offsetOptions?: number | { mainAxis?: number; crossAxis?: number },
): SafeString {
  const config = PLACEMENT_CONFIG[placement];

  const offsetOpts = offsetOptions ?? 0;
  const mainAxis = typeof offsetOpts === "number" ? offsetOpts : (offsetOpts?.mainAxis ?? 0);
  const crossAxis = typeof offsetOpts === "number" ? 0 : (offsetOpts?.crossAxis ?? 0);

  let style = `position: fixed; inset: auto; overflow: visible; border: none; position-anchor: ${anchorName}; position-area: ${config.positionArea}; ${config.selfProp}: ${config.selfValue}; width: max-content; margin: 0; position-try-fallbacks: flip-block; position-visibility: anchors-visible`;

  if (mainAxis) {
    style += `; ${config.offsetMargin}: ${mainAxis}px`;
  }

  if (crossAxis) {
    style += `; ${config.crossOffsetMargin}: ${crossAxis}px`;
  }

  return htmlSafe(style);
}

const attachArrow = eModifier<{
  Element: Element;
  Args: {
    Named: {
      placement: Placement;
    };
  };
}>((el, _: [], { placement }) => {
  if (!(el instanceof HTMLElement)) return;

  const config = PLACEMENT_CONFIG[placement];

  el.style.setProperty("position", "absolute");

  if (config.arrowIsVertical) {
    el.style.setProperty("left", "50%");
    el.style.setProperty("translate", "-50% 0");
  } else {
    el.style.setProperty("top", "50%");
    el.style.setProperty("translate", "0 -50%");
  }

  el.style.setProperty(config.arrowSide, "-4px");
});

const Content: TOC<{
  Element: HTMLDialogElement;
  Args: {
    style: SafeString;
  };
  Blocks: { default: [] };
}> = <template>
  <dialog open role="none" style={{@style}} ...attributes>
    {{yield}}
  </dialog>
</template>;

const applyReference = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: {
    Positional: [setRef: (element: HTMLElement | SVGElement) => void];
  };
}>((element, [setRef]) => {
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
 * import { Popover } from 'ember-primitives';
 *
 * <template>
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

  setReference = (element: HTMLElement | SVGElement) => {
    element.style.setProperty("anchor-name", this.anchorName);
  };

  get contentStyle(): SafeString {
    return anchorPositionStyle(this.placement, this.anchorName, this.args.offsetOptions);
  }

  <template>
    {{#let
      (modifier applyReference this.setReference) (modifier attachArrow placement=this.placement)
      as |referenceModifier arrowModifier|
    }}
      {{yield
        (hash
          reference=referenceModifier
          setReference=this.setReference
          Content=(component Content style=this.contentStyle)
          data=this.data
          arrow=arrowModifier
        )
      }}
    {{/let}}
  </template>
}

export default Popover;
