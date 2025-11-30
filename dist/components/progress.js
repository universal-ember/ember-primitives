
import Component from '@glimmer/component';
import { hash } from '@ember/helper';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

const DEFAULT_MAX = 100;
/**
 * Non-negative, non-NaN, non-Infinite, positive, rational
 */
function isValidProgressNumber(value) {
  if (typeof value !== "number") return false;
  if (!Number.isFinite(value)) return false;
  return value >= 0;
}
function progressState(value, maxValue) {
  return value == null ? "indeterminate" : value === maxValue ? "complete" : "loading";
}
function getMax(userMax) {
  return isValidProgressNumber(userMax) ? userMax : DEFAULT_MAX;
}
function getValue(userValue, maxValue) {
  const max = getMax(maxValue);
  if (!isValidProgressNumber(userValue)) {
    return 0;
  }
  if (userValue > max) {
    return max;
  }
  return userValue;
}
function getValueLabel(value, max) {
  return `${Math.round(value / max * 100)}%`;
}
const Indicator = setComponentTemplate(precompileTemplate("\n  <div ...attributes data-max={{@max}} data-value={{@value}} data-state={{progressState @value @max}} data-percent={{@percent}}>\n    {{yield}}\n  </div>\n", {
  strictMode: true,
  scope: () => ({
    progressState
  })
}), templateOnly());
class Progress extends Component {
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
  static {
    setComponentTemplate(precompileTemplate("\n    <div ...attributes aria-valuemax={{this.max}} aria-valuemin=\"0\" aria-valuenow={{this.value}} aria-valuetext={{this.valueLabel}} role=\"progressbar\" data-value={{this.value}} data-state={{progressState this.value this.max}} data-max={{this.max}} data-min=\"0\" data-percent={{this.percent}}>\n\n      {{yield (hash Indicator=(component Indicator value=this.value max=this.max percent=this.percent) value=this.value percent=this.percent decimal=this.decimal)}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        progressState,
        hash,
        Indicator
      })
    }), this);
  }
}

export { Progress, Progress as default };
//# sourceMappingURL=progress.js.map
