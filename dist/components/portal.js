import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { findNearestTarget } from './portal-targets.js';

const anchor = modifier((element, [to, update]) => {
  let found = findNearestTarget(element, to);
  update(found);
});
const ElementValue = () => cell();
const Portal = setComponentTemplate(precompileTemplate(`
  {{#let (ElementValue) as |target|}}
    <div {{anchor @to target.set}}>
      {{#if target.current}}
        {{#in-element target.current}}
          {{yield}}
        {{/in-element}}
      {{/if}}
    </div>
  {{/let}}
`, {
  strictMode: true,
  scope: () => ({
    ElementValue,
    anchor
  })
}), templateOnly("portal", "Portal"));

export { Portal, Portal as default };
//# sourceMappingURL=portal.js.map
