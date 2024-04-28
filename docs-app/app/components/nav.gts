import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { pascalCase, sentenceCase } from 'change-case';
import { link } from 'ember-primitives/helpers';
import { isLink } from 'ember-primitives/proper-links';
import { GroupNav, PageNav } from 'kolay/components';

import type { TOC } from '@ember/component/template-only';
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

function nameFor(x: Page) {
  // We defined componentName via json file
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  if ('componentName' in x) {
    return `${x.componentName}`;
  }

  if (x.path.includes('/components/')) {
    return `<${pascalCase(x.name)} />`;
  }

  return sentenceCase(x.name);
}

const asComponent = (str: string) => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
};

const unExct = (str: string) => str.replace(/\.md$/, '');
const isComponents = (str: string) => str === 'components';
const isLoneIndex = (pages: Page[]) =>
  (pages.length === 1 && pages[0]?.name === 'index') || pages[0]?.name === 'intro';

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


const SideNav: TOC<{ Element: HTMLElement }> = <template>
  <aside>
    <PageNav @activeClass="main-nav-active" ...attributes>
      <:page as |page|>
        {{nameFor page}}
      </:page>

      <:collection as |collection|>
      {{log collection}}
        {{#if (isLoneIndex collection.pages)}}
          {{#each collection.pages as |page|}}
            <SectionLink @name={{page.overriddenName}} @href={{page.path}} />
          {{/each}}
        {{else}}
          <h2 class="font-medium font-display text-slate-900 dark:text-white">
            {{titleize collection.name}}
          </h2>
        {{/if}}
      </:collection>
    </PageNav>
  </aside>
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
        class="sticky top-[4.75rem] -ml-0.5 h-[calc(100vh-4.75rem)] w-64 pointer-events-auto overflow-y-auto overflow-x-hidden overscroll-contain py-8 lg:py-16 pl-8 pr-8 xl:w-72 xl:pr-16 bg-slate-50 dark:bg-slate-800 lg:bg-transparent dark:lg:bg-transparent shadow-xl lg:shadow-none lg:pl-0.5 transition-transform lg:translate-x-0
          {{if this.ui.isNavOpen 'translate-x-0' '-translate-x-full'}}"
      >
        <nav aria-label="Main Navigation" class="text-base lg:text-sm" {{on 'click' this.closeNav}}>
          <SideNav />
        </nav>
      </div>
      <div class="opacity-25 bg-slate-900"></div>
    </div>
  </template>
}
