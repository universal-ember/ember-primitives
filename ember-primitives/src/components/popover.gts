import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { guidFor } from "@ember/object/internals";

import { element } from "ember-element-helper";
import { modifier as eModifier } from "ember-modifier";

import { attachArrow } from "../anchor-position/modifier.ts";
import { anchorPositionStyle } from "../anchor-position/placement.ts";

import type { OffsetOptions, Placement } from "../anchor-position/placement.ts";
import type { TOC } from "@ember/component/template-only";
import type { SafeString } from "@ember/template";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

export interface Signature {
  Args: {
    /**
     * Offset distance between the reference and floating elements.
     * Can be a number (pixels) or an object with `mainAxis` and/or `crossAxis` values.
     */
    offsetOptions?: OffsetOptions;
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

function getElementTag(tagName: undefined | string) {
  return tagName || "div";
}

const showPopover = eModifier<{ Element: Element }>((el) => {
  const popoverEl = el as HTMLElement;

  // Don't promote to top layer if already inside a popover — the parent
  // popover already handles layering. Adding both to the top layer causes
  // stacking issues where the parent renders on top of the child.
  if (popoverEl.parentElement?.closest("[popover]")) {
    popoverEl.removeAttribute("popover");

    // <dialog> elements are hidden by default — ensure they're visible
    // when opting out of the top layer.
    if (popoverEl instanceof HTMLDialogElement) {
      popoverEl.setAttribute("open", "");
    }
  } else {
    popoverEl.showPopover();
  }

  return () => {
    try {
      popoverEl.hidePopover();
    } catch {
      /* already hidden */
    }
  };
});

/**
 * Content uses `popover="manual"` + `showPopover()` to promote
 * the element to the browser's top layer. This escapes all ancestor
 * overflow clipping and stacking contexts — the same guarantee that
 * portalling provided, but using the browser's native mechanism.
 *
 * Positioning is provided by CSS Anchor Positioning via the inline
 * `style` SafeString computed by the parent <Popover>.
 */
const Content: TOC<{
  Element: HTMLElement;
  Args: {
    style: SafeString;
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
    {{! @glint-ignore
          https://github.com/tildeio/ember-element-helper/issues/91
          https://github.com/typed-ember/glint/issues/610
    }}
    <El popover="manual" {{showPopover}} style={{@style}} ...attributes>
      {{yield}}
    </El>
  {{/let}}
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
