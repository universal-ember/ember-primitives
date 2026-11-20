import type { ElementContext, FlipOptions, Middleware } from '@floating-ui/dom';
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
export declare function exposeMetadata(): Middleware;
/**
 * Two separate flip middleware can disagree and reset each other in a loop,
 * so `'both'` feeds the combined overflow into a single flip.
 */
export declare function flipTo(options?: AnchorFlipOptions): Middleware;
//# sourceMappingURL=middleware.d.ts.map