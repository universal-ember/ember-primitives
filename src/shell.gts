import 'ember-mobile-menu/themes/android';
import './site-css/site.css';
import './site-css/components.css';
import './site-css/featured-demo.css';
import './site-css/shiki.css';
import './site-css/shell.css';
import './site-css/prose.css';

import { colorScheme } from 'ember-primitives/color-scheme';

import type { TOC } from '@ember/component/template-only';

export const Shell: TOC<{ Blocks: { default: [] } }> = <template>
  {{(syncBodyClass)}}
  {{yield}}
</template>;

function syncBodyClass() {
  if (colorScheme.isDark) {
    document.body.classList.add('dark');
    document.body.classList.add('theme-dark');
    document.body.classList.remove('theme-light');
    document.body.classList.remove('light');
  } else {
    document.body.classList.remove('theme-dark');
    document.body.classList.remove('dark');
    document.body.classList.add('theme-light');
    document.body.classList.add('light');
  }
}
