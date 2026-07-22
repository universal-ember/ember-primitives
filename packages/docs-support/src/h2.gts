import type { TOC } from '@ember/component/template-only';

export const H2: TOC<{ Blocks: { default: [] } }> = <template>
  <h2 class="docs-h2">{{yield}}</h2>

  <style scoped>
    .docs-h2 {
      font-size: 1.5rem;
      line-height: 1.3;
      font-weight: 600;
      letter-spacing: -0.01em;
      color: var(--doc-text-1);
      font-family: var(--font-sans);
    }
  </style>
</template>;
