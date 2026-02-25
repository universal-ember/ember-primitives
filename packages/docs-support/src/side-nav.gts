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
        background-color: white;
      }

      .side-nav ul {
        list-style: none;
        margin: 0;
        padding: 0;
      }

      .side-nav h2 {
        font-size: 1rem;
        font-weight: 500;
        font-family: var(--font-display, "Helvetica", "Arial", sans-serif);
        color: #0f172a;
        margin: 0;
      }

      :is(html[style*="color-scheme: dark"]) .side-nav h2 {
        color: white;
      }

      :is(html[style*="color-scheme: dark"]) .side-nav {
        background-color: #02020e;
      }

      .section-link {
        font-weight: 500;
        font-family: var(--font-display, "Helvetica", "Arial", sans-serif);
        color: #0f172a;
      }

      :is(html[style*="color-scheme: dark"]) .section-link {
        color: white;
      }

      .section-link:hover {
        color: #475569;
      }

      :is(html[style*="color-scheme: dark"]) .section-link:hover {
        color: #cbd5e1;
      }

      .section-link.is-active {
        color: #0ea5e9;
      }

      .subsection-link {
        display: block;
        width: 100%;
        position: relative;
        color: #64748b;
      }

      .subsection-link::before {
        content: "";
        pointer-events: none;
        position: absolute;
        left: -0.25rem;
        top: 50%;
        height: 0.375rem;
        width: 0.375rem;
        transform: translateY(-50%);
        border-radius: 9999px;
        background-color: #cbd5e1;
        display: none;
      }

      .subsection-link:hover {
        color: #475569;
      }

      .subsection-link:hover::before {
        display: block;
      }

      :is(html[style*="color-scheme: dark"]) .subsection-link {
        color: #94a3b8;
      }

      :is(html[style*="color-scheme: dark"]) .subsection-link::before {
        background-color: #334155;
      }

      :is(html[style*="color-scheme: dark"]) .subsection-link:hover {
        color: #cbd5e1;
      }

      .subsection-link.is-active {
        font-weight: 600;
        color: #0ea5e9;
      }
    </style>
  </template>
}
