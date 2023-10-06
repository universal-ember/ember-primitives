import Component from '@glimmer/component';

export interface AccordionItemSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [];
  };
  Args: {
    value: string;
    selectedValue?: string | string[];
    toggleItem: (value: string) => void;
  }
}

export default class AccordionItem extends Component<AccordionItemSignature> {
  <template>
    <div ...attributes>
      {{yield}}
    </div>
  </template>

  get isExpanded(): boolean {
    if (Array.isArray(this.args.selectedValue)) {
      return this.args.selectedValue.includes(this.args.value);
    }

    return this.args.selectedValue === this.args.value;
  }
}
