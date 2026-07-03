import 'ember-primitives';

/**
 * Shared, style-only component for Slider demos.
 *
 * Structural CSS (positioning, invisible native inputs, orientation, etc)
 * ships with the <Slider> component itself — everything here is
 * appearance-only: colors, sizes, tooltips.
 *
 * The prelude-less `@scope` block scopes these rules to the style tag's
 * parent element, so each demo's styles stay contained to that demo —
 * no shadow DOM needed. (Shadow DOM previously broke sequential focus
 * navigation in Chrome when demos follow code snippets.)
 */
export const SliderDemoStyles = <template>
  <style>
    @scope {
      .ember-primitives__slider {
        /* the track/range/thumb all derive from currentColor by default */
        color: #1a73e8;
        width: 100%;
        --ember-primitives__slider__thumb-size: 18px;
      }

      .ember-primitives__slider[data-orientation="vertical"] {
        width: auto;
        --ember-primitives__slider__vertical-size: 140px;
      }

      .ember-primitives__slider__track {
        background: #ddd;
      }

      .ember-primitives__slider__thumb {
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        transition: box-shadow 120ms ease;
      }

      .ember-primitives__slider__thumb-input:not(:disabled):hover
        + .ember-primitives__slider__thumb,
      .ember-primitives__slider__thumb-input:not(:disabled):focus-visible
        + .ember-primitives__slider__thumb {
        box-shadow:
          0 2px 4px rgba(0, 0, 0, 0.2),
          0 0 0 5px color-mix(in srgb, currentColor 25%, transparent);
      }

      /* Tooltips are rendered inside the thumb, via <s.Thumb>'s block */
      .tooltip {
        position: absolute;
        bottom: calc(100% + 10px);
        left: 50%;
        translate: -50% 0;
        background: #111;
        color: white;
        font-size: 0.75rem;
        line-height: 1;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        white-space: nowrap;
        user-select: none;
        font-variant-numeric: tabular-nums;
        min-width: 2ch;
        text-align: center;
      }

      .tooltip--vertical {
        bottom: 50%;
        left: calc(100% + 10px);
        translate: 0 50%;
      }

      .meta {
        margin-top: 0.75rem;
        font-variant-numeric: tabular-nums;
        color: #333;
        font-size: 0.9rem;
        text-align: center;
      }
    }
  </style>
</template>;
