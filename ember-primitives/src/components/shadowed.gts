import Component from "@glimmer/component";

import type Owner from "@ember/owner";

// index.html has the production-fingerprinted references to these links
// Ideally, we'd have some pre-processor scan everything for references to
// assets in public, but idk how to set that up
const getStyles = () => [...document.querySelectorAll("link")].map((link) => link.href);

/**
 * style + native @import
 * is the only robust way to load styles in a shadowroot.
 *
 * link is only valid in the head element.
 */
const Styles = <template>
  <style>
    {{#each (getStyles) as |styleHref|}}

      @import "{{styleHref}}";

    {{/each}}
  </style>
</template>;

/**
 * Render content in a shadow dom, attached to a div.
 *
 * Uses the [shadow DOM][mdn-shadow-dom] API.
 *
 * [mdn-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM
 *
 * This is useful when you want to render content that escapes your app's styles.
 */
export class Shadowed extends Component<{
  /**
   * The shadow dom attaches to a div element.
   * You may specify any attribute, and it'll be applied to this host element.
   */
  Element: HTMLDivElement;
  Args: {
    /**
     * @public
     *
     * By default, shadow-dom does not include any styles.
     * Setting this to true will include all the `<style>` tags
     * that are present in the `<head>` element.
     */
    includeStyles?: boolean;
  };
  Blocks: {
    /**
     * Content to be placed within the ShadowDOM
     */
    default: [];
  };
}> {
  shadow: HTMLDivElement;
  host: HTMLDivElement;
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
  constructor(owner: Owner, args: { includeStyles?: boolean }) {
    super(owner, args);

    const element = document.createElement("div");
    const shadowRoot = element.attachShadow({ mode: "open" });
    const div = document.createElement("div");

    shadowRoot.appendChild(div);
    this.host = element;
    this.shadow = div;
  }

  <template>
    <div ...attributes>{{this.host}}</div>

    {{#in-element this.shadow}}

      {{#if @includeStyles}}
        <Styles />
      {{/if}}

      {{yield}}

    {{/in-element}}
  </template>
}

export default Shadowed;
