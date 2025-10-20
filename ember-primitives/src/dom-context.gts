import Component from "@glimmer/component";
import { cached, tracked } from "@glimmer/tracking";
import { assert } from "@ember/debug";

import { createStore } from "./store.ts";

import type { Newable } from "./type-utils";
import type Owner from "@ember/owner";

/**
 * IMPLEMENTATION NOTE:
 *   we don't use https://github.com/webcomponents-cg/community-protocols/blob/main/proposals/context.md
 *   because it is not inherently reactive.
 *
 *   Its *event* based, which opts you out of fine-grained reactivity.
 *   We want minimal effort fine-grained reactivity.
 *
 * This Technique follows the DOM tree, and is synchronous,
 * allowing correct fine-grained signals-based reactivity.
 *
 * We *could* do less work to find Providers,
 * but only if we forgoe DOM-tree scoping.
 * We must traverse the DOM hierarchy to validate that we aren't accessing providers from different subtrees.
 */
const LOOKUP = new WeakMap<Element, [unknown, () => unknown]>();

export class Provide<Data extends object> extends Component<{
  Args: {
    /**
     * What data do you want to provide to the DOM subtree?
     *
     * If this is a function or class, it will be instantiated and given an
     * owner + destroyable linkage via `createStore`
     */
    data: Data | (() => Data) | Newable<Data>;

    /**
     * Optionally, you may use string-based keys to reference the data in the Provide.
     *
     * This is not recommended though, because when using a class or other object-like structure,
     * the type in the `<Consume>` component can be derived from that class or object-like structure.
     * With string keys, the `<Consume>` type will be unknown.
     */
    key?: string;
  };
  Blocks: {
    /**
     * The content that this component will _provide_ data to the entire hierarchy.
     */
    default: [];
  };
}> {
  get data() {
    assert(`@data is missing in <Provide>. Please pass @data.`, "data" in this.args);

    /**
     * This covers both classes and functions
     */
    if (typeof this.args.data === "function") {
      return createStore<Data>(this, this.args.data);
    }

    /**
     * Non-instantiable value
     */
    return this.args.data;
  }

  element: HTMLDivElement;

  constructor(
    owner: Owner,
    args: {
      data: Data | (() => Data) | Newable<Data>;
      key?: string;
    },
  ) {
    super(owner, args);

    const element = document.createElement("div");

    element.style.display = "contents";

    const key = this.args.key ?? this.args.data;

    LOOKUP.set(element, [key, () => this.data]);
    this.element = element;
  }

  <template>
    {{this.element}}

    {{#in-element this.element}}
      {{yield}}
    {{/in-element}}
  </template>
}

function findForKey<Data>(startElement: Element, key: string | object): undefined | (() => Data) {
  let parent: Element | null = startElement;

  while ((parent = parent.parentElement)) {
    const maybe = LOOKUP.get(parent);

    if (!maybe) {
      continue;
    }

    if (maybe[0] === key) {
      return maybe[1] as () => Data;
    }
  }
}

type DataForKey<Key> = Key extends string
  ? unknown
  : Key extends Newable<infer T>
    ? T
    : Key extends () => infer T
      ? T
      : Key;

export class Consume<Key extends object | string> extends Component<{
  Args: {
    key: Key;
  };
  Blocks: {
    default: [
      context: {
        data: DataForKey<Key>;
      },
    ];
  };
}> {
  // SAFETY: We do a runtime assert in the getter below.
  @tracked getData!: () => DataForKey<Key>;

  element: HTMLDivElement;

  constructor(owner: Owner, args: { key: Key }) {
    super(owner, args);

    this.element = document.createElement("div");
    this.element.style.display = "contents";
  }

  @cached
  get context() {
    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const self = this;

    return {
      get data(): DataForKey<Key> {
        const getData = findForKey<Key>(self.element, self.args.key);

        assert(
          `Could not find provided context in <Consume>. Please assure that there is a corresponding <Provide> component before using this <Consume> component`,
          getData,
        );

        // SAFETY: return type handled by getter's signature
        // eslint-disable-next-line @typescript-eslint/no-unsafe-return
        return getData() as any;
      },
    };
  }

  <template>
    {{this.element}}

    {{#in-element this.element}}
      {{yield this.context}}
    {{/in-element}}
  </template>
}
