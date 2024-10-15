import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { sentenceCase } from 'change-case';
import { link } from 'ember-primitives/helpers';
import { PageNav } from 'kolay/components';
import { getAnchor } from 'should-handle-link';

import type { TOC } from '@ember/component/template-only';
import type { DocsService, Page } from 'kolay';


function fixWords(text: string) {
  switch (text.toLowerCase()) {
  case 'ui': return "UI";
  case 'iframe': return 'IFrame';
  default: return text;
}
}

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
      .map((text) => fixWords(text))
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

  return x.title ? x.title : sentenceCase(x.name);
}

const asComponent = (str: string) => {
  return `<${str.split('.')[0]?.replaceAll(' ', '')} />`;
};

const isComponents = (str: string) => str === 'components';

const SectionLink: TOC<{ Element: HTMLAnchorElement; Args: { href: string; name: string } }> =
  <template>
    {{#let (link @href) as |l|}}
      <a
        href={{@href}}
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
    {{#let (link @href) as |l|}}
      <a
        href={{@href}}
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

export class Nav extends Component<{
  Element: HTMLElement;
  Args: {
    onClick?: () => void;
  };
}> {
  @service('kolay/docs') declare docs: DocsService;

  get humanSelected() {
    let path = this.docs.selected?.path;

    if (!path) return;

    return path.split('/').filter(Boolean).map(titleize).join(' / ');
  }

  closeNav = (event: Event) => {
    if (!getAnchor(event)) return;

    this.args.onClick?.();
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
    <aside class="bg-white dark:bg-slate-900" ...attributes>
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
              @href={{x.index.page.path}}
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
  </template>
}
