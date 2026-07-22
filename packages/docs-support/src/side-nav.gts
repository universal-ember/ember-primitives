import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { sentenceCase } from 'change-case';
import { link } from 'ember-primitives/helpers';
import { PageNav } from 'kolay/components';
import { getAnchor } from 'should-handle-link';

import type { TOC } from '@ember/component/template-only';
import type RouterService from '@ember/routing/router-service';
import type { Page } from 'kolay';

type CustomPage = Page & {
  title?: string;
};

function fixWords(text: string) {
  switch (text.toLowerCase()) {
    case 'ui':
      return 'UI';
    case 'iframe':
      return 'IFrame';
    default:
      return text;
  }
}

const joinUrl = (...strs: string[]) => {
  const prefix = strs[0]?.startsWith('/') ? '/' : '';

  return (
    prefix +
    strs
      .map((s) => s.replace(/^\//, '').replace(/\/$/, ''))
      .filter((x) => !!x)
      .join('/')
  );
};

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

function nameFor(x: Page): string {
  if ('componentName' in x) {
    return String(x.componentName);
  }

  const page = x as CustomPage;

  return page.title ? page.title : sentenceCase(page.name);
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
        class="section-link {{if l.isActive 'is-active'}}"
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
        class="subsection-link {{if l.isActive 'is-active'}}"
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

export class SideNav extends Component<{
  Element: HTMLElement;
  Args: {
    onClick?: () => void;
  };
}> {
  @service('router') declare router: RouterService;

  get rootUrl() {
    return this.router.rootURL;
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
    <aside class="side-nav" ...attributes>
      <PageNav aria-label="Main Navigation">
        <:page as |x|>
          <SubSectionLink
            @href={{joinUrl this.rootUrl x.page.path}}
            @name={{nameFor x.page}}
            {{on "click" this.closeNav}}
          />
        </:page>

        <:collection as |x|>
          {{#if x.index}}
            <SectionLink
              @href={{joinUrl this.rootUrl x.index.page.path}}
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

    <style scoped>
      .side-nav {
        background-color: transparent;
      }

      .side-nav ul {
        list-style: none;
        margin: 0;
        padding: 0;
      }

      .side-nav h2 {
        font-size: 0.75rem;
        font-weight: 600;
        font-family: var(--font-sans);
        color: var(--doc-text-3);
        letter-spacing: 0.04em;
        text-transform: uppercase;
        margin: 0 0 0.35rem;
        padding: 0 0.625rem;
      }

      .section-link {
        display: block;
        font-weight: 500;
        font-size: 0.875rem;
        line-height: 1.4;
        font-family: var(--font-sans);
        color: var(--doc-text-1);
        text-decoration: none;
        border-radius: var(--doc-radius-sm);
        padding: 0.375rem 0.625rem;
        transition:
          color 0.12s ease,
          background-color 0.12s ease;
      }

      .section-link:hover {
        color: var(--doc-brand-1);
        background-color: var(--doc-brand-soft);
      }

      .section-link.is-active {
        color: var(--doc-brand-1);
        background-color: var(--doc-brand-soft);
        font-weight: 600;
      }

      .subsection-link {
        display: block;
        width: 100%;
        position: relative;
        font-size: 0.8125rem;
        line-height: 1.4;
        color: var(--doc-text-2);
        text-decoration: none;
        padding: 0.3rem 0.5rem;
        border-radius: var(--doc-radius-sm);
        transition:
          color 0.12s ease,
          background-color 0.12s ease;
      }

      .subsection-link::before {
        content: "";
        pointer-events: none;
        position: absolute;
        left: -0.75rem;
        top: 0.4rem;
        bottom: 0.4rem;
        width: 1.5px;
        border-radius: 1px;
        background-color: transparent;
        transition: background-color 0.12s ease;
      }

      .subsection-link:hover {
        color: var(--doc-text-1);
        background-color: color-mix(in srgb, var(--doc-text-1) 6%, transparent);
      }

      .subsection-link.is-active {
        font-weight: 600;
        color: var(--doc-brand-1);
        background-color: var(--doc-brand-soft);
      }

      .subsection-link.is-active::before {
        background-color: var(--doc-brand-1);
      }
    </style>
  </template>
}
