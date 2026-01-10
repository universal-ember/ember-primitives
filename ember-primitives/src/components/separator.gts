import { assert } from "@ember/debug";

import { element } from "ember-element-helper";

import type { TOC } from "@ember/component/template-only";

type Orientation = "horizontal" | "vertical";

function normalizeTagName(tagName: string) {
  return tagName.trim().toLowerCase();
}

function getElementTag(
  tagName: undefined | string,
  interactive: undefined | boolean,
  decorative: undefined | boolean,
) {
  if (tagName) return tagName;

  assert(
    "`<Separator />` cannot be both interactive and decorative.",
    !(interactive && decorative),
  );

  // Prefer semantic HTML for non-decorative separators.
  // For interactive separators, <div> is a more practical default than <hr>.
  if (interactive && !decorative) return "div";

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

function ariaLabelFor(label: unknown, interactive: undefined | boolean) {
  if (!interactive) return undefined;
  if (label === undefined) return undefined;

  assert(
    "`<Separator @interactive={{true}} />` requires `@label` (if provided) to be a string (aria-label).",
    typeof label === "string",
  );

  // ARIA: an accessible name is only recommended when there are multiple focusable separators.
  return label as string;
}

function ariaOrientationFor(orientation: undefined | Orientation, decorative: undefined | boolean) {
  if (decorative) return undefined;
  // `separator` has an implicit aria-orientation of horizontal.
  // Only specify when authors opt in (e.g. vertical separators).
  return orientation;
}

function valueNowFor(
  interactive: undefined | boolean,
  valueNow: unknown,
  valueMin: unknown,
  valueMax: unknown,
) {
  if (!interactive) return undefined;

  assert(
    "`<Separator @interactive={{true}} />` requires `@valueNow` to be a number (aria-valuenow).",
    typeof valueNow === "number" && Number.isFinite(valueNow),
  );

  if (typeof valueMin === "number" && typeof valueMax === "number") {
    assert(
      "`<Separator @interactive={{true}} />` requires `@valueMin` to be <= `@valueMax`.",
      valueMin <= valueMax,
    );
    assert(
      "`<Separator @interactive={{true}} />` requires `@valueNow` to be within [`@valueMin`, `@valueMax`].",
      (valueNow as number) >= valueMin && (valueNow as number) <= valueMax,
    );
  }

  return valueNow as number;
}

function valueMinFor(interactive: undefined | boolean, valueMin: unknown, valueMax: unknown) {
  if (!interactive) return undefined;
  if (valueMin === undefined) return undefined;

  assert(
    "`<Separator @interactive={{true}} />` requires `@valueMin` (if provided) to be a number (aria-valuemin).",
    typeof valueMin === "number" && Number.isFinite(valueMin),
  );

  if (typeof valueMax === "number") {
    assert(
      "`<Separator @interactive={{true}} />` requires `@valueMin` to be <= `@valueMax`.",
      (valueMin as number) <= valueMax,
    );
  }

  return valueMin as number;
}

function valueMaxFor(interactive: undefined | boolean, valueMax: unknown, valueMin: unknown) {
  if (!interactive) return undefined;
  if (valueMax === undefined) return undefined;

  assert(
    "`<Separator @interactive={{true}} />` requires `@valueMax` (if provided) to be a number (aria-valuemax).",
    typeof valueMax === "number" && Number.isFinite(valueMax),
  );

  if (typeof valueMin === "number") {
    assert(
      "`<Separator @interactive={{true}} />` requires `@valueMin` to be <= `@valueMax`.",
      valueMin <= (valueMax as number),
    );
  }

  return valueMax as number;
}

function valueTextFor(interactive: undefined | boolean, valueText: unknown) {
  if (!interactive) return undefined;
  if (valueText === undefined) return undefined;

  assert(
    "`<Separator @interactive={{true}} />` requires `@valueText` (if provided) to be a string (aria-valuetext).",
    typeof valueText === "string",
  );

  return valueText as string;
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

    /**
     * When true, renders a focusable separator widget.
     *
     * Per ARIA, focusable separators MUST have `aria-valuenow` (use `@valueNow`).
     * Note: this component does not implement dragging/keyboard behavior; it only
     * supplies the required semantics.
     */
    interactive?: boolean;

    /**
     * Current separator position (aria-valuenow). Required when `@interactive` is true.
     */
    valueNow?: number;

    /**
     * Minimum separator position (aria-valuemin). Optional.
     */
    valueMin?: number;

    /**
     * Maximum separator position (aria-valuemax). Optional.
     */
    valueMax?: number;

    /**
     * Human-friendly value for assistive tech (aria-valuetext). Optional.
     */
    valueText?: string;

    /**
     * Optional accessible name for focusable separators (aria-label).
     * Recommended when there is more than one focusable separator.
     */
    label?: string;
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
  {{#let (getElementTag @as @interactive @decorative) as |tagName|}}
    {{#let (element tagName) as |El|}}
      {{! @glint-ignore
            https://github.com/tildeio/ember-element-helper/issues/91
            https://github.com/typed-ember/glint/issues/610
      }}
      <El
        aria-hidden={{ariaHiddenFor @decorative}}
        aria-label={{ariaLabelFor @label @interactive}}
        role={{roleFor tagName @decorative}}
        aria-orientation={{ariaOrientationFor @orientation @decorative}}
        aria-valuenow={{valueNowFor @interactive @valueNow @valueMin @valueMax}}
        aria-valuemin={{valueMinFor @interactive @valueMin @valueMax}}
        aria-valuemax={{valueMaxFor @interactive @valueMax @valueMin}}
        aria-valuetext={{valueTextFor @interactive @valueText}}
        tabindex={{if @interactive "0"}}
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
