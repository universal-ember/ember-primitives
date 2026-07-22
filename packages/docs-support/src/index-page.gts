import './index-page.css';

import { Hero } from 'ember-primitives/layout/hero';

import type { TOC } from '@ember/component/template-only';

export const IndexPage: TOC<{
  Blocks: {
    logo: [];
    header: [];
    tagline: [];
    callToAction: [];
    content: [];
    footer: [];
  };
}> = <template>
  <Hero class="index-hero gradient-background">
    <header class="index-hero__header">
      {{yield to="header"}}
    </header>

    <div class="index-hero__body">
      <div class="index-hero__grid">
        <h1 class="index-hero__logo">
          {{yield to="logo"}}
        </h1>
        <p class="index-hero__tagline">
          {{yield to="tagline"}}
        </p>
      </div>
      <div class="index-hero__cta">
        {{yield to="callToAction"}}
      </div>
    </div>
  </Hero>

  {{yield to="content"}}

  <hr class="index-divider" />
  <footer class="index-footer">
    {{yield to="footer"}}
  </footer>

  <style scoped>
    .index-hero {
      border-bottom: 1px solid var(--doc-border);
    }

    .index-hero__header {
      position: absolute;
      right: 0;
      top: 0;
      z-index: 50;
      padding: 1rem 1.25rem;
      display: flex;
      align-items: center;
    }

    @media (min-width: 768px) {
      .index-hero__header {
        position: sticky;
        top: 0;
      }
    }

    .index-hero__body {
      height: 100%;
      display: flex;
      flex-direction: column;
      gap: 2rem;
      justify-content: center;
      align-items: center;
      padding: 3rem 1.5rem 4rem;
    }

    .index-hero__grid {
      display: grid;
      gap: 1.25rem;
      width: min(720px, 92%);
      margin: 0 auto;
      text-align: center;
    }

    .index-hero__logo {
      margin: 0;
      filter: none;
    }

    .index-hero__tagline {
      font-style: normal;
      color: var(--doc-text-2);
      width: 100%;
      margin: 0 auto;
      font-size: 1.125rem;
      line-height: 1.65;
    }

    .index-hero__tagline strong {
      color: var(--doc-text-1);
      font-weight: 600;
    }

    .index-hero__cta {
      display: flex;
      flex-wrap: wrap;
      gap: 0.75rem;
      justify-content: center;
    }

    .index-divider {
      border: 0;
      border-top: 1px solid var(--doc-divider);
      margin: 3rem auto;
      width: min(66%, 720px);
    }

    .index-footer {
      margin-left: auto;
      margin-right: auto;
      padding: 2rem 1.5rem 3rem;
      width: min(66%, 900px);
      gap: 3rem;
      flex-wrap: wrap;
      display: flex;
      justify-content: space-between;
    }
  </style>
</template>;
