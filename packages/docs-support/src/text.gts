import type { TOC } from '@ember/component/template-only';

export const Text: TOC<{ Blocks: { default: [] } }> = <template>
  <span class="dark:text-white text:slate-900">{{yield}}</span>
</template>;
