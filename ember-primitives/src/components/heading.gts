import Component from "@glimmer/component";

import { getSectionHeadingLevel } from "which-heading-do-i-need";

import { element } from "ember-element-helper";

import type Owner from "@ember/owner";

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
    return getSectionHeadingLevel(this.headingScopeAnchor);
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
