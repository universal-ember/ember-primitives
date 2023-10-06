import type { TOC } from '@ember/component/template-only';

export const AccordionContent: TOC<{
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    isExpanded: boolean;
    value: string;
  }
}> = <template>
  <div role="region" id={{@value}} aria-hidden={{unless @isExpanded "true"}} ...attributes>
    {{yield}}
  </div>
</template>

export default AccordionContent;
