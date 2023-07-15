import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { toggleWithFallback } from './-private/utils.js';

const Toggle = setComponentTemplate(precompileTemplate(`
  {{#let (cell @pressed) as |pressed|}}
    <button
      type='button'
      aria-pressed='{{pressed.current}}'
      {{on 'click' (fn toggleWithFallback pressed.toggle @onChange)}}
      ...attributes
    >
      {{yield pressed.current}}
    </button>
  {{/let}}
`, {
  strictMode: true,
  scope: () => ({
    cell,
    on,
    fn,
    toggleWithFallback
  })
}), templateOnly("toggle", "Toggle"));

export { Toggle, Toggle as default };
//# sourceMappingURL=toggle.js.map
