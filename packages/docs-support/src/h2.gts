import type { TOC } from '@ember/component/template-only';

export const H2: TOC<{ Blocks: { default: [] } }> = <template>
  <h2 class="text-3xl">{{yield}}</h2>
</template>;
