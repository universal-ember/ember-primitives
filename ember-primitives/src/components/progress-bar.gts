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
    Indicator: WithBoundArgs<typeof Indicator, 'value' | 'max'>;
    /**
      * The value as a percent of how far along the indicator should be
    * positioned
      */
    percent: number;
    /**
      * The inverse of percent
      */
    negativePercent: number;
    /**
      * The resolved value within the limits of the progress bar.
      */
    value: number;
  }]}
}

type ProgressState = 'indeterminate' | 'complete' | 'loading';

const DEFAULT_MAX = 100;

function progressState(value: number | undefined | null, maxValue: number): ProgressState {
  return value == null ? 'indeterminate' : value === maxValue ? 'complete' : 'loading';
}

function getMax(userMax: number | undefined | null): number {
  return (typeof userMax === 'number' && userMax > 0) ? userMax : DEFAULT_MAX;
}

function getValue(userValue: number | undefined | null, maxValue: number): number {
  let max = getMax(maxValue)

  if (typeof userValue !== 'number') {
    return 0;
  }

  if (userValue < 0) {
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
  Args: { max: number; value: number},
  Blocks: {default:[]}
}> = <template>
  <div
    ...attributes
    data-max={{@max}}
    data-value={{@value}}
    data-state={{progressState @value @max}}
  >
    {{yield}}
  </div>
</template>;


export class ProgressBar extends Component<Signature> {
  get max() {
    return getMax(this.args.max);
  }

  get value() {
    return getValue(this.args.value, this.max);
  }

  get valueLabel() {
    return getValueLabel(this.value, this.max);
  }

  get percent() { return (this.value / this.max) * 100; }
  get negativePercent() { return 0 - this.percent; }

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
    >

      {{! @glint-ignore }}
      {{yield (hash
         Indicator=(component Indicator value=this.value max=this.max)
         percent=this.percent
         negativePercent=this.negativePercent
         value=this.value
      )}}
    </div>
  </template>
}

export default ProgressBar;
