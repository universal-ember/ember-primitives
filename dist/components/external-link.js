import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const ExternalLink = setComponentTemplate(precompileTemplate("\n  <a target=\"_blank\" rel=\"noreferrer noopener\" href=\"##missing##\" ...attributes>\n    {{yield}}\n  </a>\n", {
  strictMode: true
}), templateOnly());

export { ExternalLink, ExternalLink as default };
//# sourceMappingURL=external-link.js.map
