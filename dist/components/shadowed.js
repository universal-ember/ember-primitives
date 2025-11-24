
import Component from '@glimmer/component';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

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
class Shadowed extends Component {
  shadow;
  host;
  /**
  * ember-source 5.6 broke the ability to in-element
  * natively into a shadowroot.
  *
  * We have two or three more dives than we should have here.
  *
  *
  * See these ember-source bugs:
  * - https://github.com/emberjs/ember.js/issues/20643
  * - https://github.com/emberjs/ember.js/issues/20642
  * - https://github.com/emberjs/ember.js/issues/20641
  *
  * Ideally, shadowdom should be built in.
  * Couple paths forward:
  *  - (as the overall template tag)
  *     <template shadowrootmode="open">
  *     </template>
  *
  *  - Build a component into the framework that does the above ^
  *  - add additional parsing in content-tag to allow
  *    nested <template>
  *
  */
  constructor(owner, args) {
    super(owner, args);
    const element = document.createElement("div");
    const shadowRoot = element.attachShadow({
      mode: "open"
    });
    const div = document.createElement("div");
    shadowRoot.appendChild(div);
    this.host = element;
    this.shadow = div;
  }
  static {
    setComponentTemplate(precompileTemplate("\n    <div ...attributes>{{this.host}}</div>\n\n    {{#in-element this.shadow}}\n\n      {{#if @includeStyles}}\n        <Styles />\n      {{/if}}\n\n      {{yield}}\n\n    {{/in-element}}\n  ", {
      strictMode: true,
      scope: () => ({
        Styles
      })
    }), this);
  }
}

export { Shadowed, Shadowed as default };
//# sourceMappingURL=shadowed.js.map
