import { hash } from "@ember/helper";

import { element } from "ember-element-helper";
import { modifier as eModifier } from "ember-modifier";

import { FloatingUI } from "../floating-ui.ts";
import { applyArrow } from "../floating-ui/position.ts";

import type { Signature as FloatingUiComponentSignature } from "../floating-ui/component.gts";
import type { Signature as HookSignature } from "../floating-ui/modifier.ts";
import type { TOC } from "@ember/component/template-only";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

export interface Signature {
  Args: {
    /**
     * Controls the distance that a flip keeps from the viewport edges.
     *
     * This argument is forwarded to the `<FloatingUI>` component.
     */
    flipOptions?: HookSignature["Args"]["Named"]["flipOptions"];
    /**
     * The distance between the popover and its reference element.
     *
     * This argument is forwarded to the `<FloatingUI>` component.
     */
    offsetOptions?: HookSignature["Args"]["Named"]["offsetOptions"];
    /**
     * Where to place the popover. The default is 'bottom'.
     *
     * Possible values are
     * - top
     * - bottom
     * - right
     * - left
     *
     * And may optionally have `-start` or `-end` added to adjust position along the side.
     *
     * This argument is forwarded to the `<FloatingUI>` component.
     */
    placement?: `${"top" | "bottom" | "left" | "right"}${"" | "-start" | "-end"}`;
    /**
     * Controls the distance to keep from the viewport edges.
     *
     * This argument is forwarded to the `<FloatingUI>` component.
     */
    shiftOptions?: HookSignature["Args"]["Named"]["shiftOptions"];
    /**
     * CSS position property, either `fixed` or `absolute`.
     *
     * This argument is forwarded to the `<FloatingUI>` component.
     */
    strategy?: HookSignature["Args"]["Named"]["strategy"];
  };
  Blocks: {
    default: [
      {
        reference: FloatingUiComponentSignature["Blocks"]["default"][0];
        setReference: FloatingUiComponentSignature["Blocks"]["default"][2]["setReference"];
        Content: WithBoundArgs<typeof Content, "floating">;
        arrow: ModifierLike<{ Element: HTMLElement }>;
      },
    ];
  };
}

const showPopover = eModifier<{ Element: Element }>((element) => {
  const el = element as HTMLElement;

  // Reset [popover] UA overflow default that clips arrows positioned outside
  el.style.setProperty("overflow", "visible");

  // Don't promote to top layer if already inside a popover — the parent
  // popover already handles layering. Adding both to the top layer causes
  // stacking issues where the parent renders on top of the child.
  if (el.parentElement?.closest("[popover]")) {
    el.removeAttribute("popover");

    // <dialog> elements are hidden by default — ensure they're visible
    // when opting out of the top layer.
    if (el instanceof HTMLDialogElement) {
      el.setAttribute("open", "");
    }
  } else {
    el.showPopover();
  }

  return () => {
    try {
      el.hidePopover();
    } catch {
      /* already hidden */
    }
  };
});

function getElementTag(tagName: undefined | string) {
  return tagName || "div";
}

/**
 * Content uses `popover="manual"` + `showPopover()` to promote
 * the element to the browser's top layer. This escapes all ancestor
 * overflow clipping and stacking contexts — the same guarantee that
 * portalling provided, but using the browser's native mechanism.
 */
const Content: TOC<{
  Element: HTMLDivElement;
  Args: {
    floating: ModifierLike<{ Element: HTMLElement }>;
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
    <El popover="manual" {{showPopover}} {{@floating}} ...attributes>
      {{yield}}
    </El>
  {{/let}}
</template>;

const arrow = eModifier<{ Element: HTMLElement }>((element) => applyArrow(element));

export const Popover: TOC<Signature> = <template>
  <FloatingUI
    @placement={{@placement}}
    @strategy={{@strategy}}
    @flipOptions={{@flipOptions}}
    @shiftOptions={{@shiftOptions}}
    @offsetOptions={{@offsetOptions}}
    as |reference floating extra|
  >
    {{yield
      (hash
        reference=reference
        setReference=extra.setReference
        Content=(component Content floating=floating)
        arrow=arrow
      )
    }}
  </FloatingUI>
</template>;

export default Popover;
