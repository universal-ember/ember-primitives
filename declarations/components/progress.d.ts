import Component from '@glimmer/component';
import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';
export interface Signature {
    Element: HTMLDivElement;
    Args: {
        /**
         * The current progress
         * This may be less than 0 or more than `max`,
         * but the resolved value (managed internally, and yielded out)
         * does not exceed the range [0, max]
         */
        value: number;
        /**
         * The max value, defaults to 100
         */
        max?: number;
    };
    Blocks: {
        default: [
            {
                /**
                 * The indicator element with some state applied.
                 * This can be used to style the progress of bar.
                 */
                Indicator: WithBoundArgs<typeof Indicator, 'value' | 'max' | 'percent'>;
                /**
                 * The value as a percent of how far along the indicator should be
                 * positioned, between 0 and 100.
                 * Will be rounded to two decimal places.
                 */
                percent: number;
                /**
                 * The value as a percent of how far along the indicator should be positioned,
                 * between 0 and 1
                 */
                decimal: number;
                /**
                 * The resolved value within the limits of the progress bar.
                 */
                value: number;
            }
        ];
    };
}
declare const Indicator: TOC<{
    Element: HTMLDivElement;
    Args: {
        max: number;
        value: number;
        percent: number;
    };
    Blocks: {
        default: [];
    };
}>;
export declare class Progress extends Component<Signature> {
    get max(): number;
    get value(): number;
    get valueLabel(): string;
    get decimal(): number;
    get percent(): number;
}
export default Progress;
//# sourceMappingURL=progress.d.ts.map