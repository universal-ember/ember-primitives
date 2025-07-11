import Modifier, { type ArgsFor } from 'ember-modifier';
import type Owner from '@ember/owner';
export interface Signature {
    /**
     * Any element that is resizable can have onResize attached
     */
    Element: Element;
    Args: {
        Positional: [
            /**
             * The ResizeObserver callback will only receive
             * one entry per resize event.
             *
             * See: [ResizeObserverEntry](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry)
             */
            callback: (entry: ResizeObserverEntry) => void
        ];
    };
}
declare class OnResize extends Modifier<Signature> {
    #private;
    constructor(owner: Owner, args: ArgsFor<Signature>);
    modify(element: Element, [callback]: [callback: (entry: ResizeObserverEntry) => void]): void;
}
export declare const onResize: typeof OnResize;
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
export default function ignoreROError(): void;
export {};
