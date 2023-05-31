// NOTE: https://github.com/emberjs/ember.js/issues/20165
import { hash } from '@ember/helper';

import { uniqueId } from '../utils';
import { Label } from './typed-elements'

import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';

interface Signature {
  Element: HTMLInputElement;
  Args: {
    checked?: boolean;
    disabled?: boolean;
    onChange?: (checked: boolean, event: Event) => void;
  };
  Blocks: {
    default?: [{
      Control: WithBoundArgs<typeof Checkbox, 'checked' | 'id'>,
      Label: typeof Label,
    }]
  };
}

const Checkbox: TOC<{
  Element: HTMLInputElement;
  Args: { id: string; checked?: boolean }
}> = <template>
  <input
    id={{@id}}
    type='checkbox'
    role="switch"
    checked={{@checked}}
    ...attributes
  />
</template>;

export const Switch: TOC<Signature> = <template>
  <div ...attributes data-prim-switch>
  {{! @glint-nocheck }}
  {{#let (uniqueId) as |id|}}
    {{yield
      (hash
       Control=(component Checkbox checked=@checked id=id)
       Label=(component Label for=id)
     )}}
   {{/let}}
   </div>
</template>

export default Switch;
