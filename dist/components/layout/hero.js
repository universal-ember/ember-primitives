import "./hero.css"
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

;

const Hero = setComponentTemplate(precompileTemplate("<div class=\"ember-primitives__hero__wrapper\" ...attributes>\n  {{yield}}\n</div>", {
  strictMode: true
}), templateOnly());

export { Hero };
//# sourceMappingURL=hero.js.map
