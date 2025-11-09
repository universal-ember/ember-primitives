
import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { hash } from '@ember/helper';
import { localCopy } from 'tracked-toolbox';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i, n } from 'decorator-transforms/runtime';

class RatingState extends Component {
  static {
    g(this.prototype, "_value", [localCopy("args.value")]);
  }
  #_value = (i(this, "_value"), void 0); // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  get value() {
    return this._value ?? 0;
  }
  get stars() {
    return Array.from({
      length: this.args.max ?? 5
    }, (_, index) => index + 1);
  }
  static {
    n(this.prototype, "stars", [cached]);
  }
  setRating = value => {
    if (this.args.readonly) {
      return;
    }
    if (value === this._value) {
      this._value = 0;
    } else {
      this._value = value;
    }
    this.args.onChange?.(value);
  };
  setFromString = value => {
    assert("[BUG]: value from input must be a string.", typeof value === "string");
    const num = parseFloat(value);
    if (isNaN(num)) {
      // something went wrong.
      // Since we're using event delegation,
      // this could be from an unrelated input
      return;
    }
    this.setRating(num);
  };
  /**
  * Click events are captured by
  * - radio changes (mouse and keyboard)
  *   - but only range clicks
  */
  handleClick = event => {
    // Since we're doing event delegation on a click, we want to make sure
    // we don't do anything on other elements
    const isValid = event.target instanceof HTMLInputElement && event.target.name === this.args.name && event.target.type === "radio";
    if (!isValid) return;
    const selected = event.target?.value;
    this.setFromString(selected);
  };
  /**
  * Only attached to a range element, if present.
  * Range elements don't fire click events on keyboard usage, like radios do
  */
  handleChange = event => {
    const isValid = event.target !== null && "value" in event.target;
    if (!isValid) return;
    this.setFromString(event.target.value);
  };
  static {
    setComponentTemplate(precompileTemplate("\n    {{yield (hash stars=this.stars total=this.stars.length handleClick=this.handleClick handleChange=this.handleChange setRating=this.setRating value=this.value) (hash total=this.stars.length value=this.value)}}\n  ", {
      strictMode: true,
      scope: () => ({
        hash
      })
    }), this);
  }
}

export { RatingState };
//# sourceMappingURL=state.js.map
