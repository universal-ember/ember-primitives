import { hash, uniqueId } from '@ember/helper';

import { Div as Wrapper, Label } from './typed-elements'

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
      Root: typeof Wrapper,
      Control: WithBoundArgs<typeof Checkbox, 'checked' | 'id'>,
      Label: typeof Label,
    }]
  };
}

const Checkbox: TOC<{ Element: HTMLInputElement; Args: { id: string; checked?: boolean } }> = <template>
  <input id={{@id}}  type='checkbox' role="switch" checked={{@checked}} ...attributes />
</template>;

export const Switch: TOC<Signature> = <template>
  {{! @glint-nocheck }}
  {{#let (uniqueId) as |id|}}
    {{yield
      (hash
       Root=(component Wrapper)
       Control=(component Checkbox checked=@checked id=id)
       Label=(component Label for=id)
     )}}
   {{/let}}
</template>

export default Switch;
