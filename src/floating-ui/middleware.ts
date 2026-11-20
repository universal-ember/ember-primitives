import { detectOverflow, flip } from '@floating-ui/dom';

import type { ElementContext, FlipOptions, Middleware, MiddlewareState } from '@floating-ui/dom';

export type AnchorFlipOptions = Omit<FlipOptions, 'elementContext'> & {
  /**
   * Which element must stay inside its clipping boundary.
   *
   * `'both'` flips when the floating element or the reference element overflows.
   * A top-layer floating element ignores the scroll containers of the reference,
   * so `'floating'` alone leaves it attached to a clipped reference.
   */
  elementContext?: ElementContext | 'both';
};

export function exposeMetadata(): Middleware {
  return {
    name: 'metadata',
    fn: (data) => {
      // https://floating-ui.com/docs/middleware#always-return-an-object
      return {
        data,
      };
    },
  };
}

async function detectOverflowOfBoth(
  state: MiddlewareState,
  options?: Parameters<typeof detectOverflow>[1]
) {
  const floating = await detectOverflow(state, { ...options, elementContext: 'floating' });
  const reference = await detectOverflow(state, { ...options, elementContext: 'reference' });

  return {
    top: Math.max(floating.top, reference.top),
    right: Math.max(floating.right, reference.right),
    bottom: Math.max(floating.bottom, reference.bottom),
    left: Math.max(floating.left, reference.left),
  };
}

/**
 * Two separate flip middleware can disagree and reset each other in a loop,
 * so `'both'` feeds the combined overflow into a single flip.
 */
export function flipTo(options: AnchorFlipOptions = {}): Middleware {
  const { elementContext, ...flipOptions } = options;

  if (elementContext !== 'both') {
    return flip({ ...flipOptions, elementContext });
  }

  const middleware = flip(flipOptions);

  return {
    ...middleware,
    fn: (state) =>
      middleware.fn({
        ...state,
        platform: { ...state.platform, detectOverflow: detectOverflowOfBoth },
      }),
  };
}
