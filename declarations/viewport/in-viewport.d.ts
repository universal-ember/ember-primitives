import Component from "@glimmer/component";
export type InViewportMode = "replace" | "contain";
/**
 * Configuration for the InViewport component
 */
export interface InViewportSignature {
    Element: HTMLElement;
    Args: {
        /**
         * The tag name for the placeholder element.
         * Can be any valid HTML tag name.
         * Default: 'div'
         */
        tagName?: string;
        /**
         * The mode determines how yielded content is rendered:
         * - 'replace': yielded content replaces the placeholder element
         * - 'contain': yielded content is rendered within the placeholder
         * Default: 'contain'
         */
        mode?: InViewportMode;
    };
    Blocks: {
        /**
         * Default block - rendered when the element is in the viewport
         */
        default: [];
    };
}
/**
 * A component that only renders its content when the element is near the viewport.
 *
 * This is useful for deferring the rendering of heavy components until they're
 * actually needed, improving performance for pages with many components.
 *
 * Example usage:
 * ```gjs
 * import { InViewport } from 'ember-primitives';
 *
 * <template>
 *   <InViewport>
 *     <ExpensiveComponent />
 *   </InViewport>
 * </template>
 * ```
 *
 * The component uses the Intersection Observer API to detect when the element
 * is near the viewport. Once detected, the observer is destroyed and the content
 * is rendered permanently.
 */
export declare class InViewport extends Component<InViewportSignature> {
    #private;
    /**
     * Whether the element has been detected as in/near the viewport
     */
    hasIntersected: boolean;
    setupObserver: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: Element;
    }>;
    handle: (entry: IntersectionObserverEntry) => void;
    get mode(): InViewportMode;
    get tagName(): string;
    get hasReachedViewport(): boolean;
    get isReplacing(): boolean;
}
//# sourceMappingURL=in-viewport.d.ts.map