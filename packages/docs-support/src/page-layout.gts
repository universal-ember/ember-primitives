import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { Page } from 'kolay/components';

import { Article } from './article.gts';
import { Link } from './links.gts';
import { ResponsiveMenuLayout } from './menu-layout.gts';
import { ThemeToggle } from './theme-toggle.gts';

import type { TOC } from '@ember/component/template-only';

// Removes the App Shell / welcome UI
// before initial rending and chunk loading finishes
function removeLoader() {
  document.querySelector('#initial-loader')?.remove();
}

function resetScroll(..._args: unknown[]) {
  document.querySelector('html')?.scrollTo(0, 0);
}

const isScrolled = cell(false);

const onWindowScroll = modifier(() => {
  function onScroll() {
    isScrolled.current = window.scrollY > 0;
  }

  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });

  return () => {
    window.removeEventListener('scroll', onScroll);
  };
});

export const PageLoader: TOC<{
  Blocks: {
    defaultl: [];
  };
}> = <template>
  <div class="loading-page" role="status">
    {{yield}}
  </div>

  <style>
    .loading-page {
      position: fixed;
      top: 0;
      left: 0;
      right: 0;
      z-index: 60;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 0.65rem;
      min-height: 2.25rem;
      padding: 0.55rem 1rem;
      background: color-mix(in srgb, var(--doc-bg-elv) 92%, transparent);
      border-bottom: 1px solid var(--doc-divider);
      backdrop-filter: blur(8px);
      color: var(--doc-text-2);
      font-family: var(--font-sans);
      font-size: 0.8125rem;
      font-weight: 500;
      letter-spacing: -0.01em;
    }

    .loading-page::before {
      content: "";
      width: 0.55rem;
      height: 0.55rem;
      border-radius: 999px;
      background: var(--doc-brand-1);
      opacity: 0.85;
      animation: docs-pulse 1.1s ease-in-out infinite;
    }

    @keyframes docs-pulse {
      0%,
      100% {
        opacity: 0.35;
        transform: scale(0.9);
      }
      50% {
        opacity: 1;
        transform: scale(1);
      }
    }

    @media (prefers-reduced-motion: reduce) {
      .loading-page::before {
        animation: none;
        opacity: 0.7;
      }
    }
  </style>
</template>;

export function hasReason(error: unknown): error is { reason: string; original: Error } {
  return (
    typeof error === 'object' &&
    error !== null &&
    'reason' in error &&
    typeof error.reason === 'string'
  );
}

export const PageError: TOC<{
  Args: {
    error: string | { reason: string; original: Error };
  };
}> = <template>
  <div class="error" data-page-error role="alert">
    {{#if (hasReason @error)}}
      {{@error.reason}}
      <details>
        <summary>Original error</summary>
        <pre>{{@error.original.stack}}</pre>
      </details>
    {{else}}
      {{@error}}
    {{/if}}
  </div>
</template>;

export const PageLayout: TOC<{
  Blocks: {
    logoLink: [];
    topRight: [];
    editLink: [typeof EditLink];
    error: [error: string | { reason: string; original: Error }];
  };
}> = <template>
  <ResponsiveMenuLayout>
    <:header as |Toggle|>
      <header class="page-header {{if isScrolled.current 'is-scrolled'}}" {{onWindowScroll}}>
        <div class="outer-content page-header__inner">
          <div class="page-header__toggle">
            <Toggle />
          </div>
          <div class="page-header__logo">
            <a href="/" aria-label="Home page">
              {{yield to="logoLink"}}
            </a>
          </div>
          <TopRight>
            {{yield to="topRight"}}
          </TopRight>
        </div>
      </header>
    </:header>
    <:content>
      <section data-main-scroll-container class="page-content">
        <Article>
          <Page>
            <:pending>
              <PageLoader>
                Loading, Compiling, etc
              </PageLoader>
            </:pending>

            <:error as |error|>
              <section>
                {{yield error to="error"}}
              </section>
            </:error>

            <:success as |prose|>
              <prose />
              {{(removeLoader)}}
              {{resetScroll prose}}
            </:success>
          </Page>
        </Article>

        {{#if (has-block "editLink")}}

          <div class="edit-link-container">

            {{yield EditLink to="editLink"}}
          </div>
        {{/if}}
      </section>
    </:content>

  </ResponsiveMenuLayout>

  <style scoped>
    .page-header {
      position: sticky;
      top: 0;
      z-index: 50;
      min-height: var(--doc-nav-height);
      transition:
        background-color 0.2s ease,
        border-color 0.2s ease;
      box-shadow: none;
      background-color: color-mix(in srgb, var(--doc-bg) 88%, transparent);
      border-bottom: 1px solid var(--doc-divider);
      backdrop-filter: blur(10px);
    }

    .page-header.is-scrolled {
      background-color: color-mix(in srgb, var(--doc-bg-elv) 86%, transparent);
    }

    .page-header__inner {
      display: flex;
      flex: none;
      flex-wrap: nowrap;
      align-items: center;
      justify-content: space-between;
      min-height: var(--doc-nav-height);
      padding-top: 0.5rem;
      padding-bottom: 0.5rem;
      gap: 1rem;
    }

    .page-header__toggle {
      display: flex;
      margin-right: 0.25rem;
      flex-shrink: 0;
    }

    @media (min-width: 960px) {
      .page-header__toggle {
        display: none;
      }
    }

    .page-header__logo {
      position: relative;
      display: flex;
      align-items: center;
      flex-grow: 1;
      flex-basis: 0;
      min-width: 0;
    }

    .page-header__logo a {
      display: inline-flex;
      align-items: center;
      text-decoration: none;
    }

    .page-content {
      flex: 1 1 auto;
      width: 100%;
      max-width: var(--doc-content-max);
      min-width: 0;
      padding: var(--doc-content-pad-y) var(--doc-content-pad-x) 6rem;
    }

    .edit-link-container {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      padding-top: 1.35rem;
      margin-top: 3.25rem;
      border-top: 1px solid var(--doc-divider);
    }

    .edit-link-container .styled-link,
    .edit-link-container a {
      font-size: 0.8125rem;
      font-weight: 500;
      color: var(--doc-text-3);
      text-decoration: none;
      box-shadow: none;
      transition: color 0.12s ease;
    }

    .edit-link-container .styled-link:hover,
    .edit-link-container a:hover {
      color: var(--doc-brand-1);
    }
  </style>
</template>;

const EditLink: TOC<{ Args: { href: string }; Blocks: { default: [] } }> = <template>
  <Link class="edit-page" style="display: flex;" href={{@href}}>
    {{yield}}
  </Link>
</template>;

export const TopRight: TOC<{ Blocks: { default: [] } }> = <template>
  <div class="top-right">
    <ThemeToggle />
    {{yield}}
  </div>

  <style scoped>
    .top-right {
      position: relative;
      display: flex;
      align-items: center;
      justify-content: flex-end;
      gap: 0.875rem;
      flex-shrink: 0;
    }

    @media (min-width: 640px) {
      .top-right {
        gap: 1rem;
      }
    }
  </style>
</template>;
