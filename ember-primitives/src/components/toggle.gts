import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import { cell } from 'ember-resources';

import { toggleWithFallback } from './-private/utils';

import type { TOC } from '@ember/component/template-only';

export interface Signature {
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
     */
    onChange?: () => void;
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

export const Toggle: TOC<Signature> = <template>
  {{#let (cell @pressed) as |pressed|}}
    <button
      type='button'
      aria-pressed='{{pressed.current}}'
      {{on 'click' (fn toggleWithFallback pressed.toggle @onChange)}}
      ...attributes
    >
      {{yield pressed.current}}
    </button>
  {{/let}}
</template>;

export default Toggle;
