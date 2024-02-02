import type { TOC } from '@ember/component/template-only';

export const Div: TOC<{ Element: HTMLDivElement; Blocks: { default: [] } }> = <template>
  <div ...attributes>{{yield}}</div>
</template>;

export const Label: TOC<{
  Element: HTMLLabelElement;
  Args: { for: string };
  Blocks: { default: [] };
}> = <template>
  <label for={{@for}} ...attributes>{{yield}}</label>
</template>;
