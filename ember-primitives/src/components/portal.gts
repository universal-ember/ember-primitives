import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';

import { findNearestTarget, type TARGETS } from './portal-targets';

import type { TOC } from '@ember/component/template-only';

export interface Signature {
  Args: {
    /**
     * The name of the PortalTarget to render in to.
     * This is the value of the `data-portal-name` attribute
     * of the element you wish to render in to.
     */
    to: (typeof TARGETS)[keyof typeof TARGETS] | (string & {});
  };
  Blocks: {
    /**
     * The portaled content
     */
    default: [];
  };
}

const anchor = modifier(
  (element: Element, [to, update]: [string, ReturnType<typeof ElementValue>['set']]) => {
    let found = findNearestTarget(element, to);

    update(found);
  }
);

const ElementValue = () => cell<Element | ShadowRoot>();

export const Portal: TOC<Signature> = <template>
  {{#let (ElementValue) as |target|}}
    {{!-- This div is always going to be empty,
          because it'll either find the portal and render content elsewhere,
          it it won't find the portal and won't render anything.
    --}}
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
