
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

function getHead() {
  return document.head;
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
const InHead = setComponentTemplate(precompileTemplate("\n  {{#in-element (getHead) insertBefore=null}}\n    {{yield}}\n  {{/in-element}}\n", {
  strictMode: true,
  scope: () => ({
    getHead
  })
}), templateOnly());

export { InHead };
//# sourceMappingURL=head.js.map
