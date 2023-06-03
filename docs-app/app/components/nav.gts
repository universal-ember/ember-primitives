import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { Link } from 'ember-primitives';
import { isLink } from 'ember-primitives/proper-links';

import type { TOC } from '@ember/component/template-only';
import type DocsService from 'docs-app/services/docs';
import type { Page } from 'docs-app/services/types';
import type UI from 'docs-app/services/ui';

/**
 * Converts 1-2-hyphenated-thing
 * to
 *   Hyphenated Thing
 */
const titleize = (str: string) => {
  return str
    .split('-')
    .filter((text) => !text.match(/^[\d]+$/))
    .map((text) => `${text[0]?.toLocaleUpperCase()}${text.slice(1, text.length)}`)
    .join(' ')
    .split('.')[0] || '';
};

const asComponent = (str: string) => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
}

const isComponents = (str: string) => str === 'components';
const isLoneIndex = (pages: Page[]) => pages.length === 1 && pages[0]?.name === 'index.md' || pages[0]?.name === 'intro.md';

const unExct = (str: string) => str.replace(/\.md$/, '');

const NameLink: TOC<{ Args: {  href: string; name: string } }> = <template>
  <Link @href={{unExct @href}}>
    {{#if (isComponents @name)}}
      {{asComponent (titleize @name)}}
    {{else}}
      {{ (titleize @name)}}
    {{/if}}
  </Link>
</template>;

export class Nav extends Component {
  @service declare docs: DocsService;
  @service declare ui: UI;

  get humanSelected() {
    let path = this.docs.selected?.path;

    if (!path) return;

    return path.split('/').filter(Boolean).map(titleize).join(' / ');
  }

  isSelected = ({ path }: { path: string }) => {
    return this.docs.selected?.path === path;
  };

  closeNav = (event: Event) => {
    if (!isLink(event)) return;

    this.ui.isNavOpen = false;
  };

  <template>
    {{!--
      This nav needs an aria-label to get around
      "Ensure landmarks are unique"
      because some demos render navs, and it's important that those
      demos are as simple as possible.
    --}}
    <nav
      aria-label="Main Navigation"
      class={{if this.ui.isNavOpen "open"}}
      {{!-- nav isn't actually made in to an interactive element,
        it's an event delegation handler.
        The links themselves remain the actual interactive elements.
      --}}
      {{!-- template-lint-disable no-invalid-interactive --}}
      {{on 'click' this.closeNav}}
    >
      <ul>
        {{#each-in this.docs.grouped as |group pages|}}
          <li>
            {{#if (isLoneIndex pages)}}
              {{#each pages as |page|}}
                <NameLink @name={{group}} @href={{page.path}} />
              {{/each}}
            {{else}}
              <h2>{{titleize group}}</h2>
              <ul>
                {{#each pages as |page|}}
                  <li>
                    <NameLink @name={{page.name}} @href={{page.path}} />
                  </li>
                {{/each}}
              </ul>
            {{/if}}
          </li>
        {{/each-in}}
      </ul>
    </nav>
  </template>
}
