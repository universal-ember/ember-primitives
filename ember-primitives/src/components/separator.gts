import { element } from "ember-element-helper";

import type { TOC } from "@ember/component/template-only";

type Orientation = "horizontal" | "vertical";

function normalizeTagName(tagName: string) {
  return tagName.trim().toLowerCase();
}

function getElementTag(tagName: undefined | string) {
  if (tagName) return tagName;

  // Prefer semantic HTML for separators.
  return "hr";
}

function roleFor(tagName: string, decorative: undefined | boolean) {
  if (decorative) return undefined;

  // <hr> already has implicit role="separator".
  if (normalizeTagName(tagName) === "hr") return undefined;

  return "separator";
}

function ariaHiddenFor(decorative: undefined | boolean) {
  return decorative ? "true" : undefined;
}

function ariaOrientationFor(orientation: undefined | Orientation, decorative: undefined | boolean) {
  if (decorative) return undefined;
  // `separator` has an implicit aria-orientation of horizontal.
  // Only specify when authors opt in (e.g. vertical separators).
  return orientation;
}

function shouldYield(decorative: undefined | boolean, tagName: string) {
  // `<hr>` is a void element and must not have children.
  if (normalizeTagName(tagName) === "hr") return false;

  // Content inside a `separator` is presentational to AT; only yield for decorative
  // separators so consumers don't accidentally rely on it for semantics.
  return Boolean(decorative);
}

export interface Signature {
  Element: HTMLElement;
  Args: {
    /**
     * The tag name to use for the separator element.
     * Defaults to `<hr>` for non-decorative separators.
     * You can override this (e.g. `"li"` in menus, or `"span"` for inline separators).
     *
     * For example, in breadcrumbs where separators are siblings to `<li>` elements:
     * ```gjs
     * <Separator @as="li" @decorative={{true}}>/</Separator>
     * ```
     */
    as?: string;

    /**
     * When true, hides the separator from assistive technologies.
     *
     * Use this for purely decorative separators, such as breadcrumb slashes.
     */
    decorative?: boolean;

    /**
     * Sets `aria-orientation`. `separator` has an implicit orientation of `horizontal`.
     * Provide this when the separator is vertical.
     */
    orientation?: Orientation;
  };
  Blocks: {
    default: [];
  };
}

/**
 * A separator component that follows the ARIA `separator` role guidance.
 *
 * By default, this component renders a semantic separator (`<hr>`). When using a
 * non-`hr` tag via `@as`, it adds `role="separator"`.
 *
 * For purely decorative separators (e.g. breadcrumb slashes), set `@decorative={{true}}`
 * to apply `aria-hidden="true"`.
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
 *       <Separator @as="li" @decorative={{true}}>/</Separator>
 *       <li><a href="/docs">Docs</a></li>
 *       <Separator @as="li" @decorative={{true}}>/</Separator>
 *       <li>Current</li>
 *     </ol>
 *   </nav>
 * </template>
 * ```
 */
export const Separator: TOC<Signature> = <template>
  {{#let (getElementTag @as) as |tagName|}}
    {{#let (element tagName) as |El|}}
      {{! @glint-ignore
            https://github.com/tildeio/ember-element-helper/issues/91
            https://github.com/typed-ember/glint/issues/610
      }}
      <El
        aria-hidden={{ariaHiddenFor @decorative}}
        role={{roleFor tagName @decorative}}
        aria-orientation={{ariaOrientationFor @orientation @decorative}}
        ...attributes
      >
        {{#if (shouldYield @decorative tagName)}}
          {{yield}}
        {{/if}}
      </El>
    {{/let}}
  {{/let}}
</template>;

export default Separator;
