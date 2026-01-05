import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

import { modifier as eModifier } from "ember-modifier";
// temp
//  https://github.com/tracked-tools/tracked-toolbox/issues/38
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

import type { TOC } from "@ember/component/template-only";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

const DrawerElement: TOC<{
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
     * Optionally set the open state of the drawer
     * The state will still be managed internally,
     * so this does not need to be a maintained value, but whenever it changes,
     * the drawer element will reflect that change accordingly.
     */
    open?: boolean;
    /**
     * When the drawer is closed, this function will be called
     * and the drawer's `returnValue` will be passed.
     *
     * This can be used to determine which button was clicked to close the drawer
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
         * Represents the open state of the drawer element.
         */
        isOpen: boolean;

        /**
         * Closes the drawer element
         * Will throw an error if `Drawer` is not rendered.
         */
        close: () => void;

        /**
         * Opens the drawer element.
         * Will throw an error if `Drawer` is not rendered.
         */
        open: () => void;

        /**
         * This modifier should be applied to the button that opens the Drawer so that it can be re-focused when the drawer closes.
         *
         * Example:
         *
         * ```gjs
         * <template>
         *   <Drawer as |d|>
         *     <button {{d.focusOnClose}} {{on "click" d.open}}>Open</button>
         *
         *     <d.Drawer>...</d.Drawer>
         *   </Drawer>
         * </template>
         * ```
         */
        focusOnClose: ModifierLike<{ Element: HTMLElement }>;

        /**
         * This is the `<dialog>` element (with some defaults pre-wired).
         * This is required to be rendered.
         */
        Drawer: WithBoundArgs<typeof DrawerElement, "onClose" | "register" | "open">;
      },
    ];
  };
}

class DrawerDialog extends Component<Signature> {
  <template>
    {{yield
      (hash
        isOpen=this.isOpen
        open=this.open
        close=this.close
        focusOnClose=this.refocus
        Drawer=(component DrawerElement open=@open onClose=this.handleClose register=this.register)
      )
    }}
  </template>

  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  @localCopy("args.open") declare _isOpen: boolean;

  get isOpen() {
    /**
     * Always fallback to false (closed)
     */
    return this._isOpen ?? false;
  }
  set isOpen(val: boolean) {
    this._isOpen = val;
  }

  #lastIsOpen = false;
  refocus = eModifier((element) => {
    assert(`focusOnClose is only valid on a HTMLElement`, element instanceof HTMLElement);

    if (!this.isOpen && this.#lastIsOpen) {
      element.focus();
    }

    this.#lastIsOpen = this.isOpen;
  });

  @tracked declare drawerElement: HTMLDialogElement | undefined;

  register = eModifier((element: HTMLDialogElement) => {
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
    assert(
      "Cannot call `close` on <Drawer> without rendering the drawer element.",
      this.drawerElement,
    );

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
    assert(
      "Cannot call `handleDrawerClose` on <Drawer> without rendering the drawer element. This is likely a bug in ember-primitives. Please open an issue <3",
      this.drawerElement,
    );

    this.isOpen = false;
    this.args.onClose?.(this.drawerElement.returnValue);
    // the return value ends up staying... which is annoying
    this.drawerElement.returnValue = "";
  };

  /**
   * Opens the drawer -- this will throw an error in development if the drawer element was not rendered
   */
  open = () => {
    assert(
      "Cannot call `open` on <Drawer> without rendering the drawer element.",
      this.drawerElement,
    );

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

export const Drawer = DrawerDialog;

export default DrawerDialog;
