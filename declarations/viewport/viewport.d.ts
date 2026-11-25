/**
 * Creates or returns the ViewportObserverManager.
 *
 * Only one of these will exist per owner.
 *
 * Has only two methods:
 * - observe(element, callback: (intersectionObserverEntry) => void, options?)
 * - unobserve(element, callback: (intersectionObserverEntry) => void)
 *
 * Like with the underlying IntersectionObserver API (and all event listeners),
 * the callback passed to unobserve must be the same reference as the one
 * passed to observe.
 */
export declare function viewport(context: object): ViewportObserverManager;
export interface ViewportOptions {
    /**
     * A margin around the root. Can have values similar to the CSS margin property.
     * The values can be percentages. This set of values serves to grow or shrink each
     * side of the root element's bounding box before computing intersections.
     * Defaults to all zeros.
     */
    rootMargin?: string;
    /**
     * Either a single number or an array of numbers which indicate at what percentage
     * of the target's visibility the observer's callback should be executed. If you only
     * want to detect when visibility passes the 50% mark, you can use a value of 0.5.
     * If you want the callback to run every time visibility passes another 25%, you would
     * specify the array [0, 0.25, 0.5, 0.75, 1]. The default is 0 (meaning as soon as
     * even one pixel is visible, the callback will be run).
     */
    threshold?: number | number[];
}
declare class ViewportObserverManager {
    #private;
    constructor();
    /**
     * Initiate the observing of the `element` or add an additional `callback`
     * if the `element` is already observed.
     *
     * @param {object} element
     * @param {function} callback The `callback` is called whenever the `element`
     *    intersects with the viewport. It is called with an `IntersectionObserverEntry`
     *    object for the particular `element`.
     */
    observe(element: Element, callback: (entry: IntersectionObserverEntry) => unknown): void;
    /**
     * End the observing of the `element` or just remove the provided `callback`.
     *
     * It will unobserve the `element` if the `callback` is not provided
     * or there are no more callbacks left for this `element`.
     *
     * @param {Element | undefined | null} element
     * @param {function?} callback - The `callback` to remove from the listeners
     *   of the `element` intersection changes.
     */
    unobserve(element: Element | undefined | null, callback: (entry: IntersectionObserverEntry) => unknown): void;
}
export {};
//# sourceMappingURL=viewport.d.ts.map