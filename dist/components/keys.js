
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const isLast = (collection, index) => index === collection.length - 1;
const isNotLast = (collection, index) => !isLast(collection, index);
const isMac = navigator.userAgent.indexOf("Mac OS") >= 0;
function split(str) {
  const keys = str.split("+").map(x => x.trim());
  return keys;
}
function getKeys(keys, mac) {
  const normalKeys = Array.isArray(keys) ? keys : split(keys);
  if (!mac) {
    return normalKeys;
  }
  const normalMac = Array.isArray(mac) ? mac : split(mac);
  return isMac ? normalMac : normalKeys;
}
const KeyCombo = setComponentTemplate(precompileTemplate("\n  <span class=\"ember-primitives__key-combination\" ...attributes>\n    {{#let (getKeys @keys @mac) as |keys|}}\n      {{#each keys as |key i|}}\n        <Key>{{key}}</Key>\n        {{#if (isNotLast keys i)}}\n          <span class=\"ember-primitives__key-combination__separator\">+</span>\n        {{/if}}\n      {{/each}}\n    {{/let}}\n  </span>\n", {
  strictMode: true,
  scope: () => ({
    getKeys,
    Key,
    isNotLast
  })
}), templateOnly());
const Key = setComponentTemplate(precompileTemplate("\n  <kbd class=\"ember-primitives__key\" ...attributes>{{yield}}</kbd>\n", {
  strictMode: true
}), templateOnly());

export { Key, KeyCombo };
//# sourceMappingURL=keys.js.map
