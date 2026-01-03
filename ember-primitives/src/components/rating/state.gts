import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { hash } from "@ember/helper";

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

export class RatingState extends Component<{
  Args: {
    max: number | undefined;
    value: number | undefined;
    step: number | undefined;
    readonly: boolean | undefined;
    name: string;
    onChange?: (value: number) => void;
  };
  Blocks: {
    default: [
      internalApi: {
        stars: number[];
        step: number;
        value: number;
        total: number;
        handleClick: (event: Event) => void;
        handleChange: (event: Event) => void;
        setRating: (num: number) => void;
      },
      publicApi: {
        value: number;
        total: number;
      },
    ];
  };
}> {
  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  @localCopy("args.value") declare _value: number;

  get value() {
    return this._value ?? 0;
  }

  get step() {
    return this.args.step ?? 1;
  }

  get max() {
    return this.args.max ?? 5;
  }

  @cached
  get stars() {
    const result = [];

    // 0 is "none selected"
    let current = 0;

    current += this.step;

    while (current <= this.max) {
      result.push(current);
      current += this.step;
    }

    return result;
  }

  setRating = (value: number) => {
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

  setFromString = (value: unknown) => {
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
  handleClick = (event: Event) => {
    // Since we're doing event delegation on a click, we want to make sure
    // we don't do anything on other elements
    const isValid =
      event.target instanceof HTMLInputElement &&
      event.target.name === this.args.name &&
      event.target.type === "radio";

    if (!isValid) return;

    const selected = event.target?.value;

    this.setFromString(selected);
  };

  /**
   * Only attached to a range element, if present.
   * Range elements don't fire click events on keyboard usage, like radios do
   */
  handleChange = (event: Event) => {
    const isValid = event.target !== null && "value" in event.target;

    if (!isValid) return;

    this.setFromString(event.target.value);
  };

  <template>
    {{yield
      (hash
        stars=this.stars
        total=this.stars.length
        handleClick=this.handleClick
        handleChange=this.handleChange
        setRating=this.setRating
        value=this.value
        step=this.step
      )
      (hash total=this.stars.length value=this.value)
    }}
  </template>
}
