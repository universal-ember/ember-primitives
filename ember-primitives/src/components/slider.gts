import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { WithBoundArgs } from "@glint/template";

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
     * Defaults to 1.
     */
    step?: number;
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
        Track: WithBoundArgs<typeof Track, "orientation">;
        /**
         * The range element - the filled portion of the track
         */
        Range: WithBoundArgs<typeof Range, "orientation" | "rangeStyle">;
        /**
         * The thumb element - the draggable handle(s)
         */
        Thumb: WithBoundArgs<
          typeof ThumbComponent,
          "min" | "max" | "step" | "disabled" | "orientation" | "onInput" | "onChange"
        >;
        /**
         * The current value(s)
         */
        values: number[];

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
      },
    ];
  };
}

export interface SliderThumb {
  index: number;
  value: number;
}

const DEFAULT_MIN = 0;
const DEFAULT_MAX = 100;
const DEFAULT_STEP = 1;

function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max);
}

function roundToStep(value: number, step: number): number {
  if (!Number.isFinite(step) || step <= 0) return value;

  return Math.round(value / step) * step;
}

function getPercentage(value: number, min: number, max: number): number {
  const range = max - min;

  if (!Number.isFinite(range) || range === 0) return 0;

  return ((value - min) / range) * 100;
}

interface TrackSignature {
  Element: HTMLSpanElement;
  Args: {
    orientation: "horizontal" | "vertical";
  };
  Blocks: {
    default: [];
  };
}

const Track: TOC<TrackSignature> = <template>
  <span ...attributes data-slider-track data-orientation={{@orientation}}>
    {{yield}}
  </span>
</template>;

interface RangeSignature {
  Element: HTMLSpanElement;
  Args: {
    orientation: "horizontal" | "vertical";
    rangeStyle: string;
  };
}

const Range: TOC<RangeSignature> = <template>
  <span ...attributes data-slider-range data-orientation={{@orientation}} style={{@rangeStyle}} />
</template>;

class ThumbComponent extends Component<{
  Element: HTMLInputElement;
  Args: {
    value: number;
    index: number;
    min: number;
    max: number;
    step: number;
    disabled?: boolean;
    orientation: "horizontal" | "vertical";
    onInput: (index: number, value: number) => void;
    onChange: (index: number, value: number) => void;
  };
}> {
  private readValue(event: Event): number {
    // In docs live previews the component may run in an iframe/shadow realm,
    // where `instanceof HTMLInputElement` is not reliable. `currentTarget` is
    // the element the handler is attached to.
    const el = event.currentTarget as { value?: string } | null;
    const raw = el?.value;
    const parsed = raw === undefined ? NaN : Number.parseFloat(raw);

    return Number.isFinite(parsed) ? parsed : this.args.value;
  }

  private onInput = (event: Event) => {
    this.args.onInput(this.args.index, this.readValue(event));
  };

  private onChange = (event: Event) => {
    this.args.onChange(this.args.index, this.readValue(event));
  };

  <template>
    <input
      ...attributes
      data-slider-thumb
      type="range"
      min={{@min}}
      max={{@max}}
      step={{@step}}
      value={{@value}}
      disabled={{@disabled}}
      data-orientation={{@orientation}}
      data-disabled={{if @disabled "true"}}
      {{on "input" this.onInput}}
      {{on "change" this.onChange}}
    />
  </template>
}

class ThumbState implements SliderThumb {
  constructor(
    private slider: Slider,
    public index: number,
  ) {}

  get value(): number {
    return this.slider.values[this.index] ?? this.slider.min;
  }
}

export class Slider extends Component<Signature> {
  private thumbStates: ThumbState[] = [];

  constructor(owner: Owner, args: Signature["Args"]) {
    super(owner, args);

    const initialCount = Array.isArray(args.value) ? Math.max(1, args.value.length) : 1;

    this.thumbStates = Array.from({ length: initialCount }, (_, index) => new ThumbState(this, index));
  }

  get min(): number {
    return this.args.min ?? DEFAULT_MIN;
  }

  get max(): number {
    return this.args.max ?? DEFAULT_MAX;
  }

  get step(): number {
    return this.args.step ?? DEFAULT_STEP;
  }

  get orientation(): "horizontal" | "vertical" {
    return this.args.orientation ?? "horizontal";
  }

  get values(): number[] {
    const normalized = Array.isArray(this.args.value)
      ? (this.args.value.length === 0 ? [this.min] : this.args.value)
      : [this.args.value ?? this.min];

    return normalized.map((v) => clamp(roundToStep(v, this.step), this.min, this.max));
  }

  get thumbs(): SliderThumb[] {
    return this.thumbStates;
  }

  get disabled(): boolean {
    return this.args.disabled ?? false;
  }

  get rangeStyle(): string {
    const rangeMin = Math.min(...this.values);
    const rangeMax = Math.max(...this.values);
    const startPercent = getPercentage(rangeMin, this.min, this.max);
    const endPercent = getPercentage(rangeMax, this.min, this.max);

    if (this.orientation === "horizontal") {
      return `left: ${startPercent}%; right: ${100 - endPercent}%`;
    } else {
      return `bottom: ${startPercent}%; top: ${100 - endPercent}%`;
    }
  }

  private updateValue = (newValues: number[]) => {
    if (this.args.onValueChange) {
      this.args.onValueChange(this.coerceOutput(newValues));
    }
  };

  private commitValue = (newValues: number[]) => {
    if (this.args.onValueCommit) {
      this.args.onValueCommit(this.coerceOutput(newValues));
    }
  };

  private coerceOutput(values: number[]): number | number[] {
    if (Array.isArray(this.args.value)) return values;

    return values[0] ?? this.min;
  }

  private applyThumbValue(index: number, rawValue: number): number[] {
    const nextValues = [...this.values];
    const stepped = clamp(roundToStep(rawValue, this.step), this.min, this.max);

    let constrained = stepped;

    if (nextValues.length > 1) {
      const prev = nextValues[index - 1];
      const next = nextValues[index + 1];

      if (prev !== undefined) constrained = Math.max(constrained, prev);
      if (next !== undefined) constrained = Math.min(constrained, next);
    }

    nextValues[index] = constrained;

    return nextValues;
  }

  private handleThumbInput = (index: number, value: number) => {
    if (this.disabled) return;

    const newValues = this.applyThumbValue(index, value);

    this.updateValue(newValues);
  };

  private handleThumbChange = (index: number, value: number) => {
    if (this.disabled) return;

    const newValues = this.applyThumbValue(index, value);

    this.updateValue(newValues);
    this.commitValue(newValues);
  };

  <template>
    <span
      ...attributes
      data-slider
      data-orientation={{this.orientation}}
      data-disabled={{if this.disabled "true"}}
    >
      {{yield
        (hash
          Track=(component Track orientation=this.orientation)
          Range=(component Range orientation=this.orientation rangeStyle=this.rangeStyle)
          Thumb=(component
            ThumbComponent
            min=this.min
            max=this.max
            step=this.step
            disabled=this.disabled
            orientation=this.orientation
            onInput=this.handleThumbInput
            onChange=this.handleThumbChange
          )
          values=this.values
          thumbs=this.thumbs
          min=this.min
          max=this.max
          step=this.step
        )
      }}
    </span>
  </template>
}

export default Slider;
