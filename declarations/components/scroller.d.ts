import Component from '@glimmer/component';
/**
 * Utility component for helping with scrolling in any direction within
 * any of the 4 directions: up, down, left, right.
 *
 * This can be used to auto-scroll content as new content is inserted into the scrollable area, or possibly to bring focus to something on the page.
 */
export declare class Scroller extends Component<{
    /**
     * A containing element is required - in this case, a div.
     * It must be scrollable for this component to work, but can be customized.
     *
     * By default, this element will have some styling applied:
     *   overflow: auto;
     *
     * By default, this element will have tabindex="0" to support keyboard usage.
     *
     * The scroll-behavior is "auto", which can be controlled via CSS
     * https://developer.mozilla.org/en-US/docs/Web/CSS/scroll-behavior
     *
     */
    Element: HTMLDivElement;
    Blocks: {
        default: [
            {
                /**
                 * Scroll the content to the bottom
                 *
                 * ```gjs
                 * import { Scroller } from 'ember-primitives';
                 *
                 * <template>
                 *   <Scroller as |s|>
                 *      ...
                 *
                 *      {{ (s.scrollToBottom) }}
                 *   </Scroller>
                 * </template>
                 * ```
                 */
                scrollToBottom: () => void;
                /**
                 * Scroll the content to the top
                 *
                 * ```gjs
                 * import { Scroller } from 'ember-primitives';
                 *
                 * <template>
                 *   <Scroller as |s|>
                 *      ...
                 *
                 *      {{ (s.scrollToTop) }}
                 *   </Scroller>
                 * </template>
                 * ```
                 */
                scrollToTop: () => void;
                /**
                 * Scroll the content to the left
                 *
                 * ```gjs
                 * import { Scroller } from 'ember-primitives';
                 *
                 * <template>
                 *   <Scroller as |s|>
                 *      ...
                 *
                 *      {{ (s.scrollToLeft) }}
                 *   </Scroller>
                 * </template>
                 * ```
                 */
                scrollToLeft: () => void;
                /**
                 * Scroll the content to the right
                 *
                 * ```gjs
                 * import { Scroller } from 'ember-primitives';
                 *
                 * <template>
                 *   <Scroller as |s|>
                 *      ...
                 *
                 *      {{ (s.scrollToRight) }}
                 *   </Scroller>
                 * </template>
                 * ```
                 */
                scrollToRight: () => void;
            }
        ];
    };
}> {
    #private;
    withinElement: HTMLDivElement;
    ref: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLDivElement;
    }>;
    scrollToBottom: () => void;
    scrollToTop: () => void;
    scrollToLeft: () => void;
    scrollToRight: () => void;
}
//# sourceMappingURL=scroller.d.ts.map