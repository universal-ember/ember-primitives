import type { TOC } from '@ember/component/template-only';

export const Text: TOC<{ Blocks: { default: [] } }> = <template>
  <span class="adaptive-text">{{yield}}</span>

  <style scoped>
    .adaptive-text {
      color: #0f172a;
    }
    :is(html[style*="color-scheme: dark"]) .adaptive-text {
      color: white;
    }
  </style>
</template>;
