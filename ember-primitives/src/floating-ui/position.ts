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
 * Custom properties on the floating element.
 * The arrow reads the names of both anchors from these.
 */
export const REFERENCE_ANCHOR = '--ember-primitives-reference-anchor';
export const FLOATING_ANCHOR = '--ember-primitives-floating-anchor';

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
}
