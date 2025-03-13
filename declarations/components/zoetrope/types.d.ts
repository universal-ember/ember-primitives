export type ScrollBehavior = 'auto' | 'smooth' | 'instant';
export interface Signature {
    Args: {
        /**
         * The distance in pixels between each item in the slider.
         */
        gap?: number;
        /**
         * The distance from the edge of the container to the first and last item, this allows
         * the contents to visually overflow the container
         */
        offset?: number;
        /**
         * The scroll behavior to use when scrolling the slider. Defaults to smooth.
         */
        scrollBehavior?: ScrollBehavior;
    };
    Blocks: {
        /**
         * The header block is where the header content is placed.
         */
        header: [];
        /**
         * The content block is where the items that will be scrolled are placed.
         */
        content: [];
        /**
         * The controls block is where the left and right buttons are placed.
         */
        controls: [
            {
                /**
                 * Whether the slider can scroll.
                 */
                canScroll: boolean;
                /**
                 * Whether the slider cannot scroll left.
                 */
                cannotScrollLeft: boolean;
                /**
                 * Whether the slider cannot scroll right.
                 */
                cannotScrollRight: boolean;
                /**
                 * The function to scroll the slider left.
                 */
                scrollLeft: () => void;
                /**
                 * The function to scroll the slider right.
                 */
                scrollRight: () => void;
            }
        ];
    };
    Element: HTMLElement;
}
//# sourceMappingURL=types.d.ts.map