import type { TOC } from '@ember/component/template-only';

export const AccordionHeader: TOC<{
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    value: string;
    isExpanded: boolean;
    toggleItem: () => void;
  }
}> = <template>
  <div role='heading' aria-level='3' ...attributes>
    {{yield}}
  </div>
</template>

export default AccordionHeader;
