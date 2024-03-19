import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { hash } from '@ember/helper';

import { Types } from 'tabster';
import { TrackedSet } from 'tracked-built-ins';
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

export type Item<Value = any> = ComponentLike<ItemSignature<Value>>;

export interface SingleSignature<Value> {
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
    onChange?: (value: Value | undefined) => void;
  };
  Blocks: {
    default: [
      {
        /**
         * The Toggle Switch
         */
        Item: Item;
      },
    ];
  };
}

export interface MultiSignature<Value = any> {
  Element: HTMLDivElement;
  Args: {
    /**
     * Optionally set the initial toggle state
     */
    value?: Value[] | Set<Value> | Value;
    /**
     * Callback for when the toggle-group's state is changed.
     *
     * Can be used to control the state of the component.
     *
     *
     * When none of the toggles are selected, undefined will be passed.
     */
    onChange?: (value: Set<Value>) => void;
  };
  Blocks: {
    default: [
      {
        /**
         * The Toggle Switch
         */
        Item: Item;
      },
    ];
  };
}

interface PrivateSingleSignature<Value = any> {
  Element: HTMLDivElement;
  Args: {
    type?: 'single';

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
    onChange?: (value: Value | undefined) => void;
  };
  Blocks: {
    default: [
      {
        Item: Item;
      },
    ];
  };
}

interface PrivateMultiSignature<Value = any> {
  Element: HTMLDivElement;
  Args: {
    type: 'multi';
    /**
     * Optionally set the initial toggle state
     */
    value?: Value[] | Set<Value> | Value;
    /**
     * Callback for when the toggle-group's state is changed.
     *
     * Can be used to control the state of the component.
     *
     *
     * When none of the toggles are selected, undefined will be passed.
     */
    onChange?: (value: Set<Value>) => void;
  };
  Blocks: {
    default: [
      {
        Item: Item;
      },
    ];
  };
}

function isMulti(x: 'single' | 'multi' | undefined): x is 'multi' {
  return x === 'multi';
}

export class ToggleGroup<Value = any> extends Component<
  PrivateSingleSignature<Value> | PrivateMultiSignature<Value>
> {
  // See: https://github.com/typed-ember/glint/issues/715
  <template>
    {{#if (isMulti this.args.type)}}
      <MultiToggleGroup
        @value={{this.args.value}}
        @onChange={{this.args.onChange}}
        ...attributes
        as |x|
      >
        {{yield x}}
      </MultiToggleGroup>
    {{else}}
      <SingleToggleGroup
        @value={{this.args.value}}
        @onChange={{this.args.onChange}}
        ...attributes
        as |x|
      >
        {{yield x}}
      </SingleToggleGroup>
    {{/if}}
  </template>
}

class SingleToggleGroup<Value = any> extends Component<SingleSignature<Value>> {
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

class MultiToggleGroup<Value = any> extends Component<MultiSignature<Value>> {
  /**
   * Normalizes @value to a Set
   * and makes sure that even if the input Set is reactive,
   * we don't mistakenly dirty it.
   */
  @cached
  get activePressed(): TrackedSet<Value> {
    let value = this.args.value;

    if (!value) {
      return new TrackedSet();
    }

    if (Array.isArray(value)) {
      return new TrackedSet(value);
    }

    if (value instanceof Set) {
      return new TrackedSet(value);
    }

    return new TrackedSet([value]);
  }

  handleToggle = (value: Value) => {
    if (this.activePressed.has(value)) {
      this.activePressed.delete(value);
    } else {
      this.activePressed.add(value);
    }

    this.args.onChange?.(new Set<Value>(this.activePressed.values()));
  };

  isPressed = (value: Value) => this.activePressed.has(value);

  <template>
    <div data-tabster={{TABSTER_CONFIG}} ...attributes>
      {{yield (hash Item=(component Toggle onChange=this.handleToggle isPressed=this.isPressed))}}
    </div>
  </template>
}
