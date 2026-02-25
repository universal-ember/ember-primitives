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
    @keyframes shimmer {
      0% {
        background-position: -1000px 0;
      }
      100% {
        background-position: 1000px 0;
      }
    }

    .loading-page {
      position: fixed;
      top: 0rem;
      padding: 0.5rem 1rem;
      background: linear-gradient(
        90deg,
        rgba(40, 40, 50, 0.9),
        rgba(60, 60, 70, 0.9),
        rgba(40, 40, 50, 0.9)
      );
      background-size: 1000px 100%;
      animation: shimmer 2s infinite;
      filter: drop-shadow(0 0.5rem 0.5rem rgba(0, 0, 0, 0.8));
      color: white;
      right: 0;
      width: 100%;
      border-bottom-left-radius: 0.25rem;
      border-bottom-right-radius: 0.25rem;
    }

    @media (prefers-reduced-motion: reduce) {
      .loading-page {
        animation: shimmer 10s infinite;
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
      transition: all 0.5s;
      box-shadow: 0 4px 6px -1px rgb(15 23 42 / 0.05);
      background-color: rgb(255 255 255 / 0.95);
    }

    :is(html[style*="color-scheme: dark"]) .page-header {
      box-shadow: none;
      background-color: rgb(2 2 14 / 0.95);
    }

    :is(html[style*="color-scheme: dark"]) .page-header.is-scrolled {
      backdrop-filter: blur(12px);
    }

    @supports (backdrop-filter: blur(0)) {
      :is(html[style*="color-scheme: dark"]) .page-header.is-scrolled {
        background-color: rgb(2 2 14 / 0.75);
      }
    }

    .page-header__inner {
      display: flex;
      flex: none;
      flex-wrap: wrap;
      align-items: center;
      justify-content: space-between;
      padding-top: 1rem;
      padding-bottom: 1rem;
    }

    .page-header__toggle {
      display: flex;
      margin-right: 1.5rem;
    }

    @media (min-width: 1024px) {
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
    }

    .page-content {
      flex: 1 1 auto;
      max-width: 42rem;
      min-width: 0;
      padding-top: 1rem;
      padding-bottom: 1rem;
    }

    @media (min-width: 1024px) {
      .page-content {
        max-width: none;
      }
    }

    .edit-link-container {
      display: flex;
      justify-content: flex-end;
      padding-top: 1.5rem;
      margin-top: 3rem;
      border-top: 1px solid #e2e8f0;
    }

    :is(html[style*="color-scheme: dark"]) .edit-link-container {
      border-color: #1e293b;
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
      justify-content: flex-end;
      gap: 1.5rem;
      flex-basis: 0;
    }

    @media (min-width: 640px) {
      .top-right {
        gap: 2rem;
      }
    }

    @media (min-width: 768px) {
      .top-right {
        flex-grow: 1;
      }
    }
  </style>
</template>;
