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
  <div class="index-page">
    <Hero class="index-hero gradient-background">
      <header class="index-hero__header">
        {{yield to="header"}}
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
