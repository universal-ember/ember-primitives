import { assert } from '@ember/debug';
import { find } from '@ember/test-helpers';

export function resetTestingContainerDimensions() {
  const element = document.querySelector('#ember-testing');

  assert(
    'Could not find #ember-testing. This utility is only valid in tests.',
    element instanceof HTMLElement
  );

  const style = element.style;

  // reset test container scale so values returned by getBoundingClientRect are accurate
  Object.assign(style, {
    transform: 'scale(1)',
    width: '100%',
    height: '100%',
  });
}

export function findElement(selector: string) {
  const element = find(selector);

  assert(`Could not find element with '${selector}'`, element);
  assert(
    `Expected element for '${selector}' does not have a style attribute`,
    element instanceof HTMLElement || element instanceof SVGElement
  );

  return element;
}
