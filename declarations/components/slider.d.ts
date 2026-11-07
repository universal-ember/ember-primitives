import "./slider.css";
import Component from "@glimmer/component";
import { SliderStore, type SliderThumb, type StyleString } from "./slider/store.ts";
import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { WithBoundArgs } from "@glint/template";
export type { SliderThumb };
export interface Signature {
    Element: HTMLSpanElement;
    Args: {
        /**
         * The current value(s) of the slider.
         * For single value slider, pass a single number.
         * For range slider, pass an array of numbers [min, max].
         */
        value?: number | number[];
        /**
         * The minimum value of the slider.
         * Defaults to 0.
         */
        min?: number;
        /**
         * The maximum value of the slider.
         * Defaults to 100.
         */
        max?: number;
        /**
         * The stepping interval.
         *
         * When passed a number, the slider moves in fixed increments.
         * When passed an array of numbers, the slider snaps to those discrete values.
         * Defaults to 1.
         */
        step?: number | number[];
        /**
         * The orientation of the slider.
         * Defaults to 'horizontal'.
         */
        orientation?: "horizontal" | "vertical";
        /**
         * Whether the slider is disabled.
         */
        disabled?: boolean;
        /**
         * Callback when the value changes during dragging.
         */
        onValueChange?: (value: number | number[]) => void;
        /**
         * Callback when the value is committed (after dragging ends).
         */
        onValueCommit?: (value: number | number[]) => void;
    };
    Blocks: {
        default: [
            {
                /**
                 * The track element - the rail along which the thumb moves
                 */
                Track: typeof Track;
                /**
                 * The range element - the filled portion of the track
                 */
                Range: WithBoundArgs<typeof Range, "rangeStyle">;
                /**
                 * The thumb element - the draggable handle(s)
                 */
                Thumb: WithBoundArgs<typeof ThumbComponent, "store">;
                /**
                 * The current value(s)
                 */
                values: number[];
                /**
                 * The tick values, if any.
                 */
                tickValues: number[] | null;
                /**
                 * A stable list of thumbs to iterate over.
                 * Prefer this over iterating `values` directly to avoid DOM churn during dragging.
                 */
                thumbs: SliderThumb[];
                /**
                 * The minimum value
                 */
                min: number;
                /**
                 * The maximum value
                 */
                max: number;
                /**
                 * The step value
                 */
                step: number;
            }
        ];
    };
}
interface TrackSignature {
    Element: HTMLSpanElement;
    Args: Record<string, never>;
    Blocks: {
        default: [];
    };
}
declare const Track: TOC<TrackSignature>;
interface RangeSignature {
    Element: HTMLSpanElement;
    Args: {
        rangeStyle: StyleString;
    };
}
declare const Range: TOC<RangeSignature>;
declare class ThumbComponent extends Component<{
    /**
     * `...attributes` land on the invisible native input, which is the
     * interactive element (pass `aria-label` / `aria-labelledby` here).
     */
    Element: HTMLInputElement;
    Args: {
        store: SliderStore;
        /**
         * Optional convenience: pass the full thumb object instead of `@value` + `@index`.
         */
        thumb?: SliderThumb;
        value?: number;
        index?: number;
    };
    Blocks: {
        /**
         * Rendered inside the visual thumb — useful for tooltips / value labels.
         */
        default: [];
    };
}> {
    get index(): number;
    get value(): number;
    /** With tick values the input holds an index, which means nothing when read aloud. */
    get valueText(): string | undefined;
    get isActive(): boolean;
    get positionStyle(): import("@ember/-internals/glimmer/lib/utils/string").TrustedHTML;
    private readValue;
    private onInput;
    private onChange;
    private onPointerUp;
    private onGotPointerCapture;
    private onFocus;
}
export declare class Slider extends Component<Signature> {
    store: SliderStore;
    constructor(owner: Owner, args: Signature["Args"]);
}
export default Slider;
//# sourceMappingURL=slider.d.ts.map