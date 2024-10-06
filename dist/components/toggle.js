import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { toggleWithFallback } from './-private/utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

// import Component from '@glimmer/component';

function isPressed(pressed1, value1, isPressed1) {
  if (!value1) return Boolean(pressed1);
  if (!isPressed1) return Boolean(pressed1);
  return isPressed1(value1);
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
