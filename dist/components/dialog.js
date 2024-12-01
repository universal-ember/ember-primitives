import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { modifier } from 'ember-modifier';
import { localCopy } from 'tracked-toolbox';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { g, i } from 'decorator-transforms/runtime';

const DialogElement = setComponentTemplate(precompileTemplate("\n  <dialog ...attributes open={{@open}} {{on \"close\" @onClose}} {{@register}}>\n    {{yield}}\n  </dialog>\n", {
  strictMode: true,
  scope: () => ({
    on
  })
}), templateOnly());
let ModalDialog = class ModalDialog extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    {{yield (hash isOpen=this.isOpen open=this.open close=this.close Dialog=(component DialogElement open=@open onClose=this.handleClose register=this.register))}}\n  ", {
      strictMode: true,
      scope: () => ({
        hash,
        DialogElement
      })
    }), this);
  }
  static {
    g(this.prototype, "_isOpen", [localCopy('args.open')]);
  }
  #_isOpen = (i(this, "_isOpen"), void 0);
  get isOpen() {
    /**
    * Always fallback to false (closed)
    */
    return this._isOpen ?? false;
  }
  set isOpen(val1) {
    this._isOpen = val1;
  }
  static {
    g(this.prototype, "dialogElement", [tracked]);
  }
  #dialogElement = (i(this, "dialogElement"), void 0);
  register = modifier(element1 => {
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
    (async () => {
      await Promise.resolve();
      this.dialogElement = element1;
    })();
  });
  /**
  * Closes the dialog -- this will throw an error in development if the dialog element was not rendered
  */
  close = () => {
    assert('Cannot call `close` on <Dialog> without rendering the dialog element.', this.dialogElement);
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
    assert('Cannot call `handleDialogClose` on <Dialog> without rendering the dialog element. This is likely a bug in ember-primitives. Please open an issue <3', this.dialogElement);
    this.isOpen = false;
    this.args.onClose?.(this.dialogElement.returnValue);
    // the return value ends up staying... which is annoying
    this.dialogElement.returnValue = '';
  };
  /**
  * Opens the dialog -- this will throw an error in development if the dialog element was not rendered
  */
  open = () => {
    assert('Cannot call `open` on <Dialog> without rendering the dialog element.', this.dialogElement);
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
};
const Modal = ModalDialog;
const Dialog = ModalDialog;

export { Dialog, Modal, ModalDialog as default };
//# sourceMappingURL=dialog.js.map
