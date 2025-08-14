import { assert } from "@ember/debug";

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
    to: (Targets | (string & {})) | Element;

    /**
     * Set to true to append to the portal instead of replace
     *
     * Default: false
     */
    append?: boolean;
  };
  Blocks: {
    /**
     * The portaled content
     */
    default: [];
  };
}

/**
 * Polyfill for ember-wormhole behavior
 *
 * Example usage:
 * ```gjs
 * import { wormhole, Portal } from 'ember-primitives/components/portal';
 *
 * <template>
 *   <div id="the-portal"></div>
 *
 *   <Portal @to={{wormhole "the-portal"}}>
 *     content renders in the above div
 *   </Portal>
 * </template>
 *
 * ```
 */
export function wormhole(query: string | null | undefined | Element) {
  assert(`Expected query/element to be truthy.`, query);

  if (query instanceof Element) {
    return query;
  }

  let found = document.getElementById(query);

  found ??= document.querySelector(query);

  assert(`Could not find element with id/selector ${query}`, found);

  return found;
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

function isElement(x: unknown): x is Element {
  return x instanceof Element;
}

export const Portal: TOC<Signature> = <template>
  {{#if (isElement @to)}}
    {{#if @append}}
      {{#in-element @to insertBefore=null}}
        {{yield}}
      {{/in-element}}
    {{else}}
      {{#in-element @to}}
        {{yield}}
      {{/in-element}}
    {{/if}}
  {{else}}
    {{#let (ElementValue) as |target|}}
      {{! This div is always going to be empty,
          because it'll either find the portal and render content elsewhere,
          it it won't find the portal and won't render anything.
      }}
      {{! template-lint-disable no-inline-styles }}
      <div style="display:contents;" {{anchor @to target.set}}>
        {{#if target.current}}
          {{#if @append}}
            {{#in-element target.current insertBefore=null}}
              {{yield}}
            {{/in-element}}
          {{else}}
            {{#in-element target.current}}
              {{yield}}
            {{/in-element}}
          {{/if}}
        {{/if}}
      </div>
    {{/let}}
  {{/if}}
</template>;

export default Portal;
