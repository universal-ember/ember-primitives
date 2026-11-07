import { ExternalLink } from 'ember-primitives/components/external-link';

import type { TOC } from '@ember/component/template-only';

export const InternalLink: TOC<{
  Element: HTMLAnchorElement;
  Blocks: { default: [] };
}> = <template>
  <a class="styled-link" href="#" ...attributes>
    {{yield}}
  </a>
</template>;

export const Link: TOC<{
  Element: HTMLAnchorElement;
  Blocks: { default: [] };
}> = <template>
  <ExternalLink class="styled-link" ...attributes>
    {{yield}}
  </ExternalLink>
</template>;
