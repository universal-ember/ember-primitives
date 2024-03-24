import { cell } from 'ember-resources';
import { on } from '@ember/modifier';
import { fn, hash } from '@ember/helper';
import { toggleWithFallback } from './-private/utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { uniqueId } from '../utils.js';
import { Label } from './-private/typed-elements.js';

const Checkbox = setComponentTemplate(precompileTemplate("\n  {{#let (cell @checked) as |checked|}}\n    <input id={{@id}} type=\"checkbox\" role=\"switch\" checked={{checked.current}} aria-checked={{checked.current}} data-state={{if checked.current \"on\" \"off\"}} {{on \"click\" (fn toggleWithFallback checked.toggle @onChange)}} ...attributes />\n  {{/let}}\n", {
  scope: () => ({
    cell,
    on,
    fn,
    toggleWithFallback
  }),
  strictMode: true
}), templateOnly());
/**
 * @public
 */
const Switch = setComponentTemplate(precompileTemplate("\n  <div ...attributes data-prim-switch>\n    {{!-- @glint-nocheck --}}\n    {{#let (uniqueId) as |id|}}\n      {{yield (hash Control=(component Checkbox checked=@checked id=id onChange=@onChange) Label=(component Label for=id))}}\n    {{/let}}\n  </div>\n", {
  scope: () => ({
    uniqueId,
    hash,
    Checkbox,
    Label
  }),
  strictMode: true
}), templateOnly());

export { Switch, Switch as default };
//# sourceMappingURL=switch.js.map
