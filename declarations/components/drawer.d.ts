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
declare const DrawerElement: TOC<{
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
                focusOnClose: ModifierLike<{
                    Element: HTMLElement;
                }>;
                /**
                 * This is the `<dialog>` element (with some defaults pre-wired).
                 * This is required to be rendered.
                 */
                Drawer: WithBoundArgs<typeof DrawerElement, "onClose" | "register" | "open">;
            }
        ];
    };
}
declare class DrawerDialog extends Component<Signature> {
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
    drawerElement: HTMLDialogElement | undefined;
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
     * Closes the drawer -- this will throw an error in development if the drawer element was not rendered
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
     * Opens the drawer -- this will throw an error in development if the drawer element was not rendered
     */
    open: () => void;
}
export declare const Drawer: typeof DrawerDialog;
export default DrawerDialog;
//# sourceMappingURL=drawer.d.ts.map