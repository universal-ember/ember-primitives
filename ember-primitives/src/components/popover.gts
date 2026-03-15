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

const applyAnchorPositioning = eModifier<{
  Element: HTMLElement;
  Args: { Named: { anchorName: string; placement?: Placement } };
}>((el, _, { anchorName, placement = "bottom" }) => {
  const positionArea = PLACEMENT_TO_POSITION_AREA[placement] ?? "bottom";

  el.style.setProperty("position", "fixed");
  el.style.setProperty("position-anchor", anchorName);
  el.style.setProperty("position-area", positionArea);
  // Try flipping along the block axis, inline axis, or both before overflowing — analogous
  // to the flip/shift middleware from Floating UI.
  el.style.setProperty("position-try-fallbacks", "flip-block, flip-inline, flip-block flip-inline");

  return () => {
    el.style.removeProperty("position");
    el.style.removeProperty("position-anchor");
    el.style.removeProperty("position-area");
    el.style.removeProperty("position-try-fallbacks");
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
      (modifier applyAnchorPositioning anchorName=this.anchorName placement=@placement)
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
