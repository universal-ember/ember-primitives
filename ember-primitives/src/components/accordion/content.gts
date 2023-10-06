import Component from '@glimmer/component';


export interface AccordionContentSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    isExpanded: boolean;
    value: string;
  }
}

export class AccordionContent extends Component<AccordionContentSignature> {
  <template>
    <div role="region" id={{@value}} ...attributes>
      {{yield}}
    </div>
  </template>
}

export default AccordionContent;
