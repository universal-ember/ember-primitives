import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { uniqueId } from '../utils.js';
import { Label } from './-private/typed-elements.js';
import { toggleWithFallback } from './-private/utils.js';

const Checkbox = setComponentTemplate(precompileTemplate(`
  {{#let (cell @checked) as |checked|}}
    <input
      id={{@id}}
      type='checkbox'
      role='switch'
      checked={{checked.current}}
      data-state={{if checked.current 'on' 'off'}}
      {{on 'click' (fn toggleWithFallback checked.toggle @onChange)}}
      ...attributes
    />
  {{/let}}
`, {
  strictMode: true,
  scope: () => ({
    cell,
    on,
    fn,
    toggleWithFallback
  })
}), templateOnly("switch", "Checkbox"));

/**
 * @public
 */
const Switch = setComponentTemplate(precompileTemplate(`
  <div ...attributes data-prim-switch>
    {{! @glint-nocheck }}
    {{#let (uniqueId) as |id|}}
      {{yield
        (hash
          Control=(component Checkbox checked=@checked id=id onChange=@onChange)
          Label=(component Label for=id)
        )
      }}
    {{/let}}
  </div>
`, {
  strictMode: true,
  scope: () => ({
    uniqueId,
    hash,
    Checkbox,
    Label
  })
}), templateOnly("switch", "Switch"));

export { Switch, Switch as default };
//# sourceMappingURL=switch.js.map
