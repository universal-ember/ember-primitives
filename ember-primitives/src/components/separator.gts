import type { TOC } from "@ember/component/template-only";

export interface Signature {
  Element: HTMLSpanElement;
  Blocks: {
    default: [];
  };
}

/**
 * A semantic wrapper component that renders separators with proper ARIA attributes.
 *
 * The Separator is a simple, semantic wrapper that automatically adds `aria-hidden="true"`
 * to hide decorative content from screen readers. It's primarily a documentation tool
 * that makes your code more readable and maintainable.
 *
 * For example:
 *
 * ```gjs live preview
 * import { Separator } from 'ember-primitives';
 *
 * <template>
 *   <nav>
 *     <ol style="display: flex; gap: 0.5rem; list-style: none; padding: 0;">
 *       <li><a href="/">Home</a></li>
 *       <Separator>/</Separator>
 *       <li><a href="/docs">Docs</a></li>
 *       <Separator>/</Separator>
 *       <li>Current</li>
 *     </ol>
 *   </nav>
 * </template>
 * ```
 */
export const Separator: TOC<Signature> = <template>
  <span aria-hidden="true" ...attributes>
    {{yield}}
  </span>
</template>;

export default Separator;
