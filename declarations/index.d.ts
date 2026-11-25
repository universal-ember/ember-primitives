type Level = 1 | 2 | 3 | 4 | 5 | 6;
/**
 * Determines what your heading level should be (h1 - h6).
 *
 * In your app, you can use any of `<section>`, `<article>`, and `<aside>` elements to denote when the [_Section Heading_][mdn-h] element should change its level.
 *
 * [mdn-h]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/Heading_Elements
 *
 * ```js
 * import { getSectionHeadingLevel } from 'which-heading-do-i-need';
 *
 * getSectionHeadingLevel(nodeRef);
 * ```
 *
 * Can also receive options, such as `startAt`
 * Which is the root heading level to use if traversal makes it to the "top"
 * of the available DOM tree.
 * Defaults to 1 (as in h1)
 *
 * ```js
 * import { getSectionHeadingLevel } from 'which-heading-do-i-need';
 *
 * getSectionHeadingLevel(nodeRef, { startAt: 3 });
 *
 */
export declare function getSectionHeadingLevel(node: Text, options?: {
    /**
     * The root heading level to use if traversal makes it to the "top"
     * of the available DOM tree.
     *
     * Defaults to 1 (as in h1)
     */
    startAt?: Level;
}): Level;
export {};
//# sourceMappingURL=index.d.ts.map