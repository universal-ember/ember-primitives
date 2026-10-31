import { assert } from '@ember/debug';

import { modifier as eModifier } from 'ember-modifier';

import { applyPlacements, placementsFor, setupFloating, sideOf } from './position.ts';

import type { FlipOptions, OffsetOptions, Placement, ShiftOptions, Side } from './position.ts';

type Strategy = 'fixed' | 'absolute';

export interface Signature {
  /**
   *
   */
  Element: HTMLElement;
  Args: {
    Positional: [
      /**
       * What do use as the reference element.
       * Can be a selector or element instance.
       *
       * The element must generate a CSS box.
       * An `<svg>` does, but shapes inside of an `<svg>` do not.
       *
       * Example:
       * ```gjs
       * import { anchorTo } from 'ember-primitives/floating-ui';
       *
       * <template>
       *   <div id="reference">...</div>
       *   <div {{anchorTo "#reference"}}> ... </div>
       * </template>
       * ```
       */
      referenceElement: string | HTMLElement | SVGElement,
    ];
    Named: {
      /**
       * This is the type of CSS position property to use.
       * By default this is 'fixed', but can also be 'absolute'.
       *
       * With 'absolute', the floating element flips at the edges of the page,
       * and not at the edges of the viewport.
       */
      strategy?: Strategy;
      /**
       * The distance between the floating element and the reference element.
       * An object can also move the floating element along the reference element.
       */
      offsetOptions?: OffsetOptions;
      /**
       * Where to place the floating element relative to its reference element.
       * The default is 'bottom'.
       */
      placement?: Placement;
      /**
       * Controls the distance that a flip keeps from the viewport edges.
       */
      flipOptions?: FlipOptions;
      /**
       * Controls the distance that the floating element keeps
       * from the viewport edges when it moves along the reference element.
       */
      shiftOptions?: ShiftOptions;
    };
  };
}

/**
 * The rects of an entry can differ by a fraction of a pixel with nothing clipped.
 */
const TOLERANCE = 1;

/**
 * A reference can already be clipped on one side when a clip starts on another side.
 * Only the visible ratio changes then, so a threshold at 1 alone does not report it.
 */
const THRESHOLDS = Array.from({ length: 21 }, (_, index) => index / 20);

function isClippedOn(entry: IntersectionObserverEntry, side: Side) {
  const { boundingClientRect: full, intersectionRect: visible } = entry;

  return Math.abs(full[side] - visible[side]) > TOLERANCE;
}

/**
 * A modifier to apply to the _floating_ element.
 * This is what will anchor to the reference element.
 *
 * Example
 * ```gjs
 * import { anchorTo } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <button id="my-button"> ... </button>
 *   <menu {{anchorTo "#my-button"}}> ... </menu>
 * </template>
 * ```
 */
export const anchorTo = eModifier<Signature>(
  (
    floatingElement,
    [_referenceElement],
    { strategy = 'fixed', offsetOptions = 0, placement = 'bottom', flipOptions, shiftOptions }
  ) => {
    const referenceElement: null | HTMLElement | SVGElement =
      typeof _referenceElement === 'string'
        ? document.querySelector(_referenceElement)
        : _referenceElement;

    assert(
      'no reference element defined',
      referenceElement instanceof HTMLElement || referenceElement instanceof SVGElement
    );

    assert(
      'no floating element defined',
      floatingElement instanceof HTMLElement || _referenceElement instanceof SVGElement
    );

    assert(
      'reference and floating elements cannot be the same element',
      floatingElement !== _referenceElement
    );

    assert(
      'SVG reference elements must be an <svg>, because shapes inside of an <svg> cannot be anchors',
      !(referenceElement instanceof SVGElement) || referenceElement instanceof SVGSVGElement
    );

    const side = sideOf(placement);
    const style = floatingElement.style;

    style.setProperty('position', strategy);
    floatingElement.setAttribute('data-placement', placement);
    setupFloating(floatingElement, referenceElement, { offsetOptions, flipOptions, shiftOptions });
    applyPlacements(floatingElement, placementsFor(placement, false));

    let isClipped = false;

    /**
     * CSS has no way to flip for a clipped reference, because a floating element
     * only knows about its containing block. An observer knows about every clip.
     */
    const observer = new IntersectionObserver(
      (entries) => {
        const entry = entries[entries.length - 1];

        if (!entry) return;

        style.setProperty('visibility', entry.isIntersecting ? '' : 'hidden');

        const next = isClippedOn(entry, side);

        if (next === isClipped) return;

        isClipped = next;
        applyPlacements(floatingElement, placementsFor(placement, isClipped));
      },
      { threshold: THRESHOLDS }
    );

    observer.observe(referenceElement);

    /**
     * in the function-modifier manager, teardown of the previous modifier
     * occurs before setup of the next
     * https://github.com/ember-modifier/ember-modifier/blob/main/ember-modifier/src/-private/function-based/modifier-manager.ts#L58
     */
    return () => observer.disconnect();
  }
);
