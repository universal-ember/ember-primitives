import Component from "@glimmer/component";

import { element } from "ember-element-helper";

import type Owner from "@ember/owner";

const LOOKUP = new WeakMap<Text, number>();

const ELEMENTS_THAT_CHANGE_SECTION_HEADING_LEVEL = new Set([
  "section",
  "article",
  "aside",
  "header",
  "footer",
  "main",
  "nav",
]);

const SECTION_HEADINGS = new Set(["h1", "h2", "h3", "h4", "h5", "h6"]);

function levelOf(node: Text): number {
  let child: Text | ParentNode | null = node;
  let parent: ParentNode | null = node.parentElement;
  let level = 0;

  while (parent) {
    if (parent instanceof Element) {
      const tagName = parent.tagName.toLowerCase();
      const mightChange = ELEMENTS_THAT_CHANGE_SECTION_HEADING_LEVEL.has(tagName);

      let foundSectionHeading = false;
      let search: Element | null | undefined = child;

      while ((search = search?.previousElementSibling)) {
        const tagName = search.tagName.toLowerCase();

        if (SECTION_HEADINGS.has(tagName)) {
          foundSectionHeading = true;

          break;
        }
      }

      const shouldChange = mightChange && foundSectionHeading;

      if (shouldChange) {
        level++;
      }
    }

    if (parent instanceof ShadowRoot) {
      parent = parent.host;
    }

    child = parent;
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

    {{#let (element this.hLevel) as |El|}}
      <El ...attributes>
        {{yield}}
      </El>
    {{/let}}
  </template>
}
