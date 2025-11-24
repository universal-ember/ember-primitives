
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { t as toggleWithFallback } from '../utils-C5796IKA.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

// import Component from '@glimmer/component';

function isPressed(pressed, value, isPressed) {
  if (!value) return Boolean(pressed);
  if (!isPressed) return Boolean(pressed);
  return isPressed(value);
}
const Toggle = setComponentTemplate(precompileTemplate("\n  {{#let (cell (isPressed @pressed @value @isPressed)) as |pressed|}}\n    <button type=\"button\" aria-pressed=\"{{pressed.current}}\" {{on \"click\" (fn toggleWithFallback pressed.toggle @onChange @value)}} ...attributes>\n      {{yield pressed.current}}\n    </button>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    cell,
    isPressed,
    on,
    fn,
    toggleWithFallback
  })
}), templateOnly());

export { Toggle, Toggle as default };
//# sourceMappingURL=toggle.js.map
