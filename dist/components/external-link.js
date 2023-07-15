import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';

const ExternalLink = setComponentTemplate(precompileTemplate(`
  <a target='_blank' rel='noreferrer noopener' href='##missing##' ...attributes>
    {{yield}}
  </a>
`, {
  strictMode: true
}), templateOnly("external-link", "ExternalLink"));

export { ExternalLink, ExternalLink as default };
//# sourceMappingURL=external-link.js.map
