import Component from "@glimmer/component";

import { element } from "ember-element-helper";

import type Owner from "@ember/owner";

const LOOKUP = new WeakMap<Text, number>();

function levelOf(node: Text): number {
  let parent: ParentNode | null = node.parentElement;
  let level = 0;

  while (parent) {
    if (parent instanceof Element) {
      if (parent.tagName.toLowerCase() === "section") {
        level++;
      }
    }

    if (parent instanceof ShadowRoot) {
      parent = parent.host;
    }

    parent = parent.parentNode;
  }

  return level;
}

export class Heading extends Component<{
  Element: HTMLElement;
  Blocks: { default: [] };
}> {
  headingScopeAnchor: Text;
  constructor(owner: Owner, args: object) {
    super(owner, args);

    this.headingScopeAnchor = document.createTextNode("");
  }

  get level() {
    const existing = LOOKUP.get(this.headingScopeAnchor);

    if (existing) return existing;

    const parentLevel = levelOf(this.headingScopeAnchor);
    const myLevel = parentLevel + 1;

    LOOKUP.set(this.headingScopeAnchor, myLevel);

    return myLevel;
  }

  get hLevel() {
    return `h${this.level}`;
  }

  <template>
    {{this.headingScopeAnchor}}

    {{#let (element this.hLevel) as |el|}}
      <el ...attributes>
        {{yield}}
      </el>
    {{/let}}
  </template>
}
