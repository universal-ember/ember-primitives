import { assert } from '@ember/debug';

import { autoUpdate, computePosition, flip, hide, offset, shift } from '@floating-ui/dom';
import { modifier as eModifier } from 'ember-modifier';

import { exposeMetadata } from './middleware.ts';

import type {
  FlipOptions,
  HideOptions,
  Middleware,
  OffsetOptions,
  Placement,
  ShiftOptions,
  Strategy,
} from '@floating-ui/dom';

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
       * See: [The strategy docs](https://floating-ui.com/docs/computePosition#strategy)
       */
      strategy?: Strategy;
      /**
       * Options to pass to the [offset middleware](https://floating-ui.com/docs/offset)
       */
      offsetOptions?: OffsetOptions;
      /**
       * Where to place the floating element relative to its reference element.
       * The default is 'bottom'.
       *
       * See: [The placement docs](https://floating-ui.com/docs/computePosition#placement)
       */
      placement?: Placement;
      /**
       * Options to pass to the [flip middleware](https://floating-ui.com/docs/flip)
       */
      flipOptions?: FlipOptions;
      /**
       * Options to pass to the [shift middleware](https://floating-ui.com/docs/shift)
       */
      shiftOptions?: ShiftOptions;
      /**
       * Options to pass to the [hide middleware](https://floating-ui.com/docs/hide)
       */
      hideOptions?: HideOptions;
      /**
       * Additional middleware to pass to FloatingUI.
       *
       * See: [The middleware docs](https://floating-ui.com/docs/middleware)
       */
      middleware?: Middleware[];
      /**
       * A callback for when data changes about the position / placement / etc
       * of the floating element.
       */
      setData?: Middleware['fn'];
    };
  };
}

let id = 1;
const nextId = () => {
  id++;

  return `ep-popover-${id}`;
};

function getId(element: Element) {
  let existing = element.getAttribute('popovertarget');

  if (existing) return existing;

  existing = nextId();

  element.setAttribute('popovertarget', existing);

  return existing;
}

export const makePopover = eModifier<{
  Element: HTMLElement | SVGElement;
  Args: {
    Positional: [string | HTMLElement | SVGElement];
  };
}>((floatingElement, [_referenceElement]) => {
  const referenceElement = findReference(_referenceElement);

  const popoverId = getId(referenceElement);

  floatingElement.setAttribute('popover', '');
  floatingElement.id = popoverId;
});

function findReference(specified: string | HTMLElement | SVGElement) {
  const referenceElement: null | HTMLElement | SVGElement =
    typeof specified === 'string' ? document.querySelector(specified) : specified;

  assert(
    'no reference element defined',
    referenceElement instanceof HTMLElement || referenceElement instanceof SVGElement
  );

  return referenceElement;
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
    {
      strategy = 'fixed',
      offsetOptions = 0,
      placement = 'bottom',
      flipOptions,
      shiftOptions,
      middleware = [],
      setData,
    }
  ) => {
    const referenceElement = findReference(_referenceElement);

    assert(
      'no floating element defined',
      floatingElement instanceof HTMLElement || _referenceElement instanceof SVGElement
    );
    assert(
      'reference and floating elements cannot be the same element',
      floatingElement !== _referenceElement
    );

    assert('@middleware must be an array of one or more objects', Array.isArray(middleware));

    Object.assign(floatingElement.style, {
      position: strategy,
      top: '0',
      left: '0',
    });

    const update = async () => {
      const { middlewareData, x, y } = await computePosition(referenceElement, floatingElement, {
        middleware: [
          offset(offsetOptions),
          flip(flipOptions),
          shift(shiftOptions),
          ...middleware,
          hide({ strategy: 'referenceHidden' }),
          hide({ strategy: 'escaped' }),
          exposeMetadata(),
        ],
        placement,
        strategy,
      });

      const referenceHidden = middlewareData.hide?.referenceHidden;

      Object.assign(floatingElement.style, {
        top: `${y}px`,
        left: `${x}px`,
        margin: 0,
        visibility: referenceHidden ? 'hidden' : 'visible',
      });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
      void setData?.(middlewareData['metadata']);
    };

    void update();

    // eslint-disable-next-line @typescript-eslint/no-misused-promises
    const cleanup = autoUpdate(referenceElement, floatingElement, update);

    /**
     * in the function-modifier manager, teardown of the previous modifier
     * occurs before setup of the next
     * https://github.com/ember-modifier/ember-modifier/blob/main/ember-modifier/src/-private/function-based/modifier-manager.ts#L58
     */
    return cleanup;
  }
);
