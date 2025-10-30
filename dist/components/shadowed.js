
import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const Shadow = () => {
  const shadow = cell();
  return {
    get root() {
      return shadow.current;
    },
    attach: modifier(element => {
      const shadowRoot = element.attachShadow({
        mode: "open"
      });
      const div = document.createElement("div");
      // ember-source 5.6 broke the ability to in-element
      // natively into a shadowroot.
      //
      // See these ember-source bugs:
      // - https://github.com/emberjs/ember.js/issues/20643
      // - https://github.com/emberjs/ember.js/issues/20642
      // - https://github.com/emberjs/ember.js/issues/20641
      shadowRoot.appendChild(div);
      shadow.set(div);
    })
  };
};
// index.html has the production-fingerprinted references to these links
// Ideally, we'd have some pre-processor scan everything for references to
// assets in public, but idk how to set that up
const getStyles = () => [...document.querySelectorAll("link")].map(link => link.href);
/**
 * style + native @import
 * is the only robust way to load styles in a shadowroot.
 *
 * link is only valid in the head element.
 */
const Styles = setComponentTemplate(precompileTemplate("\n  <style>\n    {{#each (getStyles) as |styleHref|}}\n\n      @import \"{{styleHref}}\";\n\n    {{/each}}\n  </style>\n", {
  strictMode: true,
  scope: () => ({
    getStyles
  })
}), templateOnly());
/**
 * Render content in a shadow dom, attached to a div.
 *
 * Uses the [shadow DOM][mdn-shadow-dom] API.
 *
 * [mdn-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM
 *
 * This is useful when you want to render content that escapes your app's styles.
 */
const Shadowed = setComponentTemplate(precompileTemplate("\n  {{#let (Shadow) as |shadow|}}\n    {{!-- TODO: We need a way in ember to render in to a shadow dom without an effect --}}\n    <div {{shadow.attach}} ...attributes></div>\n\n    {{#if shadow.root}}\n      {{#in-element shadow.root}}\n\n        {{#if @includeStyles}}\n          <Styles />\n        {{/if}}\n\n        {{yield}}\n\n      {{/in-element}}\n    {{/if}}\n  {{/let}}\n", {
  strictMode: true,
  scope: () => ({
    Shadow,
    Styles
  })
}), templateOnly());

export { Shadowed, Shadowed as default };
//# sourceMappingURL=shadowed.js.map
