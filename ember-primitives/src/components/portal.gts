/* eslint-disable @typescript-eslint/no-redundant-type-constituents */
import { assert } from "@ember/debug";
import { schedule } from "@ember/runloop";
import { buildWaiter } from "@ember/test-waiters";

import { modifier } from "ember-modifier";
import { cell, resource, resourceFactory } from "ember-resources";

import { isElement } from "../narrowing.ts";
import { findNearestTarget, type TARGETS } from "./portal-targets.gts";

import type { TOC } from "@ember/component/template-only";

type Targets = (typeof TARGETS)[keyof typeof TARGETS];

interface ToSignature {
  Args: {
    to: string;
    append?: boolean;
  };
  Blocks: {
    default: [];
  };
}
interface ElementSignature {
  Args: {
    to: Element;
    append?: boolean;
  };
  Blocks: {
    default: [];
  };
}

export interface Signature {
  Args: {
    /**
     * The name of the PortalTarget to render in to.
     * This is the value of the `data-portal-name` attribute
     * of the element you wish to render in to.
     *
     * This can also be an Element which pairs nicely with query-utilities such as the platform-native `querySelector`
     */
    to?: (Targets | (string & {})) | Element;

    /**
     * Set to true to append to the portal instead of replace
     *
     * Default: false
     */
    append?: boolean;
    /**
     * For ember-wormhole style behavior, this argument may be an id,
     * or a selector.
     * This can also be an element, in which case the behavior is identical to `@to`
     */
    wormhole?: string | Element;
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

  if (isElement(query)) {
    return query;
  }

  let found = document.getElementById(query);

  found ??= document.querySelector(query);

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

const ElementValue = () => cell<Element | ShadowRoot | null | undefined>();

const waiter = buildWaiter("ember-primitives:portal");

function wormholeCompat(selector: string | Element) {
  const target = wormhole(selector);

  if (target) return target;

  return resource(() => {
    const target = cell<Element | undefined | null>();

    const token = waiter.beginAsync();

    // eslint-disable-next-line ember/no-runloop
    schedule("afterRender", () => {
      const result = wormhole(selector);

      waiter.endAsync(token);
      target.current = result;
      assert(
        `Could not find element with id/selector \`${typeof selector === "string" ? selecter : "<Element>"}\``,
        result,
      );
    });

    return () => target.current;
  });
}

resourceFactory(wormholeCompat);

export const Portal: TOC<Signature> = <template>
  {{#if (isElement @to)}}
    <ToElement @to={{@to}} @append={{@append}}>
      {{yield}}
    </ToElement>
  {{else if @wormhole}}
    {{#let (wormholeCompat @wormhole) as |target|}}
      {{#if target}}
        {{#in-element target insertBefore=null}}
          {{yield}}
        {{/in-element}}
      {{/if}}
    {{/let}}
  {{else if @to}}
    <Nestable @to={{@to}} @append={{@append}}>
      {{yield}}
    </Nestable>
  {{else}}
    {{assert "either @to or @wormhole is required. Received neither"}}
  {{/if}}
</template>;

const ToElement: TOC<ElementSignature> = <template>
  {{#if @append}}
    {{#in-element @to insertBefore=null}}
      {{yield}}
    {{/in-element}}
  {{else}}
    {{#in-element @to}}
      {{yield}}
    {{/in-element}}
  {{/if}}
</template>;

const Nestable: TOC<ToSignature> = <template>
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
</template>;

export default Portal;
