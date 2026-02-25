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
      <div style="width: 66%; margin: 0 auto; transform: translateY(-20%);" class="index-hero__grid">
        <h1 style="filter: drop-shadow(3px 5px 0px rgba(0, 0, 0, 0.4));">
          {{yield to="logo"}}
        </h1>
        <p class="index-hero__tagline">
          {{yield to="tagline"}}
        </p>
      </div>
      {{yield to="callToAction"}}
    </div>
  </Hero>

  {{yield to="content"}}

  <hr />
  <footer style="padding: 3rem; width: 66%;" class="index-footer">
    {{yield to="footer"}}
  </footer>

  <style scoped>
    .index-hero {
      box-shadow: 0 10px 15px -3px rgb(15 23 42 / 0.05);
    }

    .index-hero__header {
      position: absolute;
      right: 0;
      bottom: 0;
      z-index: 50;
      padding: 1rem;
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
    }

    .index-hero__grid {
      display: grid;
      gap: 1rem;
    }

    .index-hero__tagline {
      font-style: italic;
      color: white;
      width: 100%;
      margin-left: auto;
      margin-right: auto;
    }

    @media (min-width: 768px) {
      .index-hero__tagline {
        width: 50%;
      }
    }

    .index-footer {
      margin-left: auto;
      margin-right: auto;
      gap: 3rem;
      flex-wrap: wrap;
      display: flex;
      justify-content: space-between;
    }
  </style>
</template>;
