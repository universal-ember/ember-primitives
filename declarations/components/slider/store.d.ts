import { htmlSafe } from '@ember/template';
/**
 * `style` attribute values need to be SafeStrings to avoid Ember's
 * style-binding warning.
 */
export type StyleString = ReturnType<typeof htmlSafe>;
export interface SliderStoreArgs {
    value?: number | number[];
    min?: number;
    max?: number;
    step?: number | number[];
    orientation?: 'horizontal' | 'vertical';
    disabled?: boolean;
    onValueChange?: (value: number | number[]) => void;
    onValueCommit?: (value: number | number[]) => void;
}
export interface SliderThumb {
    index: number;
    value: number;
    /**
     * The value to pass to `<input type="range">`.
     *
     * When using an array `step`, this is the internal index (0..n-1).
     * Otherwise it's the same as `value`.
     */
    inputValue: number;
    percent: number;
    active: boolean;
    /**
     * Inline style positioning this thumb along the track
     * (`left: x%` or `bottom: x%`, depending on orientation).
     */
    positionStyle: StyleString;
}
export declare class SliderStore {
    #private;
    activeThumbIndex: number | null;
    constructor(getArgs: () => SliderStoreArgs);
    get min(): number;
    get max(): number;
    get step(): number;
    get tickValues(): number[] | null;
    get orientation(): 'horizontal' | 'vertical';
    get disabled(): boolean;
    get internalMin(): number;
    get internalMax(): number;
    get internalStep(): number;
    get internalValues(): number[];
    outputValuesFromInternal(internalValues: number[]): number[];
    get values(): number[];
    get thumbs(): SliderThumb[];
    get thumbPercents(): number[];
    get isMulti(): boolean;
    thumbPositionStyle: (percent: number) => StyleString;
    get rangeStyle(): StyleString;
    updateValue: (newValues: number[]) => void;
    commitValue: (newValues: number[]) => void;
    coerceOutput(values: number[]): number | number[];
    handleThumbInput: (index: number, value: number) => void;
    handleThumbChange: (index: number, value: number) => void;
    handleThumbActivate: (index: number) => void;
    defaultThumbLabel: (index: number) => string;
}
//# sourceMappingURL=store.d.ts.map