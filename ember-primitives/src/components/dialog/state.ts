import { tracked } from '@glimmer/tracking';
import { assert } from '@ember/debug';

import type { ElementState } from './element-state';

interface Options {
  onClose: ((reason: string) => void) | undefined;
  elementState: ElementState;
}

export class DialogState {
  #elementState: ElementState;
  #onClose: ((reason: string) => void) | undefined;

  constructor(options: Options) {
    this.#elementState = options.elementState;
    this.#onClose = options.onClose;
  }

  get #element() {
    return this.#elementState.element;
  }

  get isOpen() {
    let trackedValue = this.__isOpen__;

    return (this.#element?.hasAttribute('open') && trackedValue) ?? false;
  }

  /**
   * @private
   */
  @tracked __isOpen__ = false;

  /**
   * Closes the dialog -- this will throw an error in development if the dialog element was not rendered
   */
  close = () => {
    assert('Cannot call `close` on <Dialog> without rendering the dialog element.', this.#element);

    /**
     * If the element is already closed, don't run all this again
     */
    if (!this.#element.hasAttribute('open')) {
      return;
    }

    /**
     * removes the `open` attribute
     * handleClose will be called because the dialog has bound the `close` event.
     */
    this.#element.close();
  };

  /**
   * @internal
   *
   * handles the <dialog> element's native close behavior.
   * listened to via addEventListener('close', ...);
   */
  handleClose = () => {
    assert(
      'Cannot call `handleDialogClose` on <Dialog> without rendering the dialog element. This is likely a bug in ember-primitives. Please open an issue <3',
      this.#element
    );

    this.__isOpen__ = false;
    this.#onClose?.(this.#element.returnValue);
    // the return value ends up staying... which is annoying
    this.#element.returnValue = '';
  };

  /**
   * Opens the dialog -- this will throw an error in development if the dialog element was not rendered
   */
  open = () => {
    assert('Cannot call `open` on <Dialog> without rendering the dialog element.', this.#element);

    /**
     * If the element is already open, don't run all this again
     */
    if (this.#element.hasAttribute('open')) {
      return;
    }

    /**
     * adds the `open` attribute
     */
    this.#element.showModal();
    this.__isOpen__ = true;
  };
}

export function dialogState(
  elementState: ElementState,
  onClose: ((reason: string) => void) | undefined
) {
  return new DialogState({ elementState, onClose });
}
