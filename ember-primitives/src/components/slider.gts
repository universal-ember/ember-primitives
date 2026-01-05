import Component from "@glimmer/component";
import { fn, hash } from "@ember/helper";
import { on } from "@ember/modifier";
import { tracked } from "@glimmer/tracking";

import { modifier } from "ember-modifier";

import type { TOC } from "@ember/component/template-only";
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
    onValueChange?: (value: number[]) => void;
    /**
     * Callback when the value is committed (after dragging ends).
     */
    onValueCommit?: (value: number[]) => void;
  };
  Blocks: {
    default: [
      {
        /**
         * The track element - the rail along which the thumb moves
         */
        Track: WithBoundArgs<typeof Track, "orientation" | "onTrackRef">;
        /**
         * The range element - the filled portion of the track
         */
        Range: WithBoundArgs<typeof Range, "orientation" | "rangeStyle">;
        /**
         * The thumb element - the draggable handle(s)
         */
        Thumb: WithBoundArgs<
          typeof ThumbComponent,
          "min" | "max" | "step" | "disabled" | "orientation" | "onPointerDown" | "onKeyDown"
        >;
        /**
         * The current value(s)
         */
        values: number[];
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

const DEFAULT_MIN = 0;
const DEFAULT_MAX = 100;
const DEFAULT_STEP = 1;

function normalizeValue(value: number | number[] | undefined): number[] {
  if (value === undefined) return [0];
  if (Array.isArray(value)) return value;
  return [value];
}

function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max);
}

function roundToStep(value: number, step: number): number {
  return Math.round(value / step) * step;
}

function getPercentage(value: number, min: number, max: number): number {
  return ((value - min) / (max - min)) * 100;
}

interface TrackSignature {
  Element: HTMLSpanElement;
  Args: {
    orientation: "horizontal" | "vertical";
    onTrackRef: (element: HTMLElement | null) => void;
  };
  Blocks: {
    default: [];
  };
}

const captureElement = modifier(
  (element: HTMLElement, [callback]: [(element: HTMLElement | null) => void]) => {
    callback(element);
    return () => callback(null);
  },
);

const Track: TOC<TrackSignature> = <template>
  <span
    ...attributes
    data-orientation={{@orientation}}
    role="presentation"
    {{captureElement @onTrackRef}}
  >
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
  <span
    ...attributes
    data-orientation={{@orientation}}
    role="presentation"
    style={{@rangeStyle}}
  />
</template>;

class ThumbComponent extends Component<{
  Element: HTMLSpanElement;
  Args: {
    value: number;
    index: number;
    min: number;
    max: number;
    step: number;
    disabled?: boolean;
    orientation: "horizontal" | "vertical";
    onPointerDown: (index: number, event: PointerEvent) => void;
    onKeyDown: (index: number, event: KeyboardEvent) => void;
  };
}> {
  get thumbStyle(): string {
    const percent = getPercentage(this.args.value, this.args.min, this.args.max);
    if (this.args.orientation === "horizontal") {
      return `left: ${percent}%`;
    } else {
      return `bottom: ${percent}%`;
    }
  }

  <template>
    <span
      role="slider"
      aria-valuemin={{@min}}
      aria-valuemax={{@max}}
      aria-valuenow={{@value}}
      aria-orientation={{@orientation}}
      aria-disabled={{@disabled}}
      data-orientation={{@orientation}}
      data-disabled={{@disabled}}
      tabindex={{if @disabled "-1" "0"}}
      style={{this.thumbStyle}}
      {{on "pointerdown" (fn @onPointerDown @index)}}
      {{on "keydown" (fn @onKeyDown @index)}}
      ...attributes
    />
  </template>
}

export class Slider extends Component<Signature> {
  @tracked private activeThumbIndex: number | null = null;
  @tracked private isDragging = false;
  private trackElement: HTMLElement | null = null;

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
    const normalized = normalizeValue(this.args.value);
    return normalized.map((v) =>
      clamp(roundToStep(v, this.step), this.min, this.max),
    );
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
      this.args.onValueChange(newValues);
    }
  };

  private commitValue = (newValues: number[]) => {
    if (this.args.onValueCommit) {
      this.args.onValueCommit(newValues);
    }
  };

  private onTrackRef = (element: HTMLElement | null) => {
    this.trackElement = element;
  };

  private handlePointerDown = (index: number, event: PointerEvent) => {
    if (this.disabled) return;

    event.preventDefault();
    this.activeThumbIndex = index;
    this.isDragging = true;

    const target = event.currentTarget as HTMLElement;
    target.setPointerCapture(event.pointerId);

    const handlePointerMove = (e: PointerEvent) => {
      this.handlePointerMove(e);
    };

    const handlePointerUp = (e: PointerEvent) => {
      this.isDragging = false;
      this.commitValue(this.values);
      target.releasePointerCapture(e.pointerId);
      target.removeEventListener("pointermove", handlePointerMove);
      target.removeEventListener("pointerup", handlePointerUp);
    };

    target.addEventListener("pointermove", handlePointerMove);
    target.addEventListener("pointerup", handlePointerUp);
  };

  private handlePointerMove = (event: PointerEvent) => {
    if (!this.isDragging || this.activeThumbIndex === null || !this.trackElement)
      return;

    const rect = this.trackElement.getBoundingClientRect();
    let percent: number;

    if (this.orientation === "horizontal") {
      percent = (event.clientX - rect.left) / rect.width;
    } else {
      percent = (rect.bottom - event.clientY) / rect.height;
    }

    const range = this.max - this.min;
    let newValue = this.min + percent * range;
    newValue = clamp(roundToStep(newValue, this.step), this.min, this.max);

    const newValues = [...this.values];
    newValues[this.activeThumbIndex] = newValue;

    this.updateValue(newValues);
  };

  private handleKeyDown = (index: number, event: KeyboardEvent) => {
    if (this.disabled) return;

    const value = this.values[index];
    if (value === undefined) return;

    let newValue = value;

    switch (event.key) {
      case "ArrowLeft":
      case "ArrowDown":
        event.preventDefault();
        newValue = clamp(value - this.step, this.min, this.max);
        break;
      case "ArrowRight":
      case "ArrowUp":
        event.preventDefault();
        newValue = clamp(value + this.step, this.min, this.max);
        break;
      case "Home":
        event.preventDefault();
        newValue = this.min;
        break;
      case "End":
        event.preventDefault();
        newValue = this.max;
        break;
      case "PageDown":
        event.preventDefault();
        newValue = clamp(value - this.step * 10, this.min, this.max);
        break;
      case "PageUp":
        event.preventDefault();
        newValue = clamp(value + this.step * 10, this.min, this.max);
        break;
    }

    if (newValue !== value) {
      const newValues = [...this.values];
      newValues[index] = newValue;
      this.updateValue(newValues);
      this.commitValue(newValues);
    }
  };

  <template>
    <span
      ...attributes
      data-slider
      data-orientation={{this.orientation}}
      data-disabled={{this.disabled}}
    >
      {{yield
        (hash
          Track=(component Track orientation=this.orientation onTrackRef=this.onTrackRef)
          Range=(component Range orientation=this.orientation rangeStyle=this.rangeStyle)
          Thumb=(component
            ThumbComponent
            min=this.min
            max=this.max
            step=this.step
            disabled=this.disabled
            orientation=this.orientation
            onPointerDown=this.handlePointerDown
            onKeyDown=this.handleKeyDown
          )
          values=this.values
          min=this.min
          max=this.max
          step=this.step
        )
      }}
    </span>
  </template>
}

export default Slider;

