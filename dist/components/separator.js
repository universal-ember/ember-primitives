import { element } from 'ember-element-helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

function normalizeTagName(tagName) {
  return tagName.trim().toLowerCase();
}
function getElementTag(tagName) {
  if (tagName) return tagName;
  return "hr";
}
function roleFor(tagName, decorative) {
  if (decorative) return undefined;
  // <hr> already has implicit role="separator".
  if (normalizeTagName(tagName) === "hr") return undefined;
  return "separator";
}
function ariaHiddenFor(decorative) {
  return decorative ? "true" : undefined;
}
function ariaOrientationFor(orientation, decorative) {
  if (decorative) return undefined;
  // `separator` has an implicit aria-orientation of horizontal.
  // Only specify when authors opt in (e.g. vertical separators).
  return orientation;
}
function shouldYield(decorative, tagName) {
  // `<hr>` is a void element and must not have children.
  if (normalizeTagName(tagName) === "hr") return false;
  // Content inside a `separator` is presentational to AT; only yield for decorative
  // separators so consumers don't accidentally rely on it for semantics.
  return Boolean(decorative);
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
const Separator = setComponentTemplate(precompileTemplate("{{#let (getElementTag @as) as |tagName|}}\n  {{#let (element tagName) as |El|}}\n    <El aria-hidden={{ariaHiddenFor @decorative}} role={{roleFor tagName @decorative}} aria-orientation={{ariaOrientationFor @orientation @decorative}} ...attributes>\n      {{#if (shouldYield @decorative tagName)}}\n        {{yield}}\n      {{/if}}\n    </El>\n  {{/let}}\n{{/let}}", {
  strictMode: true,
  scope: () => ({
    getElementTag,
    element,
    ariaHiddenFor,
    roleFor,
    ariaOrientationFor,
    shouldYield
  })
}), templateOnly());

export { Separator, Separator as default };
//# sourceMappingURL=separator.js.map
