import type { TOC } from '@ember/component/template-only';

interface Signature {
  Element: HTMLInputElement;
  Args: {
    checked?: boolean;
    disabled?: boolean;
    onChange?: (checked: boolean, event: Event) => void;
  };
  Blocks: {
    default?: [];
  };
}

const Checkbox: TOC<{ Element: HTMLInputElement; Args: { checked?: boolean } }> = <template>
  <input type='checkbox' role="switch" checked={{@checked}} ...attributes />
</template>;

export const Switch: TOC<Signature> = <template>
  {{#if (has-block)}}
    <label>
      <span>{{yield}}</span>
      <Checkbox ...attributes />
    </label>
  {{else}}
    <span>{{yield}}</span>
    <Checkbox ...attributes />
  {{/if}}
</template>

export default Switch;
