import './sticky-footer.css';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const StickyFooter = setComponentTemplate(precompileTemplate("\n  <div class=\"ember-primitives__sticky-footer__wrapper\" ...attributes>\n    <div class=\"ember-primitives__sticky-footer__container\">\n      <div class=\"ember-primitives__sticky-footer__content\">\n        {{yield to=\"content\"}}\n      </div>\n      <div class=\"ember-primitives__sticky-footer__footer\">\n        {{yield to=\"footer\"}}\n      </div>\n    </div>\n  </div>\n", {
  strictMode: true
}), templateOnly());

export { StickyFooter, StickyFooter as default };
//# sourceMappingURL=sticky-footer.js.map
