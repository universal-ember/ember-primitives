import Component from "@glimmer/component";

import { element } from "ember-element-helper";

import { Consume, Provide } from "../dom-context.gts";

import type Owner from "@ember/owner";

class AutoHeading {
  level = 1;

  get down() {
    return this.level - 1;
  }

  get downH() {
    return `h${this.down}`;
  }
}

export class Heading extends Component<{
  Element: HTMLElement;
  Blocks: { default: [] };
}> {
  element: HTMLElement;
  constructor(owner: Owner, args: object) {
    super(owner, args);

    this.element = document.createElement(`h${level}`);
  }

  <template>
    <Consume @key={{AutoHeading}} as |state|>
      {{#let (element state.data.downH) as |el|}}
        <el ...attributes>
          {{yield}}
        </el>
      {{/let}}

    </Consume>
  </template>
}

export class Section extends Component<{
  Element: HTMLElement;
  Blocks: {
    default: [];
  };
}> {
  constructor(owner: Owner, args: object) {
    super(owner, args);
  }
  <template>
    <section ...attributes>
      <Provide @data={{AutoHeading}}>
        {{yield}}
      </Provide>
    </section>
  </template>
}
