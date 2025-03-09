import type { TOC } from "@ember/component/template-only";

const isLast = (collection: unknown[], index: number) => index === collection.length - 1;
const isNotLast = (collection: unknown[], index: number) => !isLast(collection, index);
const isMac = navigator.userAgent.indexOf("Mac OS") >= 0;

function split(str: string) {
  const keys = str.split("+").map((x) => x.trim());

  return keys;
}

function getKeys(keys: string[] | string, mac?: string[] | string) {
  const normalKeys = Array.isArray(keys) ? keys : split(keys);

  if (!mac) {
    return normalKeys;
  }

  const normalMac = Array.isArray(mac) ? mac : split(mac);

  return isMac ? normalMac : normalKeys;
}

export interface KeyComboSignature {
  Element: HTMLElement;
  Args: {
    keys: string[] | string;
    mac?: string[] | string;
  };
}

export const KeyCombo: TOC<KeyComboSignature> = <template>
  <span class="ember-primitives__key-combination" ...attributes>
    {{#let (getKeys @keys @mac) as |keys|}}
      {{#each keys as |key i|}}
        <Key>{{key}}</Key>
        {{#if (isNotLast keys i)}}
          <span class="ember-primitives__key-combination__separator">+</span>
        {{/if}}
      {{/each}}
    {{/let}}
  </span>
</template>;

export interface KeySignature {
  Element: HTMLElement;
  Blocks: { default?: [] };
}

export const Key: TOC<KeySignature> = <template>
  <kbd class="ember-primitives__key" ...attributes>{{yield}}</kbd>
</template>;
