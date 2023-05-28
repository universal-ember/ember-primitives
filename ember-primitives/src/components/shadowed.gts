import { modifier } from 'ember-modifier';
import { cell}  from 'ember-resources';

import type { TOC } from '@ember/component/template-only';

type UpdateFn = ReturnType<typeof cell>['update'];

const attachShadow = modifier((element: Element, [setShadow]: [UpdateFn]) => {
  setShadow(element.attachShadow({ mode: 'open' }));
});

// index.html has the production-fingerprinted references to these links
// Ideally, we'd have some pre-processor scan everything for references to
// assets in public, but idk how to set that up
const getStyles = () => [...document.head.querySelectorAll('link')].map((link) => link.href);

const Styles = <template>
  {{#let (getStyles) as |styles|}}
    {{#each styles as |styleHref|}}

      <link rel='stylesheet' href={{styleHref}} />

    {{/each}}
  {{/let}}
</template>;

/**
  * Render content in a shadow dom, attached to a div
  */
export const Shadowed: TOC<{
  Element: HTMLDivElement;
  Args: {
    /**
      * By default, shadow-dom does not include any styles.
      * Setting this to true will include all the `<style>` tags
      * that are present in the `<head>` element.
      */
    includeStyles?: boolean;
  };
  Blocks: { default: [] };
}> = <template>
  {{#let (cell) as |shadow|}}
    {{!-- TODO: We need a way in ember to render in to a shadow dom without an effect --}}
    <div data-shadow {{attachShadow shadow.update}} ...attributes></div>

    {{#if shadow.value}}
      {{#in-element shadow.value}}

        {{#if @includeStyles}}
          <Styles />
        {{/if}}

        {{yield}}

      {{/in-element}}
    {{/if}}
  {{/let}}
</template>;

export default Shadowed;
