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

const DrawerElement = setComponentTemplate(precompileTemplate("<dialog ...attributes {{on \"close\" @onClose}} {{@register open=@open}}>\n  {{yield}}\n</dialog>", {
  strictMode: true,
  scope: () => ({
    on
  })
}), templateOnly());
class DrawerDialog extends Component {
  static {
    setComponentTemplate(precompileTemplate("{{yield (hash isOpen=this.isOpen open=this.open close=this.close focusOnClose=this.refocus Drawer=(component DrawerElement open=@open onClose=this.handleClose register=this.register))}}", {
      strictMode: true,
      scope: () => ({
        hash,
        DrawerElement
      })
    }), this);
  }
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  static {
    g(this.prototype, "_isOpen", [localCopy("args.open")]);
  }
  #_isOpen = (i(this, "_isOpen"), void 0);
  get isOpen() {
    /**
    * Always fallback to false (closed)
    */
    return this._isOpen ?? false;
  }
  set isOpen(val) {
    this._isOpen = val;
  }
  #lastIsOpen = false;
  refocus = modifier(element => {
    assert(`focusOnClose is only valid on a HTMLElement`, element instanceof HTMLElement);
    if (!this.isOpen && this.#lastIsOpen) {
      element.focus();
    }
    this.#lastIsOpen = this.isOpen;
  });
  static {
    g(this.prototype, "drawerElement", [tracked]);
  }
  #drawerElement = (i(this, "drawerElement"), void 0);
  register = modifier((element, _, {
    open
  }) => {
    /** The `open` attribute shows a non-modal drawer, only `showModal` is modal. */if (open && !element.open) {
      element.showModal();
    } else if (open === false && element.open) {
      element.close();
    }
    /**
    * This is very sad.
    *
    * But we need the element to be 'root state'
    * so that when we read things like "isOpen",
    * when the drawer is finally rendered, all the
    * downstream properties render.
    *
    * This has to be an async / delayed a bit, so that
    * the tracking frame can exit, and we don't infinite loop
    */
    void (async () => {
      await Promise.resolve();
      this.drawerElement = element;
    })();
  });
  /**
  * Closes the drawer -- this will throw an error in development if the drawer element was not rendered
  */
  close = () => {
    assert("Cannot call `close` on <Drawer> without rendering the drawer element.", this.drawerElement);
    /**
    * If the element is already closed, don't run all this again
    */
    if (!this.drawerElement.hasAttribute("open")) {
      return;
    }
    /**
    * removes the `open` attribute
    * handleClose will be called because the drawer has bound the `close` event.
    */
    this.drawerElement.close();
  };
  /**
  * @internal
  *
  * handles the <dialog> element's native close behavior.
  * listened to via addEventListener('close', ...);
  */
  handleClose = () => {
    assert("Cannot call `handleClose` on <Drawer> without rendering the drawer element. This is likely a bug in ember-primitives. Please open an issue <3", this.drawerElement);
    this.isOpen = false;
    this.args.onClose?.(this.drawerElement.returnValue);
    // the return value ends up staying... which is annoying
    this.drawerElement.returnValue = "";
  };
  /**
  * Opens the drawer -- this will throw an error in development if the drawer element was not rendered
  */
  open = () => {
    assert("Cannot call `open` on <Drawer> without rendering the drawer element.", this.drawerElement);
    /**
    * If the element is already open, don't run all this again
    */
    if (this.drawerElement.hasAttribute("open")) {
      return;
    }
    /**
    * adds the `open` attribute
    */
    this.drawerElement.showModal();
    this.isOpen = true;
  };
}
const Drawer = DrawerDialog;

export { Drawer, DrawerDialog as default };
//# sourceMappingURL=drawer.js.map
