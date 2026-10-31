export type Side = 'top' | 'right' | 'bottom' | 'left';
export type Alignment = 'start' | 'end';
export type Placement = Side | `${Side}-${Alignment}`;
export type Padding = number | Partial<Record<Side, number>>;

export type OffsetOptions = number | { mainAxis?: number; crossAxis?: number };

export interface FlipOptions {
  /**
   * Distance to keep from the viewport edges, on the side of the reference.
   * Use this for space that a sticky header takes up.
   */
  padding?: Padding;
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
 * Custom properties on the floating element.
 * The position rules and the arrow read these.
 */
const REFERENCE_ANCHOR = '--ember-primitives-reference-anchor';
const FLOATING_ANCHOR = '--ember-primitives-floating-anchor';
const GAP = '--ember-primitives-gap';
const SKID = '--ember-primitives-skid';
const FLIP_PADDING = '--ember-primitives-flip-padding-';
const SHIFT_PADDING = '--ember-primitives-shift-padding-';
const ARROW_PREFIX = '--ember-primitives-arrow-';
const ARROW_HALF_WIDTH = '--ember-primitives-arrow-half-width';
const ARROW_HALF_HEIGHT = '--ember-primitives-arrow-half-height';

const ANCHORED = 'data-ember-primitives-anchored';

const SIDES: Side[] = ['top', 'right', 'bottom', 'left'];

const OPPOSITE: Record<Side, Side> = {
  top: 'bottom',
  right: 'left',
  bottom: 'top',
  left: 'right',
};

export function sideOf(placement: Placement) {
  return placement.split('-')[0] as Side;
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

function placementsOn(side: Side, alignment?: Alignment): Placement[] {
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
export function placementsFor(placement: Placement, isReferenceClipped: boolean): Placement[] {
  const side = sideOf(placement);
  const alignment = alignmentOf(placement);
  const near = placementsOn(side, alignment);
  const far = placementsOn(OPPOSITE[side], alignment);

  return isReferenceClipped ? far.concat(near) : near.concat(far);
}

/**
 * - `position-area` spans the whole cross axis, so that width
 *   does not depend on the size of the reference.
 * - `margin` makes the gap, because Chrome does not flip
 *   on scroll when an inset in the scroll direction is not `auto`.
 */
function declarationsFor(placement: Placement) {
  const side = sideOf(placement);
  const alignment = alignmentOf(placement);
  const vertical = isVertical(side);

  const crossStart: Side = vertical ? 'left' : 'top';
  const crossEnd: Side = vertical ? 'right' : 'bottom';
  const span = vertical
    ? { start: 'span-right', end: 'span-left' }
    : { start: 'span-bottom', end: 'span-top' };

  const margin: Record<Side, string> = { top: '0', right: '0', bottom: '0', left: '0' };

  margin[OPPOSITE[side]] = `var(${GAP})`;
  margin[side] = `var(${FLIP_PADDING}${side})`;

  /**
   * anchor-center centers the margin box, which moves the element by half of the margin.
   */
  if (alignment === 'end') {
    margin[crossEnd] = `calc(var(${SKID}) * -1)`;
  } else {
    margin[crossStart] = alignment ? `var(${SKID})` : `calc(var(${SKID}) * 2)`;
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

    return `var(${SHIFT_PADDING}${name}, auto)`;
  };

  return {
    'position-area': vertical ? `${side} ${crossArea}` : `${crossArea} ${side}`,
    'align-self': vertical ? mainSelf[side] : crossValue,
    'justify-self': vertical ? crossValue : mainSelf[side],
    margin: `${margin.top} ${margin.right} ${margin.bottom} ${margin.left}`,
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
function arrowDeclarationsFor(placement: Placement) {
  const declarations = declarationsFor(placement);
  const side = sideOf(placement);
  const alignment = alignmentOf(placement);
  const vertical = isVertical(side);
  const floating = `var(${FLOATING_ANCHOR})`;

  const mainSize = vertical ? 'height' : 'width';
  const crossSize = vertical ? 'width' : 'height';
  const mainHalf = `var(${vertical ? ARROW_HALF_HEIGHT : ARROW_HALF_WIDTH}, 0px)`;
  const crossHalf = `var(${vertical ? ARROW_HALF_WIDTH : ARROW_HALF_HEIGHT}, 0px)`;

  const margin: Record<Side, string> = { top: '0', right: '0', bottom: '0', left: '0' };

  margin[OPPOSITE[side]] = `calc(var(${GAP}) - ${mainHalf})`;
  margin[side] =
    `calc(anchor-size(${floating} ${mainSize}) - ${mainHalf} + var(${FLIP_PADDING}${side}))`;

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

function ruleNameFor(placement: Placement) {
  return `--ember-primitives-${placement}`;
}

function arrowRuleNameFor(placement: Placement) {
  return `--ember-primitives-arrow-rule-${placement}`;
}

function rule(name: string, declarations: Record<string, string>) {
  const body = Object.entries(declarations)
    .map(([property, value]) => `${property}: ${value};`)
    .join(' ');

  return `@position-try ${name} { ${body} }`;
}

const PLACEMENTS = SIDES.flatMap((side) => placementsOn(side));

/**
 * One rule for each placement, and custom properties hold the spacing.
 * So the sheet never changes, and elements have nothing to clean up.
 *
 * :where(), so that any width from the app has precedence.
 */
const sheet = new CSSStyleSheet();

sheet.replaceSync(
  [`:where([${ANCHORED}]) { width: max-content; max-width: 100vw; }`]
    .concat(PLACEMENTS.map((p) => rule(ruleNameFor(p), declarationsFor(p))))
    .concat(PLACEMENTS.map((p) => rule(arrowRuleNameFor(p), arrowDeclarationsFor(p))))
    .join('\n')
);

let nextName = 0;

const anchorNames = new WeakMap<Element, string>();

function anchorNameFor(element: HTMLElement | SVGElement) {
  let name = anchorNames.get(element);

  if (!name) {
    name = `--ember-primitives-anchor-${nextName++}`;
    anchorNames.set(element, name);

    const existing = getComputedStyle(element).getPropertyValue('anchor-name');

    element.style.setProperty('anchor-name', existing === 'none' ? name : `${existing}, ${name}`);
  }

  return name;
}

function rootsOf(element: Element) {
  let root = element.getRootNode() as Document | ShadowRoot;

  const roots = [root];

  while (root instanceof ShadowRoot) {
    root = root.host.getRootNode() as Document | ShadowRoot;
    roots.push(root);
  }

  return roots;
}

/**
 * Browsers only track a scroll for a reference in a plain scroller.
 *
 * Until the next layout, Firefox moves away from a sticky reference,
 * and does not follow a reference inside of another floating element.
 *
 * A change to the gap that is too small to see causes that layout.
 *
 * A scroll event does not leave a shadow root, so each root needs a listener.
 */
function layoutOnScroll(floating: HTMLElement, reference: Element, gap: number) {
  const roots = rootsOf(reference);

  let isNudged = false;

  const onScroll = () => {
    isNudged = !isNudged;
    floating.style.setProperty(GAP, isNudged ? `calc(${gap}px + 0.001px)` : `${gap}px`);
  };

  for (const root of roots) {
    root.addEventListener('scroll', onScroll, { capture: true, passive: true });
  }

  return () => {
    for (const root of roots) {
      root.removeEventListener('scroll', onScroll, { capture: true });
    }
  };
}

export function setupFloating(
  floating: HTMLElement,
  reference: HTMLElement | SVGElement,
  layout: Layout
) {
  const { offsetOptions, flipOptions, shiftOptions } = layout;
  const { style } = floating;
  const root = floating.getRootNode() as Document | ShadowRoot;
  const referenceName = anchorNameFor(reference);

  if (!root.adoptedStyleSheets.includes(sheet)) {
    root.adoptedStyleSheets.push(sheet);
  }

  floating.setAttribute(ANCHORED, '');

  style.setProperty('position-anchor', referenceName);
  style.setProperty(REFERENCE_ANCHOR, referenceName);
  style.setProperty(FLOATING_ANCHOR, anchorNameFor(floating));

  const mainAxis = typeof offsetOptions === 'number' ? offsetOptions : offsetOptions?.mainAxis;
  const crossAxis = typeof offsetOptions === 'number' ? 0 : offsetOptions?.crossAxis;

  style.setProperty(GAP, `${mainAxis ?? 0}px`);
  style.setProperty(SKID, `${crossAxis ?? 0}px`);

  for (const side of SIDES) {
    const shift = paddingOf(shiftOptions?.padding, side);

    style.setProperty(`${FLIP_PADDING}${side}`, `${paddingOf(flipOptions?.padding, side) ?? 0}px`);
    style.setProperty(`${SHIFT_PADDING}${side}`, shift === undefined ? 'auto' : `${shift}px`);
  }

  return layoutOnScroll(floating, reference, mainAxis ?? 0);
}

export function applyPlacements(floating: HTMLElement, placements: Placement[]) {
  const [first] = placements;

  if (!first) return;

  const { style } = floating;

  for (const [property, value] of Object.entries(declarationsFor(first))) {
    style.setProperty(property, value);
  }

  for (const [property, value] of Object.entries(arrowDeclarationsFor(first))) {
    style.setProperty(`${ARROW_PREFIX}${property}`, value);
  }

  const fallbacks = placements.slice(1);

  style.setProperty('position-try-fallbacks', fallbacks.map(ruleNameFor).join(', '));
  style.setProperty(
    `${ARROW_PREFIX}position-try-fallbacks`,
    fallbacks.map(arrowRuleNameFor).join(', ')
  );
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
