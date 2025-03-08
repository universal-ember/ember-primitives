import type { TOC } from '@ember/component/template-only';

const isLast = (collection: unknown[], index: number) => index === collection.length - 1;
const isNotLast = (collection: unknown[], index: number) => !isLast(collection, index);
const isMac = navigator.userAgent.indexOf('Mac OS') >= 0;
const getKeys = (keys: string[], mac: string[]) => (isMac ? mac ?? keys : keys);

export const KeyCombo: TOC<{
  Element: HTMLElement;
  Args: {
    keys: string[];
    mac: string[];
  };
}> = <template>
  <span class="ember-primitives__key-combination" ...attributes>
    {{#let (getKeys @keys @mac) as |keys|}}
      {{#each keys as |key i|}}
        <Key>{{key}}</Key>
        {{#if (isNotLast @keys i)}}
          <span class="ember-primitives__key-combination__separator">+</span>
        {{/if}}
      {{/each}}
    {{/let}}
  </span>
</template>;

export const Key: TOC<{
  Element: HTMLElement;
  Blocks: { default?: [] };
}> = <template>
  <span class="ember-primitives__key" ...attributes>{{yield}}</span>
</template>;
