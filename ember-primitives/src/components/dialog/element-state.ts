import { modifier } from 'ember-modifier';

/**
 * @internal
 */
export class ElementState {
  element: HTMLDialogElement | undefined;
  isOpen: boolean | undefined;

  constructor(isOpen: boolean | undefined) {
    this.isOpen = isOpen;
  }

  register = modifier((element: HTMLDialogElement) => {
    this.element = element;

    if (this.isOpen !== undefined) {
      element.setAttribute('open', `${this.isOpen}`);
    }
  });
}

/**
 * @internal
 */
export function elementState(isOpen?: boolean | undefined) {
  return new ElementState(isOpen);
}
