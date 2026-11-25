import type { TOC } from "@ember/component/template-only";
export interface Signature {
    Blocks: {
        /**
         * Content to render in to the `<head>` element
         */
        default: [];
    };
}
/**
 * Utility component to place elements in the document `<head>`
 *
 * When this component is unrendered, its contents will be removed as well.
 *
 * @example
 * ```js
 * import { InHead } from 'ember-primitives/head';
 *
 * <template>
 *   {{#if @useBootstrap}}
 *     <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>
 *     <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css">
 *   {{/if}}
 * </template>
 * ```
 */
export declare const InHead: TOC<Signature>;
//# sourceMappingURL=head.d.ts.map