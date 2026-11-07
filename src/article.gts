import type { TOC } from '@ember/component/template-only';

export const Article: TOC<{ Element: HTMLElement; Blocks: { default: [] } }> = <template>
  <article class="prose" ...attributes>
    {{yield}}
  </article>
</template>;
