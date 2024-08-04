import type { TOC } from '@ember/component/template-only';
/**
 * Render content in a shadow dom, attached to a div.
 *
 * Uses the [shadow DOM][mdn-shadow-dom] API.
 *
 * [mdn-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM
 *
 * This is useful when you want to render content that escapes your app's styles.
 */
export declare const Shadowed: TOC<{
    /**
     * The shadow dom attaches to a div element.
     * You may specify any attribute, and it'll be applied to this host element.
     */
    Element: HTMLDivElement;
    Args: {
        /**
         * @public
         *
         * By default, shadow-dom does not include any styles.
         * Setting this to true will include all the `<style>` tags
         * that are present in the `<head>` element.
         */
        includeStyles?: boolean;
    };
    Blocks: {
        /**
         * Content to be placed within the ShadowDOM
         */
        default: [];
    };
}>;
export default Shadowed;
//# sourceMappingURL=shadowed.d.ts.map