import Component from "@glimmer/component";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";

import { SliderStore, type SliderThumb } from "./slider/store.ts";

import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { WithBoundArgs } from "@glint/template";

export type { SliderThumb };

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
          "store"
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
    store: SliderStore;
    /**
     * Optional convenience: pass the full thumb object instead of `@value` + `@index`.
     */
    thumb?: SliderThumb;
    value?: number;
    index?: number;
  };
}> {
  get index(): number {
    return this.args.thumb?.index ?? this.args.index ?? 0;
  }

  get value(): number {
    // When using tick values, the `input` needs the internal index.
    return this.args.thumb?.inputValue ?? this.args.value ?? this.args.store.internalMin;
  }

  private readValue(event: Event): number {
    // In docs live previews the component may run in an iframe/shadow realm,
    // where `instanceof HTMLInputElement` is not reliable. `currentTarget` is
    // the element the handler is attached to.
    const el = event.currentTarget as { value?: string } | null;
    const raw = el?.value;
    const parsed = raw === undefined ? NaN : Number.parseFloat(raw);

    return Number.isFinite(parsed) ? parsed : this.value;
  }

  private onInput = (event: Event) => {
    this.args.store.handleThumbActivate(this.index);
    this.args.store.handleThumbInput(this.index, this.readValue(event));
  };

  private onChange = (event: Event) => {
    this.args.store.handleThumbActivate(this.index);
    this.args.store.handleThumbChange(this.index, this.readValue(event));
  };

  private onPointerUp = () => {
    this.args.store.handleThumbActivate(this.index);
  };

  private onGotPointerCapture = () => {
    this.args.store.handleThumbActivate(this.index);
  };

  private onFocus = () => {
    this.args.store.handleThumbActivate(this.index);
  };

  <template>
    <input
      ...attributes
      class="ember-primitives__slider__thumb"
      type="range"
      min={{@store.internalMin}}
      max={{@store.internalMax}}
      step={{@store.internalStep}}
      value={{this.value}}
      disabled={{@store.disabled}}
      {{on "gotpointercapture" this.onGotPointerCapture}}
      {{on "pointerup" this.onPointerUp}}
      {{on "focus" this.onFocus}}
      {{on "input" this.onInput}}
      {{on "change" this.onChange}}
    />
  </template>
}

export class Slider extends Component<Signature> {
  store: SliderStore;

  constructor(owner: Owner, args: Signature["Args"]) {
    super(owner, args);

    this.store = new SliderStore(() => this.args);
  }

  <template>
    <span
      ...attributes
      class="ember-primitives__slider"
      data-orientation={{this.store.orientation}}
      data-disabled={{if this.store.disabled ""}}
    >
      {{#if (has-block)}}
        {{yield
          (hash
            Track=Track
            Range=(component Range rangeStyle=this.store.rangeStyle)
            Thumb=(component
              ThumbComponent
              store=this.store
            )
            values=this.store.values
            tickValues=this.store.tickValues
            thumbs=this.store.thumbs
            min=this.store.min
            max=this.store.max
            step=this.store.step
          )
        }}
      {{else}}
        <Track>
          <Range @rangeStyle={{this.store.rangeStyle}} />

          {{#each this.store.thumbs as |thumb|}}
            <ThumbComponent
              @store={{this.store}}
              @thumb={{thumb}}
              aria-label={{this.store.defaultThumbLabel thumb.index}}
            />
          {{/each}}
        </Track>
      {{/if}}
    </span>
  </template>
}

export default Slider;
