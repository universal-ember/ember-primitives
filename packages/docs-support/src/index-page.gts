import type { TOC } from '@ember/component/template-only';
import { Hero } from 'ember-primitives/layout/hero';

import './index-page.css';

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
  <Hero class="shadow-xl shadow-slate-900/5 gradient-background">
    <header class="absolute md:sticky right-0 bottom-0 md:top-0 z-50 p-4 flex items-center">
      {{yield to="header"}}
    </header>

    <div class="h-full flex flex-col gap-8 justify-center items-center">
      <div style="width: 66%; margin: 0 auto; transform: translateY(-20%);" class="grid gap-4">
        <h1 style="filter: drop-shadow(3px 5px 0px rgba(0, 0, 0, 0.4));">
          {{yield to="logo"}}
        </h1>
        <p class="italic text-white w-full md:w-1/2 mx-auto">
          {{yield to="tagline"}}
        </p>
      </div>
      {{yield to="callToAction"}}
    </div>
  </Hero>

  {{yield to="content"}}

  <hr />
  <footer style="padding: 3rem; width: 66%;" class="mx-auto gap-12 flex-wrap flex justify-between">
    {{yield to="footer"}}
  </footer>
</template>;
