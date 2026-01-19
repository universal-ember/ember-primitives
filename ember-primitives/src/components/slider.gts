import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
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
        Thumb: WithBoundArgs<
          typeof ThumbComponent,
          "min" | "max" | "step" | "disabled" | "onInput" | "onChange" | "onActivate"
        >;
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
      },
    ];
  };
}

export interface SliderThumb {
  index: number;
  value: number;
  /**
   * The value to pass to `<input type="range">`.
   *
   * When using an array `@step`, this is the internal index
   * (0..n-1). Otherwise it's the same as `value`.
   */
  inputValue: number;
  percent: number;
  active: boolean;
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

function normalizeTickValues(values: number[]): number[] {
  const uniques = new Set<number>();

  for (const value of values) {
    if (Number.isFinite(value)) uniques.add(value);
  }

  return Array.from(uniques).sort((a, b) => a - b);
}

function findNearestIndex(values: number[], target: number): number {
  if (values.length === 0) return 0;

  const first = values[0];

  if (first === undefined) return 0;

  let nearestIndex = 0;
  let nearestDistance = Math.abs(first - target);

  for (let index = 1; index < values.length; index++) {
    const candidate = values[index];

    if (candidate === undefined) continue;

    const distance = Math.abs(candidate - target);

    if (distance < nearestDistance) {
      nearestIndex = index;
      nearestDistance = distance;
    }
  }

  return nearestIndex;
}

interface TrackSignature {
  Element: HTMLSpanElement;
  Args: Record<string, never>;
  Blocks: {
    default: [];
  };
}

const Track: TOC<TrackSignature> = <template>
  <span ...attributes class="ember-primitives__slider__track">
    {{yield}}
  </span>
</template>;

interface RangeSignature {
  Element: HTMLSpanElement;
  Args: {
    rangeStyle: string;
  };
}

const Range: TOC<RangeSignature> = <template>
  <span ...attributes class="ember-primitives__slider__range" style={{@rangeStyle}} />
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
    onInput: (index: number, value: number) => void;
    onChange: (index: number, value: number) => void;
    onActivate: (index: number) => void;
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
    this.args.onActivate(this.args.index);
    this.args.onInput(this.args.index, this.readValue(event));
  };

  private onChange = (event: Event) => {
    this.args.onActivate(this.args.index);
    this.args.onChange(this.args.index, this.readValue(event));
  };

  private onPointerUp = () => {
    this.args.onActivate(this.args.index);
  };

  private onGotPointerCapture = () => {
    this.args.onActivate(this.args.index);
  };

  private onFocus = () => {
    this.args.onActivate(this.args.index);
  };

  <template>
    <input
      ...attributes
      class="ember-primitives__slider__thumb"
      type="range"
      min={{@min}}
      max={{@max}}
      step={{@step}}
      value={{@value}}
      disabled={{@disabled}}
      {{on "gotpointercapture" this.onGotPointerCapture}}
      {{on "pointerup" this.onPointerUp}}
      {{on "focus" this.onFocus}}
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

  get inputValue(): number {
    const ticks = this.slider.tickValues;

    if (!ticks) return this.value;

    return clamp(findNearestIndex(ticks, this.value), 0, Math.max(0, ticks.length - 1));
  }

  get percent(): number {
    return this.slider.thumbPercents[this.index] ?? 0;
  }

  get active(): boolean {
    return this.slider.activeThumbIndex === this.index;
  }
}

export class Slider extends Component<Signature> {
  private thumbStates: ThumbState[] = [];

  @tracked activeThumbIndex: number | null = null;

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
    return typeof this.args.step === "number" ? this.args.step : DEFAULT_STEP;
  }

  get tickValues(): number[] | null {
    const fromStep = Array.isArray(this.args.step) ? this.args.step : undefined;
    const raw = fromStep;

    if (!raw) return null;

    const normalized = normalizeTickValues(raw);

    return normalized.length === 0 ? null : normalized;
  }

  get orientation(): "horizontal" | "vertical" {
    return this.args.orientation ?? "horizontal";
  }

  get rootClass(): string {
    const classes = ["ember-primitives__slider", `ember-primitives__slider--${this.orientation}`];

    if (this.disabled) classes.push("ember-primitives__slider--disabled");

    return classes.join(" ");
  }

  private get internalMin(): number {
    const ticks = this.tickValues;

    if (ticks) return 0;

    return this.min;
  }

  private get internalMax(): number {
    const ticks = this.tickValues;

    if (ticks) return Math.max(0, ticks.length - 1);

    return this.max;
  }

  private get internalStep(): number {
    const ticks = this.tickValues;

    if (ticks) return 1;

    return this.step;
  }

  private get internalValues(): number[] {
    const ticks = this.tickValues;
    const normalized = Array.isArray(this.args.value)
      ? (this.args.value.length === 0
          ? [ticks?.[0] ?? this.min]
          : this.args.value)
      : [this.args.value ?? (ticks?.[0] ?? this.min)];

    if (ticks) {
      return normalized.map((v) => {
        const index = findNearestIndex(ticks, v);

        return clamp(index, this.internalMin, this.internalMax);
      });
    }

    return normalized.map((v) => clamp(roundToStep(v, this.step), this.min, this.max));
  }

  private outputValuesFromInternal(internalValues: number[]): number[] {
    const ticks = this.tickValues;

    if (!ticks) return internalValues;

    return internalValues.map((internal) => {
      const index = clamp(Math.round(internal), 0, ticks.length - 1);

      return ticks[index] ?? ticks[0] ?? this.min;
    });
  }

  get values(): number[] {
    return this.outputValuesFromInternal(this.internalValues);
  }

  get thumbs(): SliderThumb[] {
    this.ensureThumbCount(this.internalValues.length);

    return this.thumbStates;
  }

  get thumbPercents(): number[] {
    return this.internalValues.map((value) => getPercentage(value, this.internalMin, this.internalMax));
  }

  get disabled(): boolean {
    return this.args.disabled ?? false;
  }

  get rangeStyle(): string {
    const internalValues = this.internalValues;

    // For a single-thumb slider, the "range" should fill from the start to the
    // thumb. For multi-thumb, it fills between the min/max thumbs.
    const internalRangeMin = internalValues.length <= 1 ? this.internalMin : Math.min(...internalValues);
    const internalRangeMax = internalValues[0] === undefined ? this.internalMin : Math.max(...internalValues);
    const startPercent = getPercentage(internalRangeMin, this.internalMin, this.internalMax);
    const endPercent = getPercentage(internalRangeMax, this.internalMin, this.internalMax);

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

  private ensureThumbCount(count: number) {
    if (count === this.thumbStates.length) return;

    if (count < this.thumbStates.length) {
      this.thumbStates = this.thumbStates.slice(0, count);

      return;
    }

    const startIndex = this.thumbStates.length;

    for (let index = startIndex; index < count; index++) {
      this.thumbStates.push(new ThumbState(this, index));
    }
  }

  private applyThumbInternalValue(index: number, rawValue: number): number[] {
    const nextValues = [...this.internalValues];
    const stepped = clamp(roundToStep(rawValue, this.internalStep), this.internalMin, this.internalMax);

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

    const internalValues = this.applyThumbInternalValue(index, value);
    const newValues = this.outputValuesFromInternal(internalValues);

    this.updateValue(newValues);
  };

  private handleThumbChange = (index: number, value: number) => {
    if (this.disabled) return;

    const internalValues = this.applyThumbInternalValue(index, value);
    const newValues = this.outputValuesFromInternal(internalValues);

    this.updateValue(newValues);
    this.commitValue(newValues);
  };

  private handleThumbActivate = (index: number) => {
    this.activeThumbIndex = index;
  };

  private defaultThumbLabel(index: number): string {
    const count = this.internalValues.length;

    if (count <= 1) return "Value";
    if (count === 2) return index === 0 ? "Minimum" : "Maximum";

    return `Value ${index + 1}`;
  }

  <template>
    <span
      ...attributes
      class={{this.rootClass}}
    >
      {{#if (has-block)}}
        {{yield
          (hash
            Track=Track
            Range=(component Range rangeStyle=this.rangeStyle)
            Thumb=(component
              ThumbComponent
              min=this.internalMin
              max=this.internalMax
              step=this.internalStep
              disabled=this.disabled
              onInput=this.handleThumbInput
              onChange=this.handleThumbChange
              onActivate=this.handleThumbActivate
            )
            values=this.values
            tickValues=this.tickValues
            thumbs=this.thumbs
            min=this.min
            max=this.max
            step=this.step
          )
        }}
      {{else}}
        <Track>
          <Range @rangeStyle={{this.rangeStyle}} />

          {{#each this.thumbs as |thumb|}}
            <ThumbComponent
              @value={{thumb.inputValue}}
              @index={{thumb.index}}
              @min={{this.internalMin}}
              @max={{this.internalMax}}
              @step={{this.internalStep}}
              @disabled={{this.disabled}}
              @onInput={{this.handleThumbInput}}
              @onChange={{this.handleThumbChange}}
              @onActivate={{this.handleThumbActivate}}
              aria-label={{this.defaultThumbLabel thumb.index}}
            />
          {{/each}}
        </Track>
      {{/if}}
    </span>
  </template>
}

export default Slider;
