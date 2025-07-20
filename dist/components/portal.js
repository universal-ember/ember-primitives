import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { findNearestTarget } from './portal-targets.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const anchor = modifier((element, [to, update]) => {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call
  const found = findNearestTarget(element, to);
  // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
  update(found);
});
const ElementValue = () => cell();
const Portal = setComponentTemplate(precompileTemplate("\n  {{#let (ElementValue) as |target|}}\n    {{!-- This div is always going to be empty,\n          because it'll either find the portal and render content elsewhere,\n          it it won't find the portal and won't render anything.\n    --}}\n    {{!-- template-lint-disable no-inline-styles --}}\n    <div style=\"display:contents;\" {{anchor @to target.set}}>\n      {{#if target.current}}\n        {{#in-element target.current}}\n          {{yield}}\n        {{/in-element}}\n      {{/if}}\n    </div>\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    ElementValue,
    anchor
  })
}), templateOnly());

export { Portal, Portal as default };
//# sourceMappingURL=portal.js.map
