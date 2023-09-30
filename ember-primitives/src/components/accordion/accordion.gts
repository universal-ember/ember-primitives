import Component from '@glimmer/component';
import { assert } from '@ember/debug';

// temp
//  https://github.com/tracked-tools/tracked-toolbox/issues/38
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { localCopy } from 'tracked-toolbox';

type AccordionSingleArgs = {
  type: 'single'
} & ({
  value: string;
  onValueChange: (value: string | undefined) => void;
  defaultValue?: never;
} | {
  value?: never;
  onValueChange?: never;
  defaultValue?: string;
});

type AccordionMultipleArgs = {
  type: 'multiple'
} & ({
  value: string[];
  onValueChange: (value?: string[] | undefined) => void;
  defaultValue?: never;
} | {
  value?: never;
  onValueChange?: never;
  defaultValue?: string[];
})

export interface Signature {
  Element: HTMLDivElement;
  Args: AccordionSingleArgs | AccordionMultipleArgs;
  Blocks: {
    default: [];
  };
}

export class Accordion extends Component<Signature> {
  <template>
    <div ...attributes>
      {{yield}}
    </div>
  </template>

  @localCopy('args.defaultValue') declare _internallyManagedValue?: string | string[];

  get selectedValue() {
    return this.args.value ?? this._internallyManagedValue;
  }

  toggleItem = (value: string) => {
    if (this.args.type === 'single') {
      this.toggleItemSingle(value);
    } else if (this.args.type === 'multiple') {
      this.toggleItemMultiple(value);
    }
  }

  toggleItemSingle = (value: string) => {
    assert('Cannot call `toggleItemSingle` when `type` is not `single`.', this.args.type === 'single');

    const newValue = value === this.selectedValue ? undefined : value;

    if (this.args.onValueChange) {
      this.args.onValueChange(newValue);
    } else {
      this._internallyManagedValue = newValue;
    }
  }

  toggleItemMultiple = (value: string) => {
    assert('Cannot call `toggleItemMultiple` when `type` is not `multiple`.', this.args.type === 'multiple');

    const currentValues = this.selectedValue as string[] | undefined ?? [];
    const indexOfValue = currentValues.indexOf(value);
    let newValue: string[];

    if (indexOfValue === -1) {
      newValue = [...currentValues, value];
    } else {
      newValue = [
        ...currentValues.slice(0, indexOfValue),
        ...currentValues.slice(indexOfValue + 1)
      ];
    }

    if (this.args.onValueChange) {
      this.args.onValueChange(newValue);
    } else {
      this._internallyManagedValue = newValue;
    }
  }
}

export default Accordion;
