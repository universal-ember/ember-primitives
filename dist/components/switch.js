import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { uniqueId } from '../utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

setComponentTemplate(precompileTemplate("<div ...attributes>{{yield}}</div>", {
  strictMode: true
}), templateOnly());
const Label = setComponentTemplate(precompileTemplate("<label for={{@for}} ...attributes>{{yield}}</label>", {
  strictMode: true
}), templateOnly());

class Checkbox extends Component {
  handleClick = event => {
    const newChecked = event.target.checked;
    if (this.args.onChange) {
      this.args.onChange(newChecked, event);
    } else {
      this.args.checked?.toggle();
    }
  };
  static {
    setComponentTemplate(precompileTemplate("<input id={{@id}} type=\"checkbox\" role=\"switch\" checked={{@checked.current}} data-state={{if @checked.current \"on\" \"off\"}} {{on \"click\" this.handleClick}} ...attributes />", {
      strictMode: true,
      scope: () => ({
        on
      })
    }), this);
  }
}
function defaultFalse(value) {
  return value ?? false;
}
/**
 * @public
 */
const Switch = setComponentTemplate(precompileTemplate("<div ...attributes data-prim-switch>\n  {{#let (uniqueId) as |id|}}\n    {{#let (cell (defaultFalse @checked)) as |checked|}}\n      {{!-- @glint-nocheck --}}\n      {{yield (hash isChecked=checked.current Control=(component Checkbox checked=checked id=id onChange=@onChange) Label=(component Label for=id))}}\n    {{/let}}\n  {{/let}}\n</div>", {
  strictMode: true,
  scope: () => ({
    uniqueId,
    cell,
    defaultFalse,
    hash,
    Checkbox,
    Label
  })
}), templateOnly());

export { Switch, Switch as default };
//# sourceMappingURL=switch.js.map
