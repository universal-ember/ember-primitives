import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { link } from '../helpers/link.js';
import { ExternalLink } from './external-link.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

/**
 * TODO: make template-only component,
 * and use class-based modifier?
 *
 * This would require that modifiers could run pre-render
 */
/**
 * A light wrapper around the [Anchor element][mdn-a], which will appropriately make your link an external link if the passed `@href` is not on the same domain.
 *
 *
 * [mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
 */
const Link = setComponentTemplate(precompileTemplate("\n  {{#let (link @href includeActiveQueryParams=@includeActiveQueryParams activeOnSubPaths=@activeOnSubPaths) as |l|}}\n    {{#if l.isExternal}}\n      <ExternalLink href={{@href}} ...attributes>\n        {{yield (hash isExternal=true isActive=false)}}\n      </ExternalLink>\n    {{else}}\n      <a data-active={{l.isActive}} href={{if @href @href \"##missing##\"}} {{on \"click\" l.handleClick}} ...attributes>\n        {{yield (hash isExternal=false isActive=l.isActive)}}\n      </a>\n    {{/if}}\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    link,
    ExternalLink,
    hash,
    on
  })
}), templateOnly());

export { Link, Link as default };
//# sourceMappingURL=link.js.map
