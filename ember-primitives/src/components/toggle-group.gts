import Component from '@glimmer/component';
import { hash } from '@ember/helper';

import { Types } from 'tabster';
// The consumer will need to provide types for tracked-toolbox.
// Or.. better yet, we PR to trakcked-toolbox to provide them
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { localCopy } from 'tracked-toolbox';

import { Toggle } from './toggle.gts';

import type { ComponentLike } from '@glint/template';

const TABSTER_CONFIG = JSON.stringify({
  mover: {
    direction: Types.MoverDirections.Both,
    cyclic: true,
  },
});

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export interface ItemSignature<Value = any> {
  /**
   * The button element will have aria-pressed="true" on it when the button is in the pressed state.
   */
  Element: HTMLButtonElement;
  Args: {
    /**
     * When used in a group of Toggles, this option will be helpful to
     * know which toggle was pressed if you're using the same @onChange
     * handler for multiple toggles.
     */
    value?: Value;
  };
  Blocks: {
    default: [
      /**
       * the current pressed state of the toggle button
       *
       * Useful when using the toggle button as an uncontrolled component
       */
      pressed: boolean,
    ];
  };
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export type Item<Value = any> = ComponentLike<ItemSignature<Value>>;

// eslint-disable-next-line @typescript-eslint/no-explicit-any
export class ToggleGroup<Value = any> extends Component<{
  Element: HTMLDivElement;
  Args: {
    /**
     * Optionally set the initial toggle state
     */
    value?: Value;
    /**
     * Callback for when the toggle-group's state is changed.
     *
     * Can be used to control the state of the component.
     *
     *
     * When none of the toggles are selected, undefined will be passed.
     */
    onChange: (value: Value | undefined) => void;
  };
  Blocks: {
    default: [
      {
        Item: Item;
      },
    ];
  };
}> {
  @localCopy('args.value') activePressed?: Value;

  handleToggle = (value: Value) => {
    if (this.activePressed === value) {
      this.activePressed = undefined;

      return;
    }

    this.activePressed = value;

    this.args.onChange?.(this.activePressed);
  };

  isPressed = (value: Value | undefined) => value === this.activePressed;

  <template>
    <div data-tabster={{TABSTER_CONFIG}} ...attributes>
      {{yield (hash Item=(component Toggle onChange=this.handleToggle isPressed=this.isPressed))}}
    </div>
  </template>
}
