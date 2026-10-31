import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { hash } from "@ember/helper";

import { modifier as eModifier } from "ember-modifier";

import { anchorTo } from "./modifier.ts";

import type { Signature as ModifierSignature } from "./modifier.ts";
import type { ModifierLike } from "@glint/template";

type ModifierArgs = ModifierSignature["Args"]["Named"];

interface ReferenceSignature {
  Element: HTMLElement | SVGElement;
}

export interface Signature {
  Args: {
    /**
     * Where to place the floating element relative to its reference element.
     * The default is 'bottom'.
     */
    placement?: ModifierArgs["placement"];
    /**
     * This is the type of CSS position property to use.
     * By default this is 'fixed', but can also be 'absolute'.
     */
    strategy?: ModifierArgs["strategy"];
    /**
     * Controls where the floating element flips.
     */
    flipOptions?: ModifierArgs["flipOptions"];
    /**
     * Controls the distance to keep from the viewport edges.
     */
    shiftOptions?: ModifierArgs["shiftOptions"];
    /**
     * The distance between the floating element and the reference element.
     */
    offsetOptions?: ModifierArgs["offsetOptions"];
  };
  Blocks: {
    default: [
      /**
       * A modifier to apply to the _reference_ element.
       * This is what the floating element will use to anchor to.
       *
       * Example
       * ```gjs
       * import { FloatingUI } from 'ember-primitives/floating-ui';
       *
       * <template>
       *   <FloatingUI as |reference floating|>
       *     <button {{reference}}> ... </button>
       *     ...
       *   </FloatingUI>
       * </template>
       * ```
       */
      reference: ModifierLike<ReferenceSignature>,
      /**
       * A modifier to apply to the _floating_ element.
       * This is what will anchor to the reference element.
       *
       * Example
       * ```gjs
       * import { FloatingUI } from 'ember-primitives/floating-ui';
       *
       * <template>
       *   <FloatingUI as |reference floating|>
       *     <button {{reference}}> ... </button>
       *     <menu {{floating}}> ... </menu>
       *   </FloatingUI>
       * </template>
       * ```
       */
      floating:
        | undefined
        | ModifierLike<{
            Element: HTMLElement;
            Args: {
              Named: ModifierArgs;
            };
          }>,
      /**
       * Special utilities for advanced usage
       */
      util: {
        /**
         * If you want to have a single modifier with custom behavior
         * on your reference element, you may use this `setReference`
         * function to set the reference, rather than having multiple modifiers
         * on that element.
         */
        setReference: (element: HTMLElement | SVGElement) => void;
      },
    ];
  };
}

const ref = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: {
    Positional: [setRef: (element: HTMLElement | SVGElement) => void];
  };
}>((element: HTMLElement | SVGElement, positional) => {
  const fn = positional[0];

  fn(element);
});

/**
 * A component that provides no DOM and yields two modifiers for creating
 * creating floating uis, such as menus, popovers, tooltips, etc.
 * This component uses [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning).
 *
 * Example usage:
 * ```gjs
 * import { FloatingUI } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <FloatingUI as |reference floating|>
 *     <button {{reference}}> ... </button>
 *     <menu {{floating}}> ... </menu>
 *   </FloatingUI>
 * </template>
 * ```
 */
export class FloatingUI extends Component<Signature> {
  @tracked reference?: HTMLElement | SVGElement = undefined;

  setReference = (element: HTMLElement | SVGElement) => {
    this.reference = element;
  };

  <template>
    {{#let
      (modifier
        anchorTo
        flipOptions=@flipOptions
        offsetOptions=@offsetOptions
        placement=@placement
        shiftOptions=@shiftOptions
        strategy=@strategy
      )
      as |prewiredAnchorTo|
    }}
      {{#let (if this.reference (modifier prewiredAnchorTo this.reference)) as |floating|}}
        {{! @glint-nocheck -- Excessively deep, possibly infinite }}
        {{yield (modifier ref this.setReference) floating (hash setReference=this.setReference)}}
      {{/let}}
    {{/let}}
  </template>
}
