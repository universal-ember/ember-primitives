import { hash } from '@ember/helper';
import { Separator } from './separator.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

/**
 * A breadcrumb navigation component that displays the current page's location within a navigational hierarchy.
 *
 * Breadcrumbs help users understand their current location and provide a way to navigate back through the hierarchy.
 *
 * For example:
 *
 * ```gjs live preview
 * import { Breadcrumb } from 'ember-primitives';
 *
 * <template>
 *   <Breadcrumb as |b|>
 *     <li>
 *       <a href="/">Home</a>
 *     </li>
 *     <b.Separator>/</b.Separator>
 *     <li>
 *       <a href="/docs">Docs</a>
 *     </li>
 *     <b.Separator>/</b.Separator>
 *     <li aria-current="page">
 *       Breadcrumb
 *     </li>
 *   </Breadcrumb>
 * </template>
 * ```
 */
const Breadcrumb = setComponentTemplate(precompileTemplate("<nav aria-label={{if @label @label \"Breadcrumb\"}} ...attributes>\n  <ol>\n    {{yield (hash Separator=(component Separator as=\"li\" decorative=true))}}\n  </ol>\n</nav>", {
  strictMode: true,
  scope: () => ({
    hash,
    Separator
  })
}), templateOnly());

export { Breadcrumb, Breadcrumb as default };
//# sourceMappingURL=breadcrumb.js.map
