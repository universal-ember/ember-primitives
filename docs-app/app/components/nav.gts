import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { link } from 'ember-primitives/helpers';
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
  return (
    str
      .split('-')
      .filter((text) => !text.match(/^[\d]+$/))
      .map((text) => `${text[0]?.toLocaleUpperCase()}${text.slice(1, text.length)}`)
      .join(' ')
      .split('.')[0] || ''
  );
};

const asComponent = (str: string) => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
};

const isComponents = (str: string) => str === 'components';
const isLoneIndex = (pages: Page[]) =>
  (pages.length === 1 && pages[0]?.name === 'index.md') || pages[0]?.name === 'intro.md';

const unExct = (str: string) => str.replace(/\.md$/, '');

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
          {{(titleize @name)}}
        {{/if}}
      </a>
    {{/let}}
  </template>;

const SubSectionLink: TOC<{ Element: HTMLAnchorElement; Args: { href: string; name: string } }> =
  <template>
    {{#let (link (unExct @href)) as |l|}}
      <a
        href={{unExct @href}}
        class="block w-full pl-3.5 before:pointer-events-none before:absolute before:-left-1 before:top-1/2 before:h-1.5 before:w-1.5 before:-translate-y-1/2 before:rounded-full
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
          {{(titleize @name)}}
        {{/if}}
      </a>
    {{/let}}
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
        class="sticky top-[4.75rem] -ml-0.5 h-[calc(100vh-4.75rem)] w-64 pointer-events-auto overflow-y-auto overflow-x-hidden overscroll-contain py-8 lg:py-16 pl-8 pr-8 xl:w-72 xl:pr-16 bg-slate-50 dark:bg-slate-800 lg:bg-transparent dark:lg:bg-transparent shadow-xl lg:shadow-none lg:pl-0.5 transition-transform lg:translate-x-0
          {{if this.ui.isNavOpen 'translate-x-0' '-translate-x-full'}}"
      >
        <nav aria-label="Main Navigation" class="text-base lg:text-sm">
          <ul role="list" class="space-y-9">
            {{#each-in this.docs.grouped as |group pages|}}
              <li>
                {{#if (isLoneIndex pages)}}
                  {{#each pages as |page|}}
                    <SectionLink @name={{group}} @href={{page.path}} {{on "click" this.closeNav}} />
                  {{/each}}
                {{else}}
                  <h2 class="font-medium font-display text-slate-900 dark:text-white">
                    {{titleize group}}
                  </h2>
                  <ul
                    role="list"
                    class="mt-2 space-y-2 border-l-2 border-slate-100 lg:mt-4 lg:space-y-4 lg:border-slate-200 dark:border-slate-800"
                  >
                    {{#each pages as |page|}}
                      <li class="relative">
                        <SubSectionLink
                          @name={{page.name}}
                          @href={{page.path}}
                          {{on "click" this.closeNav}}
                        />
                      </li>
                    {{/each}}
                  </ul>
                {{/if}}
              </li>
            {{/each-in}}
          </ul>
        </nav>
      </div>
      <div class="opacity-25 bg-slate-900"></div>
    </div>
  </template>
}
