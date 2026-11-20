import type { TOC } from '@ember/component/template-only';

export const H2: TOC<{ Blocks: { default: [] } }> = <template>
  <h2 style="font-size: 1.875rem; line-height: 2.25rem;">{{yield}}</h2>
</template>;
