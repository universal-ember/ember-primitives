import Component from '@glimmer/component';
import type { TOC } from '@ember/component/template-only';
import type { ModifierLike, WithBoundArgs } from '@glint/template';
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
        register: ModifierLike<{
            Element: HTMLDialogElement;
        }>;
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
                 * This is the `<dialog>` element (with some defaults pre-wired).
                 * This is required to be rendered.
                 */
                Dialog: WithBoundArgs<typeof DialogElement, 'onClose' | 'register' | 'open'>;
            }
        ];
    };
}
declare class ModalDialog extends Component<Signature> {
    _isOpen: boolean;
    get isOpen(): boolean;
    set isOpen(val: boolean);
    dialogElement: HTMLDialogElement | undefined;
    register: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLDialogElement;
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
export declare const Modal: typeof ModalDialog;
export declare const Dialog: typeof ModalDialog;
export default ModalDialog;
//# sourceMappingURL=dialog.d.ts.map