import Component from "@glimmer/component";
import { RatingRange } from './range';
import { Stars } from './stars';
import type { ComponentIcons, StringIcons } from "./public-types.ts";
import type { WithBoundArgs } from "@glint/template";
export interface Signature {
    Element: HTMLFieldSetElement;
    Args: (ComponentIcons | StringIcons) & {
        /**
         * The number of stars/whichever-icon to show
         *
         * Defaults to 5
         */
        max?: number;
        /**
         * The current number of stars/whichever-icon to show as selected
         *
         * Defaults to 0
         */
        value?: number;
        /**
         * Prevents click events on the icons and sets aria-readonly.
         *
         * Also sets data-readonly=true on the wrapping element
         */
        readonly?: boolean;
        /**
         * Toggles the ability to interact with the rating component.
         * When `true` (the default), the Rating component can be as a form input
         * to gather user feedback.
         *
         * When false, only the `@value` will be shown, and it cannot be changed.
         */
        interactive?: boolean;
        /**
         * Callback when the selected rating changes.
         * Can include half-ratings if the iconHalf argument is passed.
         */
        onChange?: (value: number) => void;
    };
    Blocks: {
        default: [
            rating: {
                /**
                 * The maximum rating
                 */
                max: number;
                /**
                 * The maxium rating
                 */
                total: number;
                /**
                 * The current rating
                 */
                value: number;
                /**
                 * The name shared by the field group
                 */
                name: string;
                /**
                 * If the rating can be changed
                 */
                isReadonly: boolean;
                /**
                 * If the rating can be changed
                 */
                isChangeable: boolean;
                /**
                 * The stars / items radio group
                 */
                Stars: WithBoundArgs<typeof Stars, "stars" | "icon" | "isReadonly" | "name" | "total" | "currentValue">;
                /**
                 * Input range for adjusting the rating via fractional means
                 */
                Range: WithBoundArgs<typeof RatingRange, "max" | "value" | "name" | "handleChange">;
            }
        ];
        label: [
            state: {
                /**
                 * The current rating
                 */
                value: number;
                /**
                 * The maximum rating
                 */
                total: number;
            }
        ];
    };
}
export declare class Rating extends Component<Signature> {
    name: string;
    get icon(): string | import("@glint/template").ComponentLike<{
        Element: HTMLElement;
        Args: {
            isSelected: boolean;
            percentSelected: number;
            value: number;
            readonly: boolean;
        };
    }>;
    get isInteractive(): boolean;
    get isChangeable(): boolean;
    get isReadonly(): boolean;
    get needsDescription(): boolean;
}
//# sourceMappingURL=rating.d.ts.map