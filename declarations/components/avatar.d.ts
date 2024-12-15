import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';
declare const Fallback: TOC<{
    Blocks: {
        default: [];
    };
    Args: {
        /**
         * The number of milliseconds to wait for the image to load
         * before displaying the fallback
         */
        delayMs?: number;
        /**
         * @private
         * Bound internally by ember-primitives
         */
        isLoaded: boolean;
    };
}>;
declare const Image: TOC<{
    Element: HTMLImageElement;
    Args: {
        /**
         * @private
         * The `src` value for the image.
         *
         * Bound internally by ember-primitives
         */
        src: string;
        /**
         * @private
         * Bound internally by ember-primitives
         */
        isLoaded: boolean;
    };
}>;
export declare const Avatar: TOC<{
    Element: HTMLSpanElement;
    Args: {
        /**
         * The `src` value for the image.
         */
        src: string;
    };
    Blocks: {
        default: [
            avatar: {
                /**
                 * The image to render. It will only render when it has loaded.
                 */
                Image: WithBoundArgs<typeof Image, 'src' | 'isLoaded'>;
                /**
                 * An element that renders when the image hasn't loaded.
                 * This means whilst it's loading, or if there was an error.
                 * If you notice a flash during loading,
                 * you can provide a delayMs prop to delay its rendering so it only renders for those with slower connections.
                 */
                Fallback: WithBoundArgs<typeof Fallback, 'isLoaded'>;
                /**
                 * true while the image is loading
                 */
                isLoading: boolean;
                /**
                 * If the image fails to load, this will be `true`
                 */
                isError: boolean;
            }
        ];
    };
}>;
export default Avatar;
//# sourceMappingURL=avatar.d.ts.map