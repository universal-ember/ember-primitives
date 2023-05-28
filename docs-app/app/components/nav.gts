import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { service } from '@ember/service';
import { Link } from 'ember-primitives';

import type { TOC } from '@ember/component/template-only';
import type RouterService from '@ember/routing/router-service';
import type DocsService from 'docs-app/services/docs';

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
const isLoneIndex = (pages) => pages.length === 1 && pages[0].name === 'index.md';

const NameLink: TOC<{ Args: {  href: string; name: string } }> = <template>
  <Link href={{@href}}>
    {{#if (isComponents @name)}}
      {{asComponent (titleize @name)}}
    {{else}}
      {{ (titleize @name)}}
    {{/if}}
  </Link>
</template>;

export class Nav extends Component {
  @service declare docs: DocsService;
  @service declare router: RouterService;

  get humanSelected() {
    let path = this.docs.selected?.path;

    if (!path) return;

    return path.split('/').filter(Boolean).map(titleize).join(' / ');
  }

  handleChange = (event: Event) => {
    assert(`Target must be select element`, event.target instanceof HTMLSelectElement);

    this.router.transitionTo(event.target.value);
  };

  isSelected = ({ path }: { path: string }) => {
    return this.docs.selected?.path === path;
  };

  <template>
    <nav>
      <ul>
      {{#each-in this.docs.grouped as |group pages|}}
        <li>
          {{#if (isLoneIndex pages)}}
            {{#each pages as |page|}}
              <NameLink @name={{group}} @href={{page.path}} />
            {{/each}}
          {{else}}
            {{titleize group}}
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
