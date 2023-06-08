// NOTE: https://github.com/emberjs/ember.js/issues/20165
import { hash } from '@ember/helper';

import { uniqueId } from '../utils';
import { Label } from './-private/typed-elements';

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

export interface Signature {
  Element: HTMLInputElement;
  Args: {
    /**
     * The initial checked value of the Switch.
     * This value is reactive, so if the value that
     * `@checked` is set to updates, the state of the Switch will also update.
     */
    checked?: boolean;
    /**
     * Callback when the Switch state is toggled
     */
    onChange?: (checked: boolean, event: Event) => void;
  };
  Blocks: {
    default?: [
      {
        /**
         * The Switch Element.
         * It has a pre-wired `id` so that the relevan Label is
         * appropriately associated via the `for` property of the Label.
         *
         * ```gjs
         * import { Switch } from 'ember-primitives';
         *
         * <template>
         *   <Switch as |s|>
         *     <s.Control />
         *   </Switch>
         * </template>
         * ```
         */
        Control: WithBoundArgs<typeof Checkbox, 'checked' | 'id'>;
        /**
         * The Switch element requires a label, and this label already has
         * the association to the Control by setting the `for` attribute to the `id` of the Control
         *
         * ```gjs
         * import { Switch } from 'ember-primitives';
         *
         * <template>
         *   <Switch as |s|>
         *     <s.Label />
         *   </Switch>
         * </template>
         * ```
         */
        Label: WithBoundArgs<typeof Label, 'for'>;
      }
    ];
  };
}

const Checkbox: TOC<{
  Element: HTMLInputElement;
  Args: { id: string; checked?: boolean };
}> = <template>
  <input id={{@id}} type='checkbox' role='switch' checked={{@checked}} ...attributes />
</template>;

export const Switch: TOC<Signature> = <template>
  <div ...attributes data-prim-switch>
    {{! @glint-nocheck }}
    {{#let (uniqueId) as |id|}}
      {{yield
        (hash Control=(component Checkbox checked=@checked id=id) Label=(component Label for=id))
      }}
    {{/let}}
  </div>
</template>;

export default Switch;
