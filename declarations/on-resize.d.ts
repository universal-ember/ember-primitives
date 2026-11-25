import Modifier, { type ArgsFor } from 'ember-modifier';
import type Owner from '@ember/owner';
export { ignoreROError } from './resize-observer.ts';
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
//# sourceMappingURL=on-resize.d.ts.map