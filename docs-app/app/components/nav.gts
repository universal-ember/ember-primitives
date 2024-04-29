import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { sentenceCase } from 'change-case';
import { link } from 'ember-primitives/helpers';
import { isLink } from 'ember-primitives/proper-links';
import { PageNav } from 'kolay/components';

import type { TOC } from '@ember/component/template-only';
import type UI from 'docs-app/services/ui';
import type { DocsService, Page } from 'kolay';

/**
 * Converts 1-2-hyphenated-thing
 * to
 *   Hyphenated Thing
 */
const titleize = (str: string) => {
  return (
    str
      .split(/-|\s/)
      .filter(Boolean)
      .filter((text) => !text.match(/^[\d]+$/))
      .map((text) => `${text[0]?.toLocaleUpperCase()}${text.slice(1, text.length)}`)
      .join(' ')
      .split('.')[0] || ''
  );
};

function nameFor(x: Page) {
  // We defined componentName via json file
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if ('componentName' in x) {
    return `${x.componentName}`;
  }

  return sentenceCase(x.name);
}

const asComponent = (str: string) => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
};

const unExct = (str: string) => str.replace(/\.md$/, '');
const isComponents = (str: string) => str === 'components';

const SectionLink: TOC<{ Element: HTMLAnchorElement; Args: { href: string; name: string } }> =
  <template>
    {{#let (link (unExct @href)) as |l|}}
      <a
        href={{unExct @href}}
        class="font-medium font-display
          {{if
            l.isActive
            'text-sky-500'
            'text-slate-900 hover:text-slate-600 dark:text-white  dark:hover:text-slate-300'
          }}"
        {{on "click" l.handleClick}}
        ...attributes
      >
        {{#if (isComponents @name)}}
          {{asComponent (titleize @name)}}
        {{else}}
          {{titleize @name}}
        {{/if}}
      </a>
    {{/let}}
  </template>;

const SubSectionLink: TOC<{ Element: HTMLAnchorElement; Args: { href: string; name: string } }> =
  <template>
    {{#let (link (unExct @href)) as |l|}}
      <a
        href={{unExct @href}}
        class="block w-full before:pointer-events-none before:absolute before:-left-1 before:top-1/2 before:h-1.5 before:w-1.5 before:-translate-y-1/2 before:rounded-full
          {{if
            l.isActive
            'font-semibold text-sky-500 before:bg-sky-500'
            'text-slate-500 before:hidden before:bg-slate-300 hover:text-slate-600 hover:before:block dark:text-slate-400 dark:before:bg-slate-700 dark:hover:text-slate-300'
          }}"
        {{on "click" l.handleClick}}
        ...attributes
      >
        {{#if (isComponents @name)}}
          {{asComponent (titleize @name)}}
        {{else}}
          {{titleize @name}}
        {{/if}}
      </a>
    {{/let}}
  </template>;

export class Nav extends Component {
  @service('kolay/docs') declare docs: DocsService;
  @service declare ui: UI;

  get humanSelected() {
    let path = this.docs.selected?.path;

    if (!path) return;

    return path.split('/').filter(Boolean).map(titleize).join(' / ');
  }

  closeNav = (event: Event) => {
    if (!isLink(event)) return;

    this.ui.isNavOpen = false;
  };

  /**
   *
   * This nav needs an aria-label to get around
   *  "Ensure landmarks are unique"
   *  because some demos render navs, and it's important that those
   *  demos are as simple as possible.
   *
   *
   *  nav isn't actually made in to an interactive element,
   *  it's an event delegation handler.
   *  The links themselves remain the actual interactive elements.
   */
  <template>
    <div class="fixed inset-0 z-10 pointer-events-none lg:relative lg:block lg:flex-none">
      <div class="absolute inset-y-0 right-0 w-[50vw] bg-slate-50 dark:hidden hidden lg:block" />
      <div
        class="absolute bottom-0 right-0 hidden w-px h-12 top-16 bg-gradient-to-t from-slate-800 dark:block"
      />
      <div class="absolute bottom-0 right-0 hidden w-px top-28 bg-slate-800 dark:block" />
      <div
        class="sticky top-[4.75rem] -ml-0.5 h-[calc(100vh-4.75rem)] w-64 pointer-events-auto overflow-y-auto overflow-x-hidden overscroll-contain py-4 lg:py-4 pl-4 pr-8 xl:w-72 xl:pr-16 bg-slate-50 dark:bg-slate-800 lg:bg-transparent dark:lg:bg-transparent shadow-xl lg:shadow-none lg:pl-0.5 transition-transform lg:translate-x-0
          {{if this.ui.isNavOpen 'translate-x-0' '-translate-x-full'}}"
      >
        <aside>
          <PageNav aria-label="Main Navigation">
            <:page as |x|>
              <SubSectionLink
                @href={{x.page.path}}
                @name={{nameFor x.page}}
                {{on "click" this.closeNav}}
              />
            </:page>

            <:collection as |x|>
              {{#if x.index}}
                <SectionLink
                  @href={{unExct x.index.page.path}}
                  @name={{titleize x.collection.name}}
                  {{on "click" this.closeNav}}
                />
              {{else}}
                <h2>
                  {{titleize x.collection.name}}
                </h2>
              {{/if}}
            </:collection>
          </PageNav>
        </aside>
      </div>
      <div class="opacity-25 bg-slate-900"></div>
    </div>
  </template>
}
