/**
 * Creates or returns the ResizeObserverManager.
 *
 * Only one of these will exist per owner.
 *
 * Has only two methods:
 * - observe(element, callback: (resizeObserverEntry) => void)
 * - unobserve(element, callback: (resizeObserverEntry) => void)
 *
 * Like with the underlying ResizeObserver API (and all event listeners),
 * the callback passed to unobserved must be the same reference as the one
 * passed to observe.
 */
export declare function resizeObserver(context: object): ResizeObserverManager;
declare class ResizeObserverManager {
    #private;
    constructor();
    /**
     * Initiate the observing of the `element` or add an additional `callback`
     * if the `element` is already observed.
     *
     * @param {object} element
     * @param {function} callback The `callback` is called whenever the size of
     *    the `element` changes. It is called with `ResizeObserverEntry` object
     *    for the particular `element`.
     */
    observe(element: Element, callback: (entry: ResizeObserverEntry) => unknown): void;
    /**
     * End the observing of the `element` or just remove the provided `callback`.
     *
     * It will unobserve the `element` if the `callback` is not provided
     * or there are no more callbacks left for this `element`.
     *
     * @param {object} element
     * @param {function?} callback - The `callback` to remove from the listeners
     *   of the `element` size changes.
     */
    unobserve(element: Element, callback: (entry: ResizeObserverEntry) => unknown): void;
}
/**
 * Ignores "ResizeObserver loop limit exceeded" error in Ember tests.
 *
 * This "error" is safe to ignore as it is just a warning message,
 * telling that the "looping" observation will be skipped in the current frame,
 * and will be delivered in the next one.
 *
 * For some reason, it is fired as an `error` event at `window` failing Ember
 * tests and exploding Sentry with errors that must be ignored.
 */
export declare function ignoreROError(): void;
export {};
//# sourceMappingURL=resize-observer.d.ts.map