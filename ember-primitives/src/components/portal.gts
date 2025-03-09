import { modifier } from "ember-modifier";
import { cell } from "ember-resources";

import { findNearestTarget, type TARGETS } from "./portal-targets.gts";

import type { TOC } from "@ember/component/template-only";

type Targets = (typeof TARGETS)[keyof typeof TARGETS];

export interface Signature {
  Args: {
    /**
     * The name of the PortalTarget to render in to.
     * This is the value of the `data-portal-name` attribute
     * of the element you wish to render in to.
     */
    // eslint-disable-next-line @typescript-eslint/no-redundant-type-constituents
    to: Targets | (string & {});
  };
  Blocks: {
    /**
     * The portaled content
     */
    default: [];
  };
}

const anchor = modifier(
  (element: Element, [to, update]: [string, ReturnType<typeof ElementValue>["set"]]) => {
    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call
    const found = findNearestTarget(element, to);

    // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
    update(found);
  },
);

const ElementValue = () => cell<Element | ShadowRoot>();

export const Portal: TOC<Signature> = <template>
  {{#let (ElementValue) as |target|}}
    {{! This div is always going to be empty,
          because it'll either find the portal and render content elsewhere,
          it it won't find the portal and won't render anything.
    }}
    {{! template-lint-disable no-inline-styles }}
    <div style="display:contents;" {{anchor @to target.set}}>
      {{#if target.current}}
        {{#in-element target.current}}
          {{yield}}
        {{/in-element}}
      {{/if}}
    </div>
  {{/let}}
</template>;

export default Portal;
