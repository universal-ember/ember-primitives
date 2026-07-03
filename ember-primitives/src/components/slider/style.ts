import { modifier } from 'ember-modifier';

/**
 * Structural styles for <Slider>.
 *
 * These handle the annoying parts of building a custom slider on top of
 * native <input type="range"> elements:
 *   - stretching an invisible native input over the track (so keyboard,
 *     pointer, and assistive-tech behavior all come from the platform)
 *   - letting multiple overlapping inputs coexist (multi-thumb / range
 *     sliders) by routing pointer events through the native thumb only
 *   - vertical orientation (via `writing-mode`, no rotation hacks)
 *   - positioning the visual thumb and keeping the active thumb on top
 *
 * Appearance (colors, exact sizes) is left to the consumer.
 *
 * Everything is wrapped in `@layer ember-primitives`, so *any* unlayered
 * consumer rule overrides these -- regardless of specificity or order.
 *
 * These styles are attached via `document.adoptedStyleSheets` (or the
 * containing ShadowRoot's) rather than a css file, so the component works
 * inside shadow roots, where document-level stylesheets don't reach.
 *
 * Knobs:
 *   --ember-primitives__slider__hit-area         pointer target size (default 24px)
 *   --ember-primitives__slider__thumb-size       visual thumb size (default 16px)
 *   --ember-primitives__slider__track-thickness  rail thickness (default 4px)
 *   --ember-primitives__slider__vertical-size    length of a vertical slider (default 10rem)
 */
const styles = /* css */ `
@layer ember-primitives {
  .ember-primitives__slider {
    position: relative;
    display: flex;
    align-items: center;
    min-height: var(--ember-primitives__slider__hit-area, 24px);
  }

  .ember-primitives__slider[data-orientation="vertical"] {
    flex-direction: column;
    min-height: 0;
    min-width: var(--ember-primitives__slider__hit-area, 24px);
    height: var(--ember-primitives__slider__vertical-size, 10rem);
  }

  .ember-primitives__slider__track {
    position: relative;
    flex: 1;
    height: var(--ember-primitives__slider__track-thickness, 4px);
  }

  .ember-primitives__slider[data-orientation="vertical"] .ember-primitives__slider__track {
    height: auto;
    width: var(--ember-primitives__slider__track-thickness, 4px);
  }

  .ember-primitives__slider__range {
    position: absolute;
    top: 0;
    bottom: 0;
  }

  .ember-primitives__slider[data-orientation="vertical"] .ember-primitives__slider__range {
    top: auto;
    bottom: auto;
    left: 0;
    right: 0;
  }

  /*
    The native input is stretched across the whole track, invisible, and only
    used for interaction. The visual thumb (a sibling) is what users see.
  */
  .ember-primitives__slider__thumb-input {
    position: absolute;
    left: 0;
    top: 50%;
    translate: 0 -50%;
    width: 100%;
    height: var(--ember-primitives__slider__hit-area, 24px);
    margin: 0;
    opacity: 0;
    appearance: none;
    background: transparent;
    cursor: pointer;
  }

  .ember-primitives__slider__thumb-input:disabled {
    cursor: not-allowed;
  }

  .ember-primitives__slider__thumb-input[data-active] {
    z-index: 2;
  }

  /*
    Size the (invisible) native thumb to the hit area, so grabbing "the thumb"
    feels right. These cannot be comma-combined: an unknown pseudo-element
    invalidates the whole selector list in the other engine.
  */
  .ember-primitives__slider__thumb-input::-webkit-slider-thumb {
    appearance: none;
    width: var(--ember-primitives__slider__hit-area, 24px);
    height: var(--ember-primitives__slider__hit-area, 24px);
  }

  .ember-primitives__slider__thumb-input::-moz-range-thumb {
    border: none;
    width: var(--ember-primitives__slider__hit-area, 24px);
    height: var(--ember-primitives__slider__hit-area, 24px);
  }

  /*
    Multi-thumb sliders overlap multiple full-width range inputs. If the
    inputs themselves receive pointer events, the top-most input steals
    clicks/drags from the other thumbs. Disable pointer events on the
    track-sized input and re-enable them on the native thumb only.

    Single-thumb sliders keep the whole input interactive, so clicking
    anywhere on the track jumps to that value.
  */
  .ember-primitives__slider[data-multi] .ember-primitives__slider__thumb-input {
    pointer-events: none;
  }

  .ember-primitives__slider[data-multi] .ember-primitives__slider__thumb-input::-webkit-slider-thumb {
    pointer-events: auto;
  }

  .ember-primitives__slider[data-multi] .ember-primitives__slider__thumb-input::-moz-range-thumb {
    pointer-events: auto;
  }

  /*
    Vertical orientation: modern engines render a native vertical range input
    with \`writing-mode\`. \`direction: rtl\` puts the minimum at the bottom.
  */
  .ember-primitives__slider[data-orientation="vertical"] .ember-primitives__slider__thumb-input {
    writing-mode: vertical-lr;
    direction: rtl;
    top: 0;
    left: 50%;
    translate: -50% 0;
    width: var(--ember-primitives__slider__hit-area, 24px);
    height: 100%;
  }

  /*
    The visual thumb. The component positions it with an inline
    \`left\`/\`bottom\` percentage; centering uses the \`translate\` property
    (not \`transform\`) so consumer hover/active effects like
    \`transform: scale(1.4)\` or \`scale: 1.4\` compose with it instead of
    clobbering it.
  */
  .ember-primitives__slider__thumb {
    position: absolute;
    top: 50%;
    translate: -50% -50%;
    pointer-events: none;
    z-index: 1;
  }

  .ember-primitives__slider__thumb[data-active] {
    z-index: 3;
  }

  .ember-primitives__slider[data-orientation="vertical"] .ember-primitives__slider__thumb {
    top: auto;
    left: 50%;
    translate: -50% 50%;
  }

  /*
    Default appearance -- zero specificity via :where(), so any consumer rule
    wins (even a layered one). Colors derive from currentColor so the slider
    adapts to its context.
  */
  :where(.ember-primitives__slider__track) {
    border-radius: calc(var(--ember-primitives__slider__track-thickness, 4px) / 2);
    background: color-mix(in srgb, currentColor 20%, transparent);
  }

  :where(.ember-primitives__slider__range) {
    border-radius: inherit;
    background: currentColor;
  }

  :where(.ember-primitives__slider__thumb) {
    width: var(--ember-primitives__slider__thumb-size, 16px);
    height: var(--ember-primitives__slider__thumb-size, 16px);
    border-radius: 50%;
    background: currentColor;
  }

  :where(.ember-primitives__slider__thumb[data-disabled]) {
    opacity: 0.5;
  }

  /* Keyboard focus is on the (invisible) input; reflect it on the visual thumb. */
  :where(.ember-primitives__slider__thumb-input:focus-visible + .ember-primitives__slider__thumb) {
    outline: 2px solid currentColor;
    outline-offset: 2px;
  }
}
`;

let sheet: CSSStyleSheet | null = null;

function getSheet(): CSSStyleSheet | null {
  if (typeof CSSStyleSheet === 'undefined') return null;

  if (!sheet) {
    sheet = new CSSStyleSheet();
    sheet.replaceSync(styles);
  }

  return sheet;
}

/**
 * Adds the slider's structural styles to whatever tree the slider is
 * rendered in -- the document, or a containing shadow root (where
 * document-level stylesheets can't reach).
 *
 * The stylesheet is shared: it is constructed once and adopted at most once
 * per root.
 */
export const adoptStyles = modifier((element: Element) => {
  const root = element.getRootNode();

  if (!(root instanceof Document || root instanceof ShadowRoot)) return;

  const styleSheet = getSheet();

  if (!styleSheet) return;

  if (!root.adoptedStyleSheets.includes(styleSheet)) {
    root.adoptedStyleSheets = [...root.adoptedStyleSheets, styleSheet];
  }
});
