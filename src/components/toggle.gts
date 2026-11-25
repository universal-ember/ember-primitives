// import Component from '@glimmer/component';
import { fn } from "@ember/helper";
import { on } from "@ember/modifier";

import { cell } from "ember-resources";

import { toggleWithFallback } from "./-private/utils.ts";

import type { TOC } from "@ember/component/template-only";

export interface Signature<Value = any> {
  Element: HTMLButtonElement;
  Args: {
    /**
     * The pressed-state of the toggle.
     *
     * Can be used to control the state of the component.
     */
    pressed?: boolean;
    /**
     * Callback for when the toggle's state is changed.
     *
     * Can be used to control the state of the component.
     *
     * if a `@value` is passed to this `<Toggle>`, that @value will
     * be passed to the `@onChange` handler.
     *
     * This can be useful when using the same function for the `@onChange`
     * handler with multiple `<Toggle>` components.
     */
    onChange?: (value: Value | undefined, pressed: boolean) => void;

    /**
     * When used in a group of Toggles, this option will be helpful to
     * know which toggle was pressed if you're using the same @onChange
     * handler for multiple toggles.
     */
    value?: Value;

    /**
     * When controlling state in a wrapping component, this function can be used in conjunction with `@value` to determine if this `<Toggle>` should appear pressed.
     */
    isPressed?: (value?: Value) => boolean;
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

function isPressed(
  pressed?: boolean,
  value?: unknown,
  isPressed?: (value?: unknown) => boolean,
): boolean {
  if (!value) return Boolean(pressed);
  if (!isPressed) return Boolean(pressed);

  return isPressed(value);
}

export const Toggle: TOC<Signature> = <template>
  {{#let (cell (isPressed @pressed @value @isPressed)) as |pressed|}}
    <button
      type="button"
      aria-pressed="{{pressed.current}}"
      {{on "click" (fn toggleWithFallback pressed.toggle @onChange @value)}}
      ...attributes
    >
      {{yield pressed.current}}
    </button>
  {{/let}}
</template>;

export default Toggle;
