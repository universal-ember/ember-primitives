import { modifier } from 'ember-modifier';

/**
 * @internal
 */
export class ElementState {
  element: HTMLDialogElement | undefined;

  register = modifier((element: HTMLDialogElement) => {
    this.element = element;
  });
}

/**
 * @internal
 */
export function elementState() {
  return new ElementState();
}
