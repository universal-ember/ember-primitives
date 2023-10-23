import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';

// temp
//  https://github.com/tracked-tools/tracked-toolbox/issues/38
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { localCopy } from 'tracked-toolbox';

import AccordionItem from './accordion/item';

import type { WithBoundArgs } from '@glint/template';

type AccordionSingleArgs = {
  /**
   * The type of accordion. If `single`, only one item can be selected at a time. If `multiple`, multiple items can be selected at a time.
   */
  type: 'single';
  /**
   * Whether the accordion is disabled. When `true`, all items cannot be expanded or collapsed.
   */
  disabled?: boolean;
} & (
  | {
      /**
       * The currently selected value. To be used in a controlled fashion in conjunction with `onValueChange`.
       */
      value: string;
      /**
       * A callback that is called when the selected value changes. To be used in a controlled fashion in conjunction with `value`.
       */
      onValueChange: (value: string | undefined) => void;
      /**
       * Not available in a controlled fashion.
       */
      defaultValue?: never;
    }
  | {
      /**
       * Not available in an uncontrolled fashion.
       */
      value?: never;
      /**
       * Not available in an uncontrolled fashion.
       */
      onValueChange?: never;
      /**
       * The default value of the accordion. To be used in an uncontrolled fashion.
       */
      defaultValue?: string;
    }
);

type AccordionMultipleArgs = {
  /**
   * The type of accordion. If `single`, only one item can be selected at a time. If `multiple`, multiple items can be selected at a time.
   */
  type: 'multiple';
  /**
   * Whether the accordion is disabled. When `true`, all items cannot be expanded or collapsed.
   */
  disabled?: boolean;
} & (
  | {
      /**
       * The currently selected values. To be used in a controlled fashion in conjunction with `onValueChange`.
       */
      value: string[];
      /**
       * A callback that is called when the selected values change. To be used in a controlled fashion in conjunction with `value`.
       */
      onValueChange: (value?: string[] | undefined) => void;
      /**
       * Not available in a controlled fashion.
       */
      defaultValue?: never;
    }
  | {
      /**
       * Not available in an uncontrolled fashion.
       */
      value?: never;
      /**
       * Not available in an uncontrolled fashion.
       */
      onValueChange?: never;
      /**
       * The default values of the accordion. To be used in an uncontrolled fashion.
       */
      defaultValue?: string[];
    }
);

export class Accordion extends Component<{
  Element: HTMLDivElement;
  Args: AccordionSingleArgs | AccordionMultipleArgs;
  Blocks: {
    default: [
      {
        /**
         * The AccordionItem component.
         */
        Item: WithBoundArgs<typeof AccordionItem, 'selectedValue' | 'toggleItem' | 'disabled'>;
      },
    ];
  };
}> {
  <template>
    <div data-disabled={{@disabled}} ...attributes>
      {{yield
        (hash
          Item=(component
            AccordionItem
            selectedValue=this.selectedValue
            toggleItem=this.toggleItem
            disabled=@disabled
          )
        )
      }}
    </div>
  </template>

  @localCopy('args.defaultValue') declare _internallyManagedValue?: string | string[];

  get selectedValue() {
    return this.args.value ?? this._internallyManagedValue;
  }

  toggleItem = (value: string) => {
    if (this.args.disabled) {
      return;
    }

    if (this.args.type === 'single') {
      this.toggleItemSingle(value);
    } else if (this.args.type === 'multiple') {
      this.toggleItemMultiple(value);
    }
  };

  toggleItemSingle = (value: string) => {
    assert('Cannot call `toggleItemSingle` when `disabled` is true.', !this.args.disabled);
    assert(
      'Cannot call `toggleItemSingle` when `type` is not `single`.',
      this.args.type === 'single',
    );

    const newValue = value === this.selectedValue ? undefined : value;

    if (this.args.onValueChange) {
      this.args.onValueChange(newValue);
    } else {
      this._internallyManagedValue = newValue;
    }
  };

  toggleItemMultiple = (value: string) => {
    assert('Cannot call `toggleItemMultiple` when `disabled` is true.', !this.args.disabled);
    assert(
      'Cannot call `toggleItemMultiple` when `type` is not `multiple`.',
      this.args.type === 'multiple',
    );

    const currentValues = (this.selectedValue as string[] | undefined) ?? [];
    const indexOfValue = currentValues.indexOf(value);
    let newValue: string[];

    if (indexOfValue === -1) {
      newValue = [...currentValues, value];
    } else {
      newValue = [
        ...currentValues.slice(0, indexOfValue),
        ...currentValues.slice(indexOfValue + 1),
      ];
    }

    if (this.args.onValueChange) {
      this.args.onValueChange(newValue);
    } else {
      this._internallyManagedValue = newValue;
    }
  };
}

export default Accordion;

export { type AccordionContentExternalSignature } from './accordion/content';
export { type AccordionHeaderExternalSignature } from './accordion/header';
export { type AccordionItemExternalSignature } from './accordion/item';
export { type AccordionTriggerExternalSignature } from './accordion/trigger';
