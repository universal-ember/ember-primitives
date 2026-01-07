import { hash } from "@ember/helper";

import { Separator } from "./separator.gts";

import type { TOC } from "@ember/component/template-only";
import type { WithBoundArgs } from "@glint/template";

export interface Signature {
  Element: HTMLElement;
  Args: {
    /**
     * The accessible label for the breadcrumb navigation.
     * Defaults to "Breadcrumb"
     */
    label?: string;
  };
  Blocks: {
    default: [
      {
        /**
         * A separator component to place between breadcrumb items.
         * Typically renders as "/" or ">" with aria-hidden="true".
         * Pre-configured to render as an <li> element for proper HTML structure.
         */
        Separator: WithBoundArgs<typeof Separator, "as">;
      },
    ];
  };
}

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
export const Breadcrumb: TOC<Signature> = <template>
  <nav aria-label={{if @label @label "Breadcrumb"}} ...attributes>
    <ol>
      {{yield (hash Separator=(component Separator as="li"))}}
    </ol>
  </nav>
</template>;

export default Breadcrumb;
