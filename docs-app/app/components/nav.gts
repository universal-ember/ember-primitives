import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

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
    .join(' ');
};

export class Selection extends Component {
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
      {{#each-in this.docs.grouped as |group tutorials|}}
      <li>
        {{titleize group}}
          <ul>
          {{#each tutorials as |tutorial|}}
            <li>
              <a href={{tutorial.path}}>
                {{titleize tutorial.name}}
              </a>
            </li>
          {{/each}}
          </ul>
          </li>
      {{/each-in}}
      </ul>
    </nav>
  </template>
}
