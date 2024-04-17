import { assert } from '@ember/debug';
import { find } from '@ember/test-helpers';

import type { Middleware } from '@floating-ui/dom';

// Floating UI middleware
// provides data-* attributes for values in test assertions
export function addDataAttributes(): Middleware {
  return {
    name: 'dataAttributes',
    fn: ({ elements, placement, strategy }) => {
      elements.floating.setAttribute('data-placement', placement);
      elements.floating.setAttribute('data-strategy', strategy);

      // https://floating-ui.com/docs/middleware#always-return-an-object
      return {};
    },
  };
}

// testing containers transforms give Floating UI's logic some challenges
export function resetTestingContainerDimensions() {
  let element = document.querySelector('#ember-testing');

  assert(
    'Could not find #ember-testing. This utility is only valid in tests.',
    element instanceof HTMLElement
  );

  let style = element.style;

  // reset test container scale so values returned by getBoundingClientRect are accurate
  Object.assign(style, {
    transform: 'scale(1)',
    width: '100%',
    height: '100%',
  });
}

export function findElement(selector: string) {
  let element = find(selector);

  assert(`Could not find element with '${selector}'`, element);
  assert(
    `Expected element for '${selector}' does not have a style attribute`,
    element instanceof HTMLElement || element instanceof SVGElement
  );

  return element;
}
