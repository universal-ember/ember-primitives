import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';

import { modifier } from 'ember-modifier';
// temp
//  https://github.com/tracked-tools/tracked-toolbox/issues/38
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from 'tracked-toolbox';

import type { TOC } from '@ember/component/template-only';
import type { ModifierLike, WithBoundArgs } from '@glint/template';

const DialogElement: TOC<{
  Element: HTMLDialogElement;
  Args: {
    /**
     * @internal
     */
    open: boolean | undefined;
    /**
     * @internal
     */
    onClose: () => void;

    /**
     * @internal
     */
    register: ModifierLike<{ Element: HTMLDialogElement }>;
  };
  Blocks: { default: [] };
}> = <template>
  <dialog ...attributes open={{@open}} {{on "close" @onClose}} {{@register}}>
    {{yield}}
  </dialog>
</template>;

export interface Signature {
  Args: {
    /**
     * Optionally set the open state of the `<dialog>`
     * The state will still be managed internally,
     * so this does not need to be a maintained value, but whenever it changes,
     * the dialog element will reflect that change accordingly.
     */
    open?: boolean;
    /**
     * When the `<dialog>` is closed, this function will be called
     * and the `<dialog>`'s `returnValue` will be passed.
     *
     * This can be used to determine which button was clicked to close the modal
     *
     * Note though that this value is only populated when using
     * `<form method='dialog'>`
     */
    onClose?: (returnValue: string) => void;
  };
  Blocks: {
    default: [
      {
        /**
         * Represents the open state of the `<dialog>` element.
         */
        isOpen: boolean;
        /**
         * Closes the `<dialog>` element
         * Will throw an error if `Dialog` is not rendered.
         */
        close: () => void;
        /**
         * Opens the `<dialog>` element.
         * Will throw an error if `Dialog` is not rendered.
         */
        open: () => void;
        /**
         * This is the `<dialog>` element (with some defaults pre-wired).
         * This is required to be rendered.
         */
        Dialog: WithBoundArgs<typeof DialogElement, 'onClose' | 'register' | 'open'>;
      },
    ];
  };
}

class ModalDialog extends Component<Signature> {
  <template>
    {{yield
      (hash
        isOpen=this.isOpen
        open=this.open
        close=this.close
        Dialog=(component DialogElement open=@open onClose=this.handleClose register=this.register)
      )
    }}
  </template>

  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  @localCopy('args.open') declare _isOpen: boolean;

  get isOpen() {
    /**
     * Always fallback to false (closed)
     */
    return this._isOpen ?? false;
  }
  set isOpen(val: boolean) {
    this._isOpen = val;
  }

  @tracked declare dialogElement: HTMLDialogElement | undefined;

  register = modifier((element: HTMLDialogElement) => {
    /**
     * This is very sad.
     *
     * But we need the element to be 'root state'
     * so that when we read things like "isOpen",
     * when the dialog is finally rendered, all the
     * downstream properties render.
     *
     * This has to be an async / delayed a bit, so that
     * the tracking frame can exit, and we don't infinite loop
     */
    void (async () => {
      await Promise.resolve();

      this.dialogElement = element;
    })();
  });

  /**
   * Closes the dialog -- this will throw an error in development if the dialog element was not rendered
   */
  close = () => {
    assert(
      'Cannot call `close` on <Dialog> without rendering the dialog element.',
      this.dialogElement
    );

    /**
     * If the element is already closed, don't run all this again
     */
    if (!this.dialogElement.hasAttribute('open')) {
      return;
    }

    /**
     * removes the `open` attribute
     * handleClose will be called because the dialog has bound the `close` event.
     */
    this.dialogElement.close();
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
      this.dialogElement
    );

    this.isOpen = false;
    this.args.onClose?.(this.dialogElement.returnValue);
    // the return value ends up staying... which is annoying
    this.dialogElement.returnValue = '';
  };

  /**
   * Opens the dialog -- this will throw an error in development if the dialog element was not rendered
   */
  open = () => {
    assert(
      'Cannot call `open` on <Dialog> without rendering the dialog element.',
      this.dialogElement
    );

    /**
     * If the element is already open, don't run all this again
     */
    if (this.dialogElement.hasAttribute('open')) {
      return;
    }

    /**
     * adds the `open` attribute
     */
    this.dialogElement.showModal();
    this.isOpen = true;
  };
}

export const Modal = ModalDialog;
export const Dialog = ModalDialog;

export default ModalDialog;
