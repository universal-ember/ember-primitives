export type Side = 'top' | 'right' | 'bottom' | 'left';
export type Alignment = 'start' | 'end';
export type Placement = Side | `${Side}-${Alignment}`;
export type Padding = number | Partial<Record<Side, number>>;
export type ElementContext = 'floating' | 'reference' | 'both';

export type OffsetOptions = number | { mainAxis?: number; crossAxis?: number };

export interface FlipOptions {
  /**
   * What causes a flip:
   * - `'floating'`: the floating element overflows the viewport
   * - `'reference'`: something clips the reference element
   * - `'both'`: either of the above
   */
  elementContext?: ElementContext;
  /**
   * Distance to keep from the viewport edges, on the side of the reference.
   * Use this for space that a sticky header takes up.
   */
  padding?: Padding;
  /**
   * Placements to try, in order, instead of the default placements.
   */
  fallbackPlacements?: Placement[];
}

export interface ShiftOptions {
  /**
   * Distance to keep from the viewport edges, along the reference.
   */
  padding?: Padding;
}

interface Layout {
  offsetOptions?: OffsetOptions;
  flipOptions?: FlipOptions;
  shiftOptions?: ShiftOptions;
}

/**
 * Custom properties on the floating element, which the arrow reads.
 */
const REFERENCE_ANCHOR = '--ember-primitives-reference-anchor';
const FLOATING_ANCHOR = '--ember-primitives-floating-anchor';
const ARROW_PREFIX = '--ember-primitives-arrow-';

const ARROW_HALF_WIDTH = '--ember-primitives-arrow-half-width';
const ARROW_HALF_HEIGHT = '--ember-primitives-arrow-half-height';

const ANCHORED = 'data-ember-primitives-anchored';

const OPPOSITE: Record<Side, Side> = {
  top: 'bottom',
  right: 'left',
  bottom: 'top',
  left: 'right',
};

export function sideOf(placement: Placement) {
  return placement.split('-')[0] as Side;
}

export function oppositeOf(side: Side) {
  return OPPOSITE[side];
}

function alignmentOf(placement: Placement) {
  return placement.split('-')[1] as Alignment | undefined;
}

function isVertical(side: Side) {
  return side === 'top' || side === 'bottom';
}

function paddingOf(padding: Padding | undefined, side: Side) {
  return typeof padding === 'number' ? padding : padding?.[side];
}

function placementsOn(side: Side, alignment: Alignment | undefined): Placement[] {
  if (alignment === 'start') return [`${side}-start`, `${side}-end`];
  if (alignment === 'end') return [`${side}-end`, `${side}-start`];

  return [side, `${side}-start`, `${side}-end`];
}

/**
 * The placements to try, best first.
 *
 * Native shift does not follow a scroll, and fallbacks do.
 * So the other alignments on the same side come before the opposite side.
 */
export function placementsFor(
  placement: Placement,
  elementContext: ElementContext,
  fallbackPlacements: Placement[] | undefined,
  isReferenceClipped: boolean
): Placement[] {
  const side = sideOf(placement);
  const alignment = alignmentOf(placement);

  const near = fallbackPlacements
    ? [placement].concat(fallbackPlacements)
    : placementsOn(side, alignment);
  const far = fallbackPlacements ? [] : placementsOn(OPPOSITE[side], alignment);

  if (isReferenceClipped && !fallbackPlacements) {
    return elementContext === 'reference' ? far : far.concat(near);
  }

  return elementContext === 'reference' ? near.slice(0, 1) : near.concat(far);
}

/**
 * - `position-area` spans the whole cross axis, so that width
 *   does not depend on the size of the reference.
 * - `margin` makes the gap, because Chrome does not flip
 *   on scroll when an inset in the scroll direction is not `auto`.
 */
export function declarationsFor(placement: Placement, layout: Layout) {
  const { offsetOptions, flipOptions, shiftOptions } = layout;
  const side = sideOf(placement);
  const alignment = alignmentOf(placement);
  const vertical = isVertical(side);

  const mainAxis = typeof offsetOptions === 'number' ? offsetOptions : offsetOptions?.mainAxis;
  const crossAxis = typeof offsetOptions === 'number' ? 0 : (offsetOptions?.crossAxis ?? 0);

  const crossStart: Side = vertical ? 'left' : 'top';
  const crossEnd: Side = vertical ? 'right' : 'bottom';
  const span = vertical
    ? { start: 'span-right', end: 'span-left' }
    : { start: 'span-bottom', end: 'span-top' };

  const margin: Record<Side, number> = { top: 0, right: 0, bottom: 0, left: 0 };

  margin[OPPOSITE[side]] = mainAxis ?? 0;
  margin[side] = paddingOf(flipOptions?.padding, side) ?? 0;

  /**
   * anchor-center centers the margin box, which moves the element by half of the margin.
   */
  if (alignment === 'end') {
    margin[crossEnd] = -crossAxis;
  } else {
    margin[crossStart] = alignment ? crossAxis : crossAxis * 2;
  }

  const crossArea = alignment ? span[alignment] : 'span-all';
  const crossSelf = {
    start: vertical ? 'left' : 'start',
    end: vertical ? 'right' : 'end',
  };
  const mainSelf = {
    top: 'end',
    bottom: 'start',
    left: 'right',
    right: 'left',
  };
  const crossValue = alignment ? crossSelf[alignment] : 'anchor-center';

  const inset = (name: Side) => {
    if (name === side || name === OPPOSITE[side]) return 'auto';

    const padding = paddingOf(shiftOptions?.padding, name);

    return padding === undefined ? 'auto' : `${padding}px`;
  };

  return {
    'position-area': vertical ? `${side} ${crossArea}` : `${crossArea} ${side}`,
    'align-self': vertical ? mainSelf[side] : crossValue,
    'justify-self': vertical ? crossValue : mainSelf[side],
    margin: `${margin.top}px ${margin.right}px ${margin.bottom}px ${margin.left}px`,
    top: inset('top'),
    right: inset('right'),
    bottom: inset('bottom'),
    left: inset('left'),
  };
}

/**
 * The arrow has the same margin box as the floating element.
 *
 * So the browser flips both at the same time, for any cause.
 * Inherited styles do not work here, because Firefox does not
 * update descendants when a scroll selects a fallback.
 *
 * The arrow only uses the reference for its position,
 * because Firefox resolves any other anchor at its unscrolled position.
 * `anchor-size()` of the floating element is safe, because a scroll does not change size.
 */
function arrowDeclarationsFor(placement: Placement, layout: Layout) {
  const declarations = declarationsFor(placement, layout);
  const side = sideOf(placement);
  const alignment = alignmentOf(placement);
  const vertical = isVertical(side);
  const floating = `var(${FLOATING_ANCHOR})`;

  const mainSize = vertical ? 'height' : 'width';
  const crossSize = vertical ? 'width' : 'height';
  const mainHalf = `var(${vertical ? ARROW_HALF_HEIGHT : ARROW_HALF_WIDTH}, 0px)`;
  const crossHalf = `var(${vertical ? ARROW_HALF_WIDTH : ARROW_HALF_HEIGHT}, 0px)`;

  const { offsetOptions, flipOptions } = layout;
  const gap = typeof offsetOptions === 'number' ? offsetOptions : (offsetOptions?.mainAxis ?? 0);
  const padding = paddingOf(flipOptions?.padding, side) ?? 0;

  const margin: Record<Side, string> = { top: '0', right: '0', bottom: '0', left: '0' };

  margin[OPPOSITE[side]] = `calc(${gap}px - ${mainHalf})`;
  margin[side] = `calc(anchor-size(${floating} ${mainSize}) - ${mainHalf} + ${padding}px)`;

  if (alignment) {
    const crossNear: Side =
      alignment === 'start' ? (vertical ? 'left' : 'top') : vertical ? 'right' : 'bottom';
    const crossFar = OPPOSITE[crossNear];
    const center = `min(anchor-size(${crossSize}), anchor-size(${floating} ${crossSize})) / 2`;

    margin[crossNear] = `calc(${center} - ${crossHalf})`;
    margin[crossFar] = `calc(anchor-size(${floating} ${crossSize}) - ${center} - ${crossHalf})`;
  }

  return {
    'position-area': declarations['position-area'],
    'align-self': declarations['align-self'],
    'justify-self': declarations['justify-self'],
    margin: `${margin.top} ${margin.right} ${margin.bottom} ${margin.left}`,
  };
}

let sheet: CSSStyleSheet | undefined;
let nextName = 0;

const ruleNames = new Map<string, string>();
const anchorNames = new WeakMap<Element, string>();

function sheetFor(element: Element) {
  /**
   * Created here and not at the module level, because SSR has no CSSStyleSheet.
   */
  sheet ??= new CSSStyleSheet();

  if (sheet.cssRules.length === 0) {
    /**
     * :where(), so that any width from the app has precedence.
     */
    sheet.insertRule(`:where([${ANCHORED}]) { width: max-content; max-width: 100vw; }`);
  }

  const root = element.getRootNode() as Document | ShadowRoot;

  if (!root.adoptedStyleSheets.includes(sheet)) {
    root.adoptedStyleSheets.push(sheet);
  }

  return sheet;
}

/**
 * Rules are shared, because few combinations of placement and spacing exist in one app.
 */
function positionTryFor(element: Element, declarations: Record<string, string>) {
  const target = sheetFor(element);
  const body = Object.entries(declarations)
    .map(([property, value]) => `${property}: ${value};`)
    .join(' ');

  let name = ruleNames.get(body);

  if (!name) {
    name = `--ember-primitives-try-${nextName++}`;
    target.insertRule(`@position-try ${name} { ${body} }`, target.cssRules.length);
    ruleNames.set(body, name);
  }

  return name;
}

export function anchorNameFor(element: Element & ElementCSSInlineStyle) {
  let name = anchorNames.get(element);

  if (!name) {
    name = `--ember-primitives-anchor-${nextName++}`;
    anchorNames.set(element, name);

    const existing = getComputedStyle(element).getPropertyValue('anchor-name');

    element.style.setProperty('anchor-name', existing === 'none' ? name : `${existing}, ${name}`);
  }

  return name;
}

export function applyPlacements(floating: HTMLElement, placements: Placement[], layout: Layout) {
  const [first] = placements;

  if (!first || !floating.isConnected) return;

  sheetFor(floating);
  floating.setAttribute(ANCHORED, '');

  for (const [property, value] of Object.entries(declarationsFor(first, layout))) {
    floating.style.setProperty(property, value);
  }

  const fallbacks = placements
    .slice(1)
    .map((placement) => positionTryFor(floating, declarationsFor(placement, layout)));

  floating.style.setProperty('position-try-fallbacks', fallbacks.join(', ') || 'none');

  for (const [property, value] of Object.entries(arrowDeclarationsFor(first, layout))) {
    floating.style.setProperty(`${ARROW_PREFIX}${property}`, value);
  }

  const arrowFallbacks = placements
    .slice(1)
    .map((placement) => positionTryFor(floating, arrowDeclarationsFor(placement, layout)));

  floating.style.setProperty(
    `${ARROW_PREFIX}position-try-fallbacks`,
    arrowFallbacks.join(', ') || 'none'
  );
}

export function linkAnchors(floating: HTMLElement, reference: HTMLElement | SVGElement) {
  const referenceName = anchorNameFor(reference);

  floating.style.setProperty('position-anchor', referenceName);
  floating.style.setProperty(REFERENCE_ANCHOR, referenceName);
  floating.style.setProperty(FLOATING_ANCHOR, anchorNameFor(floating));
}

/**
 * This is `fixed`, because `absolute` makes the popover the containing block,
 * and an element can only anchor to what is inside of its containing block.
 */
export function applyArrow(arrow: HTMLElement) {
  const { style } = arrow;

  style.setProperty('position', 'fixed');
  style.setProperty('inset', 'auto');
  style.setProperty('position-anchor', `var(${REFERENCE_ANCHOR})`);

  for (const property of [
    'position-area',
    'align-self',
    'justify-self',
    'margin',
    'position-try-fallbacks',
  ]) {
    style.setProperty(property, `var(${ARROW_PREFIX}${property})`);
  }

  /**
   * Child modifiers run first, so the popover is not open yet and the arrow has no size.
   *
   * These go on the floating element, because that is where
   * the custom properties that use them resolve.
   */
  const observer = new ResizeObserver(() => {
    const floating = arrow.closest<HTMLElement>(`[${ANCHORED}]`);

    floating?.style.setProperty(ARROW_HALF_WIDTH, `${arrow.offsetWidth / 2}px`);
    floating?.style.setProperty(ARROW_HALF_HEIGHT, `${arrow.offsetHeight / 2}px`);
  });

  observer.observe(arrow);

  return () => observer.disconnect();
}
