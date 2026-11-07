import Component from "@glimmer/component";
import type { TOC } from "@ember/component/template-only";
import type { ModifierLike, WithBoundArgs } from "@glint/template";
interface RegisterSignature {
    Element: HTMLDialogElement;
    Args: {
        Named: {
            open: boolean | undefined;
        };
    };
}
declare const DialogElement: TOC<{
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
        register: ModifierLike<RegisterSignature>;
    };
    Blocks: {
        default: [];
    };
}>;
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
                 * This modifier should be applied to the button that opens the Dialog so that it can be re-focused when the dialog closes.
                 *
                 * Example:
                 *
                 * ```gjs
                 * <template>
                 *   <Modal as |m|>
                 *     <button {{m.focusOnClose}} {{on "click" m.open}}>Open</button>
                 *
                 *     <m.Dialog>...</m.Dialog>
                 *   </Modal>
                 * </template>
                 * ```
                 */
                focusOnClose: ModifierLike<{
                    Element: HTMLElement;
                }>;
                /**
                 * This is the `<dialog>` element (with some defaults pre-wired).
                 * This is required to be rendered.
                 */
                Dialog: WithBoundArgs<typeof DialogElement, "onClose" | "register" | "open">;
            }
        ];
    };
}
declare class ModalDialog extends Component<Signature> {
    #private;
    _isOpen: boolean;
    get isOpen(): boolean;
    set isOpen(val: boolean);
    refocus: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: Element;
    }>;
    dialogElement: HTMLDialogElement | undefined;
    register: import("ember-modifier").FunctionBasedModifier<{
        Element: HTMLDialogElement;
        Args: {
            Named: {
                open: boolean | undefined;
            };
            Positional: [];
        };
    }>;
    /**
     * Closes the dialog -- this will throw an error in development if the dialog element was not rendered
     */
    close: () => void;
    /**
     * @internal
     *
     * handles the <dialog> element's native close behavior.
     * listened to via addEventListener('close', ...);
     */
    handleClose: () => void;
    /**
     * Opens the dialog -- this will throw an error in development if the dialog element was not rendered
     */
    open: () => void;
}
export interface SimpleSignature {
    Element: HTMLDialogElement;
    Blocks: {
        default: [
            {
                /**
                 * Opens the dialog, modally.
                 */
                open: () => void;
                /**
                 * Closes the dialog.
                 */
                close: () => void;
            }
        ];
    };
}
/**
 * A modal `<dialog>` around whatever you put in it, and the two things needed
 * to drive it.
 *
 * ```gjs
 * <Dialog as |d|>
 *   <CommandPalette @onSelect={{d.close}} @onOpen={{d.open}} @hotkey="mod+k" />
 * </Dialog>
 * ```
 *
 * The element is here, so a trigger cannot be: whatever opens this either
 * lives inside it, or is a key combination. For a dialog opened by a button
 * beside it, use `<Modal>`, which hands you the element to place.
 *
 * <kbd>Escape</kbd> closes it and focus returns to whatever opened it, which
 * is the `<dialog>` element's own behaviour. Set `closedby` to change which
 * actions dismiss it.
 */
export declare class Dialog extends Component<SimpleSignature> {
    #private;
    register: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLDialogElement;
    }>;
    /**
     * `showModal` on an open dialog, and `close` on a closed one, are both
     * no-ops per spec, so neither needs guarding here.
     */
    open: () => void;
    close: () => void;
}
export declare const Modal: typeof ModalDialog;
export default ModalDialog;
//# sourceMappingURL=dialog.d.ts.map