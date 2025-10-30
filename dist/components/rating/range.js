
import { on } from '@ember/modifier';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const RatingRange = setComponentTemplate(precompileTemplate("\n  <input ...attributes name={{@name}} type=\"range\" max={{@max}} value={{@value}} {{on \"change\" @handleChange}} />\n", {
  strictMode: true,
  scope: () => ({
    on
  })
}), templateOnly());

export { RatingRange };
//# sourceMappingURL=range.js.map
