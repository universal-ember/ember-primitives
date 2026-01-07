import { element } from "ember-element-helper";

import type { TOC } from "@ember/component/template-only";

function getElementTag(tagName: undefined | string) {
  return tagName || "span";
}

export interface Signature {
  Element: HTMLElement;
  Args: {
    /**
     * The tag name to use for the separator element.
     * Defaults to "span", but can be changed to "li" or other tags
     * depending on the context (e.g., when used in lists).
     *
     * For example, in breadcrumbs where separators are siblings to `<li>` elements:
     * ```gjs
     * <Separator @as="li">/</Separator>
     * ```
     */
    as?: string;
  };
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
 *       <Separator @as="li">/</Separator>
 *       <li><a href="/docs">Docs</a></li>
 *       <Separator @as="li">/</Separator>
 *       <li>Current</li>
 *     </ol>
 *   </nav>
 * </template>
 * ```
 */
export const Separator: TOC<Signature> = <template>
  {{#let (element (getElementTag @as)) as |El|}}
    {{! @glint-ignore
          https://github.com/tildeio/ember-element-helper/issues/91
          https://github.com/typed-ember/glint/issues/610
    }}
    <El aria-hidden="true" ...attributes>
      {{yield}}
    </El>
  {{/let}}
</template>;

export default Separator;
