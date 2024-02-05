import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

import type { TOC } from '@ember/component/template-only';

const Shadow = () => {
  let shadow = cell<Element>();

  return {
    get root() {
      return shadow.current;
    },
    attach: modifier((element: Element) => {
      let shadowRoot = element.attachShadow({ mode: 'open' });
      let div = document.createElement('div');

      // ember-source 5.6 broke the ability to in-element
      // natively into a shadowroot.
      //
      // See these ember-source bugs:
      // -
      // -
      // -
      shadowRoot.appendChild(div);

      shadow.set(div);
    }),
  };
};

// index.html has the production-fingerprinted references to these links
// Ideally, we'd have some pre-processor scan everything for references to
// assets in public, but idk how to set that up
const getStyles = () => [...document.head.querySelectorAll('link')].map((link) => link.href);

const Styles = <template>
  {{#each (getStyles) as |styleHref|}}

    <link rel="stylesheet" href={{styleHref}} />

  {{/each}}
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
export const Shadowed: TOC<{
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
}> = <template>
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
</template>;

export default Shadowed;
