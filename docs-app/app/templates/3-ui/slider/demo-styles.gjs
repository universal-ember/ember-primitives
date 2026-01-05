import 'ember-primitives';

/**
 * Shared, style-only component for Slider demos.
 *
 * Each demo is wrapped in <Shadowed>, so these styles won't leak.
 */
export const SliderDemoStyles = <template>
  <span hidden aria-hidden="true"></span>
  <style>
    .ember-primitives__slider {
      --slider-width: 100%;
      --slider-hit-area: 32px;
      --thumb-size: 18px;
      --slider-v-height: 140px;
      --slider-v-width: 24px;

      position: relative;
      display: flex;
      align-items: center;
      width: var(--slider-width);
      height: var(--slider-hit-area);
    }

    .ember-primitives__slider__track {
      position: relative;
      flex: 1;
      height: 4px;
      background: #ddd;
      border-radius: 2px;
      overflow: visible;
    }

    .ember-primitives__slider__range {
      position: absolute;
      height: 100%;
      background: #1a73e8;
      border-radius: 2px;
    }

    .thumb-input {
      position: absolute;
      left: 0;
      right: 0;
      top: 50%;
      transform: translateY(-50%);
      width: 100%;
      height: var(--slider-hit-area);
      margin: 0;
      opacity: 0;
      appearance: none;
      background: transparent;
      cursor: pointer;
      z-index: 1;

      /*
        Multi-thumb sliders overlap multiple full-width range inputs.
        If the inputs receive pointer events, the top-most input steals
        clicks/drags from other thumbs.

        Disable pointer events on the track-sized input area and re-enable
        them on the thumb pseudo-element.
      */
      pointer-events: none;
    }

    .thumb-input::-webkit-slider-thumb {
      pointer-events: auto;
      cursor: pointer;
    }

    .thumb-input::-moz-range-thumb {
      pointer-events: auto;
      cursor: pointer;
    }

    .thumb-input.is-active {
      z-index: 10;
    }

    .thumb-input:disabled {
      cursor: not-allowed;
    }

    .thumb {
      position: absolute;
      top: 50%;
      --thumb-scale: 1;
      transform-origin: 50% 50%;
      transform: translate(-50%, -50%) scale(var(--thumb-scale));
      width: var(--thumb-size);
      height: var(--thumb-size);
      background: #1a73e8;
      border: 2px solid white;
      border-radius: 999px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      z-index: 2;
      pointer-events: none;
      transition: transform 120ms ease;
    }

    .thumb-input:not(:disabled):hover + .thumb,
    .thumb-input:not(:disabled):focus-visible + .thumb {
      --thumb-scale: 1.45;
    }

    .thumb.is-active {
      z-index: 11;
    }

    .thumb.is-disabled {
      opacity: 0.5;
    }

    .thumb-input:focus-visible + .thumb {
      outline: 2px solid #1a73e8;
      outline-offset: 2px;
    }

    .tooltip {
      position: absolute;
      top: 50%;
      transform: translate(-50%, calc(-100% - 16px));
      background: #111;
      color: white;
      font-size: 0.75rem;
      line-height: 1;
      padding: 0.15rem 0.35rem;
      border-radius: 0.25rem;
      white-space: nowrap;
      user-select: none;
      pointer-events: none;
      z-index: 20;
      font-variant-numeric: tabular-nums;
      min-width: 2ch;
      text-align: center;
    }

    .ember-primitives__slider[data-orientation="vertical"] {
      flex-direction: column;
      width: var(--slider-v-width);
      height: var(--slider-v-height);
      margin: 0.5rem 0;
    }

    .ember-primitives__slider[data-orientation="vertical"] .ember-primitives__slider__track {
      width: 4px;
      height: 100%;
    }

    .ember-primitives__slider[data-orientation="vertical"] .ember-primitives__slider__range {
      width: 100%;
      height: auto;
    }

    .ember-primitives__slider[data-orientation="vertical"] .thumb-input {
      left: 0;
      top: 0;
      right: auto;
      bottom: auto;
      width: var(--slider-v-height);
      height: var(--slider-v-width);
      transform: rotate(-90deg) translateX(calc(-1 * var(--slider-v-height))) translateY(-50%);
      transform-origin: left top;
    }

    .ember-primitives__slider[data-orientation="vertical"] .thumb {
      left: 50%;
      top: auto;
      transform: translate(-50%, 50%) scale(var(--thumb-scale));
    }

    .tooltip.tooltip--vertical {
      left: 50%;
      top: auto;
      transform: translate(14px, 50%);
    }
  </style>
</template>;
