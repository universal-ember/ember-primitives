/**
 * TODO: make template-only component,
 * and use class-based modifier?
 *
 * This would require that modifiers could run pre-render
 */
import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { ExternalLink } from './external-link';

import type RouterService from '@ember/routing/router-service';

export interface Signature {
  Element: HTMLAnchorElement;
  Args: {
    /**
     * the `href` string value to set on the anchor element.
     */
    href: string;
  };
  Blocks: {
    default: [
      {
        /**
         * Indicates if the passed `href` is pointing to an external site.
         * Useful if you want your links to have additional context for when
         * a user is about to leave your site.
         *
         * For example:
         *
         * ```gjs live preview
         * import { Link } from 'ember-primitives';
         *
         * const MyLink = <template>
         *   <Link @href={{@href}} as |a|>
         *     {{yield}}
         *     {{#if a.isExternal}}
         *       ➚
         *     {{/if}}
         *   </Link>
         * </template>;
         *
         * <template>
         *   <MyLink @href="https://developer.mozilla.org">MDN</MyLink> &nbsp;&nbsp;
         *   <MyLink @href="/">Home</MyLink>
         *  </template>
         * ```
         */
        isExternal: boolean;
      }
    ];
  };
}

/**
 * A light wrapper around the [Anchor element][mdn-a], which will appropriately make your link an external link if the passed `@href` is not on the same domain.
 *
 *
 * [mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
 */
export class Link extends Component<Signature> {
  <template>
    {{#if (isExternal @href)}}
      <ExternalLink href={{@href}} ...attributes>
        {{yield (hash isExternal=true)}}
      </ExternalLink>
    {{else}}
      <a href={{if @href @href '##missing##'}} {{on 'click' this.handleClick}} ...attributes>
        {{yield (hash isExternal=false)}}
      </a>
    {{/if}}
  </template>

  @service declare router: RouterService;

  handleClick = (event: Event) => {
    event.preventDefault();

    assert('[BUG]', event.target instanceof HTMLAnchorElement);

    let path = new URL(event.target.href).pathname;

    this.router.transitionTo(path);
  };
}

export default Link;

function isExternal(href: string) {
  if (!href) return false;
  if (href.startsWith('#')) return false;
  if (href.startsWith('/')) return false;

  return location.origin !== new URL(href).origin;
}
