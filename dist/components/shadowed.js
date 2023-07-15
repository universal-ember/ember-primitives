import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

const Shadow = () => {
  let shadow = cell();
  return {
    get root() {
      return shadow.current;
    },
    attach: modifier(element => {
      shadow.set(element.attachShadow({
        mode: 'open'
      }));
    })
  };
};

// index.html has the production-fingerprinted references to these links
// Ideally, we'd have some pre-processor scan everything for references to
// assets in public, but idk how to set that up
const getStyles = () => [...document.head.querySelectorAll('link')].map(link => link.href);
const Styles = setComponentTemplate(precompileTemplate(`
  {{#let (getStyles) as |styles|}}
    {{#each styles as |styleHref|}}

      <link rel='stylesheet' href={{styleHref}} />

    {{/each}}
  {{/let}}
`, {
  strictMode: true,
  scope: () => ({
    getStyles
  })
}), templateOnly("shadowed", "Styles"));

/**
 * Render content in a shadow dom, attached to a div.
 *
 * Uses the [shadow DOM][mdn-shadow-dom] API.
 *
 * [mdn-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM
 *
 * This is useful when you want to render content that escapes your app's styles.
 */
const Shadowed = setComponentTemplate(precompileTemplate(`
  {{#let (Shadow) as |shadow|}}
    {{! TODO: We need a way in ember to render in to a shadow dom without an effect }}
    <div {{shadow.attach}} ...attributes></div>

    {{#if shadow.root}}
      {{#in-element shadow.root}}

        {{#if @includeStyles}}
          <Styles />
        {{/if}}

        {{yield}}

      {{/in-element}}
    {{/if}}
  {{/let}}
`, {
  strictMode: true,
  scope: () => ({
    Shadow,
    Styles
  })
}), templateOnly("shadowed", "Shadowed"));

export { Shadowed, Shadowed as default };
//# sourceMappingURL=shadowed.js.map
