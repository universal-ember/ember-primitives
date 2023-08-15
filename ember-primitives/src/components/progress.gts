import Component from '@glimmer/component';
import { hash } from '@ember/helper';

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
  Blocks: {default: [{
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
  }]}
}

type ProgressState = 'indeterminate' | 'complete' | 'loading';

const DEFAULT_MAX = 100;

/**
  * Non-negative, non-NaN, non-Infinite, positive, rational
  */
function isValidProgressNumber(value: number | undefined | null): value is number {
  if (typeof value !== 'number') return false;
  if (!Number.isFinite(value)) return false;

  return value >= 0;
}

function progressState(value: number | undefined | null, maxValue: number): ProgressState {
  return value == null ? 'indeterminate' : value === maxValue ? 'complete' : 'loading';
}

function getMax(userMax: number | undefined | null): number {
  return isValidProgressNumber(userMax) ? userMax : DEFAULT_MAX;
}

function getValue(userValue: number | undefined | null, maxValue: number): number {
  let max = getMax(maxValue)

  if (!isValidProgressNumber(userValue)) {
    return 0;
  }

  if (userValue > max) {
    return max;
  }

  return userValue;
}


function getValueLabel(value: number, max: number) {
  return `${Math.round((value / max) * 100)}%`;
}

const Indicator: TOC<{
  Element: HTMLDivElement;
  Args: { max: number; value: number; percent: number; },
  Blocks: {default:[]}
}> = <template>
  <div
    ...attributes
    data-max={{@max}}
    data-value={{@value}}
    data-state={{progressState @value @max}}
    data-percent={{@percent}}
  >
    {{yield}}
  </div>
</template>;


export class Progress extends Component<Signature> {
  get max() {
    return getMax(this.args.max);
  }

  get value() {
    return getValue(this.args.value, this.max);
  }

  get valueLabel() {
    return getValueLabel(this.value, this.max);
  }

  get decimal() {
    return this.value / this.max;
  }

  get percent() {
    return Math.round(this.decimal * 100 * 100) / 100;
  }

  <template>
    <div
      ...attributes
      aria-valuemax={{this.max}}
      aria-valuemin="0"
      aria-valuenow={{this.value}}
      aria-valuetext={{this.valueLabel}}
      role="progressbar"
      data-value={{this.value}}
      data-state={{progressState this.value this.max}}
      data-max={{this.max}}
      data-min="0"
      data-percent={{this.percent}}
    >

      {{! @glint-ignore }}
      {{yield (hash
         Indicator=(component Indicator value=this.value max=this.max percent=this.percent)
         value=this.value
         percent=this.percent
         decimal=this.decimal
      )}}
    </div>
  </template>
}

export default Progress;
