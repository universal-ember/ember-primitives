import { cell } from 'ember-resources';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { toggleWithFallback } from './-private/utils.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

// import Component from '@glimmer/component';
// eslint-disable-next-line @typescript-eslint/no-explicit-any
function isPressed(pressed1, value1, isPressed1) {
  if (!value1) return Boolean(pressed1);
  if (!isPressed1) return Boolean(pressed1);
  return isPressed1(value1);
}
const Toggle = setComponentTemplate(precompileTemplate("\n  {{#let (cell (isPressed @pressed @value @isPressed)) as |pressed|}}\n    <button type=\"button\" aria-pressed=\"{{pressed.current}}\" {{on \"click\" (fn toggleWithFallback pressed.toggle @onChange @value)}} ...attributes>\n      {{yield pressed.current}}\n    </button>\n  {{/let}}\n", {
  scope: () => ({
    cell,
    isPressed,
    on,
    fn,
    toggleWithFallback
  }),
  strictMode: true
}), templateOnly());

export { Toggle, Toggle as default };
//# sourceMappingURL=toggle.js.map
