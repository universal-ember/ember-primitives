import './index-page.css';

import { Hero } from 'ember-primitives/layout/hero';

import type { TOC } from '@ember/component/template-only';

export const IndexPage: TOC<{
  Blocks: {
    /** Rendered behind the hero content, for example a canvas. */
    background: [];
    logo: [];
    header: [];
    tagline: [];
    callToAction: [];
    content: [];
    footer: [];
  };
}> = <template>
  <div class="index-page">
    <Hero class="index-hero gradient-background">
      {{yield to="background"}}
      <header class="index-hero__header">
        <div class="index-hero__header-inner">
          {{yield to="header"}}
        </div>
      </header>

      <div class="index-hero__body">
        <div class="index-hero__grid">
          <h1 class="index-hero__logo">
            {{yield to="logo"}}
          </h1>
          <div class="index-hero__copy">
            {{yield to="tagline"}}
          </div>
        </div>
        <div class="index-hero__cta">
          {{yield to="callToAction"}}
        </div>
      </div>
    </Hero>

    {{yield to="content"}}

    <footer class="index-footer">
      {{yield to="footer"}}
    </footer>
  </div>
</template>;
