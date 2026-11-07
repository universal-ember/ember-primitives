import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

/**
 * If the user provides an onChange or similar function, use that,
 * otherwise fallback to the uncontrolled toggle
 */
function toggleWithFallback(uncontrolledToggle, controlledToggle, ...args) {
  if (controlledToggle) {
    return controlledToggle(...args);
  }
  uncontrolledToggle?.(...args);
}

// import Component from '@glimmer/component';

function isPressed(pressed, value, isPressed) {
  if (!value) return Boolean(pressed);
  if (!isPressed) return Boolean(pressed);
  return isPressed(value);
}
const Toggle = setComponentTemplate(precompileTemplate("{{#let (cell (isPressed @pressed @value @isPressed)) as |pressed|}}\n  <button type=\"button\" aria-pressed=\"{{pressed.current}}\" {{on \"click\" (fn toggleWithFallback pressed.toggle @onChange @value)}} ...attributes>\n    {{yield pressed.current}}\n  </button>\n{{/let}}", {
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
