import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { ExternalLink } from './external-link';

import type RouterService from '@ember/routing/router-service';

/**
  * TODO: make template-only component,
* and use class-based modifier?
  */

  interface Signature {
    Element: HTMLAnchorElement;
    Args: {
      href: string;
    };
    Blocks: { default: []}
  }


export class Link extends Component<Signature> {
  <template>
    {{#if (isExternal @href)}}
      <ExternalLink href={{@href}} ...attributes>
        {{yield}}
      </ExternalLink>
    {{else}}
      <a href={{if @href @href '##missing##'}} {{on "click" this.handleClick}} ...attributes>
        {{yield}}
      </a>
    {{/if}}

  </template>

  @service declare router: RouterService;

  handleClick = (event: Event) => {
    event.preventDefault();

    assert('[BUG]', event.target instanceof HTMLAnchorElement);

    let path = new URL(event.target.href).pathname;

    this.router.transitionTo(path);
  }
}


function isExternal(href: string) {
  if (!href) return false;
  if (href.startsWith('#')) return false;
  if (href.startsWith('/')) return false;

  return location.origin !== new URL(href).origin;
}

