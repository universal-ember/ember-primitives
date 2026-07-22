import type { TOC } from '@ember/component/template-only';

export const Text: TOC<{ Blocks: { default: [] } }> = <template>
  <span class="adaptive-text">{{yield}}</span>

  <style scoped>
    .adaptive-text {
      color: var(--doc-text-1);
    }
  </style>
</template>;
