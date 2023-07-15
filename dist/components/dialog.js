import templateOnly from '@ember/component/template-only';
import { setComponentTemplate } from '@ember/component';
import { precompileTemplate } from '@ember/template-compilation';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { modifier } from 'ember-modifier';
import { localCopy } from 'tracked-toolbox';

var _dec, _class, _descriptor, _descriptor2;
function _initializerDefineProperty(target, property, descriptor, context) { if (!descriptor) return; Object.defineProperty(target, property, { enumerable: descriptor.enumerable, configurable: descriptor.configurable, writable: descriptor.writable, value: descriptor.initializer ? descriptor.initializer.call(context) : void 0 }); }
function _defineProperty(obj, key, value) { key = _toPropertyKey(key); if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }
function _toPropertyKey(arg) { var key = _toPrimitive(arg, "string"); return typeof key === "symbol" ? key : String(key); }
function _toPrimitive(input, hint) { if (typeof input !== "object" || input === null) return input; var prim = input[Symbol.toPrimitive]; if (prim !== undefined) { var res = prim.call(input, hint || "default"); if (typeof res !== "object") return res; throw new TypeError("@@toPrimitive must return a primitive value."); } return (hint === "string" ? String : Number)(input); }
function _applyDecoratedDescriptor(target, property, decorators, descriptor, context) { var desc = {}; Object.keys(descriptor).forEach(function (key) { desc[key] = descriptor[key]; }); desc.enumerable = !!desc.enumerable; desc.configurable = !!desc.configurable; if ('value' in desc || desc.initializer) { desc.writable = true; } desc = decorators.slice().reverse().reduce(function (desc, decorator) { return decorator(target, property, desc) || desc; }, desc); if (context && desc.initializer !== void 0) { desc.value = desc.initializer ? desc.initializer.call(context) : void 0; desc.initializer = undefined; } if (desc.initializer === void 0) { Object.defineProperty(target, property, desc); desc = null; } return desc; }
const DialogElement = setComponentTemplate(precompileTemplate(`
  <dialog ...attributes open={{@open}} {{on 'close' @onClose}} {{@register}}>
    {{yield}}
  </dialog>
`, {
  strictMode: true,
  scope: () => ({
    on
  })
}), templateOnly("dialog", "DialogElement"));
let ModalDialog = (_dec = localCopy('args.open'), (_class = class ModalDialog extends Component {
  constructor(...args) {
    super(...args);
    _initializerDefineProperty(this, "_isOpen", _descriptor, this);
    _initializerDefineProperty(this, "dialogElement", _descriptor2, this);
    _defineProperty(this, "register", modifier(element => {
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
        this.dialogElement = element;
      })();
    }));
    /**
     * Closes the dialog -- this will throw an error in development if the dialog element was not rendered
     */
    _defineProperty(this, "close", () => {
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
    });
    /**
     * @internal
     *
     * handles the <dialog> element's native close behavior.
     * listened to via addEventListener('close', ...);
     */
    _defineProperty(this, "handleClose", () => {
      assert('Cannot call `handleDialogClose` on <Dialog> without rendering the dialog element. This is likely a bug in ember-primitives. Please open an issue <3', this.dialogElement);
      this.isOpen = false;
      this.args.onClose?.(this.dialogElement.returnValue);
      // the return value ends up staying... which is annoying
      this.dialogElement.returnValue = '';
    });
    /**
     * Opens the dialog -- this will throw an error in development if the dialog element was not rendered
     */
    _defineProperty(this, "open", () => {
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
    });
  }
  get isOpen() {
    /**
     * Always fallback to false (closed)
     */
    return this._isOpen ?? false;
  }
  set isOpen(val) {
    this._isOpen = val;
  }
}, (_descriptor = _applyDecoratedDescriptor(_class.prototype, "_isOpen", [_dec], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
}), _descriptor2 = _applyDecoratedDescriptor(_class.prototype, "dialogElement", [tracked], {
  configurable: true,
  enumerable: true,
  writable: true,
  initializer: null
})), _class));
setComponentTemplate(precompileTemplate(`
    {{yield
      (hash
        isOpen=this.isOpen
        open=this.open
        close=this.close
        Dialog=(component DialogElement open=@open onClose=this.handleClose register=this.register)
      )
    }}
  `, {
  strictMode: true,
  scope: () => ({
    hash,
    DialogElement
  })
}), ModalDialog);
const Modal = ModalDialog;
const Dialog = ModalDialog;

export { Dialog, Modal, ModalDialog as default };
//# sourceMappingURL=dialog.js.map
