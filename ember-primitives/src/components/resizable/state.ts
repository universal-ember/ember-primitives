export type Orientation = 'horizontal' | 'vertical';

const GROUP_SELECTOR = '.ember-primitives__resizable';
const PANEL_SELECTOR = '.ember-primitives__resizable__panel';
const HANDLE_SELECTOR = '.ember-primitives__resizable__handle';

const DEFAULT_MIN = 0;
const DEFAULT_MAX = 100;

/**
 * How far (in %) one keyboard arrow press moves a handle.
 * Holding Shift moves in coarser increments.
 */
const KEYBOARD_STEP = 1;
const KEYBOARD_STEP_COARSE = 10;

let panelId = 0;

function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max);
}

function numberAttribute(element: Element, name: string): number | undefined {
  const raw = element.getAttribute(name);

  if (raw === null) return undefined;

  const value = parseFloat(raw);

  return Number.isFinite(value) ? value : undefined;
}

/**
 * Panels declare their constraints in the DOM (via data attributes),
 * so the group can discover everything it needs with queries --
 * no registration required.
 */
function minSizeOf(panel: Element): number {
  return numberAttribute(panel, 'data-min-size') ?? DEFAULT_MIN;
}

function maxSizeOf(panel: Element): number {
  return numberAttribute(panel, 'data-max-size') ?? DEFAULT_MAX;
}

function requestedSizeOf(panel: Element): number | undefined {
  return numberAttribute(panel, 'data-size');
}

function isCollapsible(panel: Element): boolean {
  return panel.hasAttribute('data-collapsible');
}

function sameMembers(a: HTMLElement[], b: HTMLElement[]): boolean {
  return a.length === b.length && a.every((element, index) => element === b[index]);
}

/**
 * Skips the write when the attribute already has the desired value,
 * so unchanged elements are left untouched.
 */
function setAttribute(element: Element, name: string, value: string): void {
  if (element.getAttribute(name) !== value) {
    element.setAttribute(name, value);
  }
}

interface DragState {
  prev: HTMLElement;
  next: HTMLElement;
  startPrevSize: number;
  startNextSize: number;
  startCoordinate: number;
  /**
   * Total px occupied by the panels (excluding handles) at drag start,
   * used to convert px deltas to % deltas.
   */
  totalPx: number;
  move: (event: PointerEvent) => void;
  end: (event: PointerEvent) => void;
}

interface GroupOptions {
  orientation: () => Orientation | undefined;
  onLayoutChange: () => ((sizes: number[]) => void) | undefined;
}

export class GroupState {
  element: HTMLElement | null = null;

  #options: GroupOptions;
  #observer: MutationObserver | null = null;
  #drag: DragState | null = null;

  /**
   * Current size (%) per panel element.
   * The DOM is the source of truth for membership; this only remembers
   * sizes across relayouts.
   */
  #sizes = new Map<HTMLElement, number>();

  /**
   * The size (%) a collapsible panel had before it was collapsed,
   * so that expanding restores it.
   */
  #previousSizes = new WeakMap<HTMLElement, number>();

  /**
   * Membership as of the last layout, so mutation batches that don't
   * change membership (e.g. content changes inside a panel, or churn
   * within a nested group) can be ignored.
   */
  #knownPanels: HTMLElement[] = [];
  #knownHandles: HTMLElement[] = [];

  constructor(options: GroupOptions) {
    this.#options = options;
  }

  get orientation(): Orientation {
    return this.#options.orientation() ?? 'horizontal';
  }

  get #isHorizontal(): boolean {
    return this.orientation === 'horizontal';
  }

  /**
   * This group's panels, in document order.
   * Panels of nested groups belong to their own group, not this one.
   */
  get panels(): HTMLElement[] {
    return this.#query(PANEL_SELECTOR);
  }

  get handles(): HTMLElement[] {
    return this.#query(HANDLE_SELECTOR);
  }

  #query(selector: string): HTMLElement[] {
    const element = this.element;

    if (!element) return [];

    const all = Array.from(element.querySelectorAll<HTMLElement>(selector));

    return all.filter((candidate) => candidate.closest(GROUP_SELECTOR) === element);
  }

  get sizes(): number[] {
    return this.panels.map((panel) => this.#sizes.get(panel) ?? 0);
  }

  /**
   * Called (via modifier) when the group element is inserted.
   * Watches for panels being added/removed (and the orientation
   * changing) and performs the initial layout.
   */
  attach = (element: HTMLElement): (() => void) => {
    this.element = element;

    this.#observer = new MutationObserver((mutations) => this.#onMutation(mutations));
    this.#observer.observe(element, {
      childList: true,
      subtree: true,
      attributes: true,
      attributeFilter: ['data-orientation'],
    });

    this.#layout();

    return () => {
      this.#observer?.disconnect();
      this.#observer = null;
      this.element = null;
    };
  };

  /**
   * Subtree observation is required (panels may sit behind wrapper
   * elements), which means this also fires for churn inside nested
   * groups and for content changes within panels. Rather than
   * classifying every mutation, we answer the only question that
   * matters -- did *this* group's membership actually change? --
   * and no-op otherwise.
   */
  #onMutation(mutations: MutationRecord[]): void {
    const orientationChanged = mutations.some(
      (mutation) => mutation.type === 'attributes' && mutation.target === this.element
    );

    if (orientationChanged || this.#membershipChanged()) this.#layout();
  }

  #membershipChanged(): boolean {
    return (
      !sameMembers(this.panels, this.#knownPanels) || !sameMembers(this.handles, this.#knownHandles)
    );
  }

  /**
   * Panels that already have a size (or request one via `data-size`)
   * keep it; new panels take a share of the remaining space; everything
   * is normalized to 100.
   */
  #layout(): void {
    const panels = this.panels;

    this.#knownPanels = panels;
    this.#knownHandles = this.handles;

    if (panels.length === 0) return;

    // forget sizes of panels that left the DOM
    for (const known of Array.from(this.#sizes.keys())) {
      if (!panels.includes(known)) this.#sizes.delete(known);
    }

    const next = new Map<HTMLElement, number>();
    const unspecified: HTMLElement[] = [];
    let specifiedTotal = 0;

    for (const panel of panels) {
      const preferred = this.#sizes.get(panel) ?? requestedSizeOf(panel);

      if (preferred === undefined) {
        unspecified.push(panel);
        continue;
      }

      const size = this.#isCollapsed(panel)
        ? preferred
        : clamp(preferred, minSizeOf(panel), maxSizeOf(panel));

      next.set(panel, size);
      specifiedTotal += size;
    }

    if (unspecified.length > 0) {
      /**
       * Panels without a size share the remaining space.
       * When there is none left (e.g. a panel was added to an
       * already-full group), each takes an equal 1/n share and the
       * existing panels scale down to make room -- like a new window
       * opening in a tiling window manager.
       */
      const remaining = 100 - specifiedTotal;
      let share = remaining / unspecified.length;

      if (remaining < 1) {
        share = 100 / panels.length;

        if (specifiedTotal > 0) {
          const scale = Math.max(100 - share * unspecified.length, 0) / specifiedTotal;

          for (const [panel, size] of next) {
            next.set(panel, size * scale);
          }
        }
      }

      for (const panel of unspecified) {
        next.set(panel, clamp(share, minSizeOf(panel), maxSizeOf(panel)));
      }
    }

    // normalize to 100
    let total = 0;

    for (const size of next.values()) total += size;

    if (total > 0 && Math.abs(total - 100) > 0.01) {
      for (const [panel, size] of next) {
        next.set(panel, (size / total) * 100);
      }
    }

    this.#sizes = next;
    this.#apply();
    this.#notify();
  }

  /**
   * Writes the layout back to the DOM: flex sizing and the handles'
   * ARIA attributes. (`data-collapsed` is managed at the explicit
   * collapse/expand points, not derived from sizes -- rendered pixel
   * sizes include borders/padding, so a collapsed panel rarely
   * measures exactly 0.)
   */
  #apply(): void {
    for (const [panel, size] of this.#sizes) {
      const flex = `${size} 1 0px`;

      if (panel.style.flex !== flex) {
        panel.style.flex = flex;
      }
    }

    this.#syncHandles();
  }

  /**
   * Per the window-splitter pattern, each handle describes the panel
   * immediately before it. (A splitter between two side-by-side panes
   * is oriented *vertically*, and vice-versa.)
   */
  #syncHandles(): void {
    for (const handle of this.handles) {
      const [prev] = this.#neighborsOf(handle);

      setAttribute(handle, 'aria-orientation', this.#isHorizontal ? 'vertical' : 'horizontal');

      if (!prev) continue;

      if (!prev.id) prev.id = `ember-primitives__resizable__panel--${panelId++}`;

      setAttribute(handle, 'aria-controls', prev.id);
      setAttribute(handle, 'aria-valuemin', `${minSizeOf(prev)}`);
      setAttribute(handle, 'aria-valuemax', `${maxSizeOf(prev)}`);
      setAttribute(handle, 'aria-valuenow', `${Math.round(this.#sizes.get(prev) ?? 0)}`);
    }
  }

  #notify(): void {
    this.#options.onLayoutChange()?.(this.sizes);
  }

  /**
   * The `data-collapsed` attribute is the source of truth for collapse
   * state (it is also the styling hook consumers use).
   */
  #isCollapsed(panel: HTMLElement): boolean {
    return isCollapsible(panel) && panel.hasAttribute('data-collapsed');
  }

  #setCollapsed(panel: HTMLElement, collapsed: boolean): void {
    if (collapsed) {
      panel.setAttribute('data-collapsed', '');
    } else {
      panel.removeAttribute('data-collapsed');
    }
  }

  /**
   * Re-derive percentage sizes from actual rendered pixels.
   * Corrects any drift (e.g. from CSS min-sizes) before an interaction.
   */
  #syncSizesFromDOM(): void {
    const panels = this.panels;
    // collapsed panels are 0 even though their borders/padding measure larger
    const px = panels.map((panel) => (this.#isCollapsed(panel) ? 0 : this.#pixelSizeOf(panel)));
    const total = px.reduce((sum, value) => sum + value, 0);

    if (total <= 0) return;

    panels.forEach((panel, index) => {
      this.#sizes.set(panel, ((px[index] ?? 0) / total) * 100);
    });
  }

  #pixelSizeOf(panel: HTMLElement): number {
    const box = panel.getBoundingClientRect();

    return this.#isHorizontal ? box.width : box.height;
  }

  /**
   * The panels immediately before and after the given handle element,
   * in document order.
   */
  #neighborsOf(handleElement: HTMLElement): [HTMLElement | null, HTMLElement | null] {
    let prev: HTMLElement | null = null;
    let next: HTMLElement | null = null;

    for (const panel of this.panels) {
      const position = handleElement.compareDocumentPosition(panel);

      if (position & Node.DOCUMENT_POSITION_PRECEDING) {
        prev = panel;
      } else if (position & Node.DOCUMENT_POSITION_FOLLOWING) {
        next = panel;

        break;
      }
    }

    return [prev, next];
  }

  /**
   * Moves the boundary between the two panels by `requestedDelta` (%),
   * respecting both panels' min/max constraints.
   */
  #applyDelta(
    prev: HTMLElement,
    next: HTMLElement,
    basePrevSize: number,
    baseNextSize: number,
    requestedDelta: number
  ): void {
    const total = basePrevSize + baseNextSize;

    let target = basePrevSize + requestedDelta;

    if (isCollapsible(prev) && target < minSizeOf(prev)) {
      /**
       * Collapsible panels snap: below half the minimum they close
       * entirely; between half and the minimum they hold at the minimum.
       * (This also keeps a collapsed panel closed when its handle is
       * dragged further in the closing direction.)
       */
      target = target < minSizeOf(prev) / 2 ? 0 : minSizeOf(prev);
    } else {
      target = clamp(target, minSizeOf(prev), maxSizeOf(prev));
    }

    /**
     * The neighbor absorbs whatever the target panel gives or takes,
     * so its constraints bound the target too.
     */
    const nextMin = total - maxSizeOf(next);
    const nextMax = total - minSizeOf(next);

    if (nextMin > nextMax) return;

    target = clamp(target, nextMin, nextMax);

    // both panels' constraints cannot be satisfied at once
    if (!isCollapsible(prev) && (target < minSizeOf(prev) || target > maxSizeOf(prev))) return;

    if (isCollapsible(prev)) {
      if (target === 0 && !this.#isCollapsed(prev)) {
        this.#previousSizes.set(prev, basePrevSize);
      }

      this.#setCollapsed(prev, target === 0);
    }

    this.#sizes.set(prev, target);
    this.#sizes.set(next, total - target);

    this.#apply();
    this.#notify();
  }

  startDrag(handleElement: HTMLElement, event: PointerEvent): void {
    if (event.button !== 0) return;
    if (this.#drag) return;

    const [prev, next] = this.#neighborsOf(handleElement);

    if (!prev || !next) return;

    this.#syncSizesFromDOM();

    const move = (moveEvent: PointerEvent) => this.#dragMove(moveEvent);
    const end = (endEvent: PointerEvent) => this.#endDrag(handleElement, endEvent);

    this.#drag = {
      prev,
      next,
      startPrevSize: this.#sizes.get(prev) ?? 0,
      startNextSize: this.#sizes.get(next) ?? 0,
      startCoordinate: this.#isHorizontal ? event.clientX : event.clientY,
      totalPx: this.panels.reduce((sum, panel) => sum + this.#pixelSizeOf(panel), 0),
      move,
      end,
    };

    try {
      /**
       * Retargets all subsequent pointer events to the handle,
       * even when the pointer is over an iframe.
       */
      handleElement.setPointerCapture(event.pointerId);
    } catch {
      // synthetic events (tests) may not have an active pointer
    }

    handleElement.addEventListener('pointermove', this.#drag.move);
    handleElement.addEventListener('pointerup', this.#drag.end);
    handleElement.addEventListener('pointercancel', this.#drag.end);
    handleElement.setAttribute('data-resizing', '');

    document.body.style.cursor = this.#isHorizontal ? 'col-resize' : 'row-resize';
    document.body.style.userSelect = 'none';
  }

  #dragMove(event: PointerEvent): void {
    const drag = this.#drag;

    if (!drag) return;
    if (drag.totalPx <= 0) return;

    const coordinate = this.#isHorizontal ? event.clientX : event.clientY;
    const deltaPercent = ((coordinate - drag.startCoordinate) / drag.totalPx) * 100;

    this.#applyDelta(drag.prev, drag.next, drag.startPrevSize, drag.startNextSize, deltaPercent);
  }

  #endDrag(handleElement: HTMLElement, event: PointerEvent): void {
    const drag = this.#drag;

    if (!drag) return;

    this.#drag = null;

    try {
      handleElement.releasePointerCapture(event.pointerId);
    } catch {
      // may not have been captured (tests)
    }

    handleElement.removeEventListener('pointermove', drag.move);
    handleElement.removeEventListener('pointerup', drag.end);
    handleElement.removeEventListener('pointercancel', drag.end);
    handleElement.removeAttribute('data-resizing');

    document.body.style.cursor = '';
    document.body.style.userSelect = '';
  }

  /**
   * Keyboard support for the WAI-ARIA window-splitter pattern.
   */
  handleKeyDown(handleElement: HTMLElement, event: KeyboardEvent): void {
    const [prev, next] = this.#neighborsOf(handleElement);

    if (!prev || !next) return;

    if (event.key === 'Enter') {
      this.#toggleCollapse(prev, next);

      return;
    }

    const step = event.shiftKey ? KEYBOARD_STEP_COARSE : KEYBOARD_STEP;
    const isHorizontal = this.#isHorizontal;

    let delta: number | null = null;

    switch (event.key) {
      case 'ArrowLeft':
        if (isHorizontal) delta = -step;

        break;
      case 'ArrowRight':
        if (isHorizontal) delta = step;

        break;
      case 'ArrowUp':
        if (!isHorizontal) delta = -step;

        break;
      case 'ArrowDown':
        if (!isHorizontal) delta = step;

        break;
      case 'Home':
        this.#syncSizesFromDOM();
        delta = minSizeOf(prev) - (this.#sizes.get(prev) ?? 0);

        break;
      case 'End':
        this.#syncSizesFromDOM();
        delta = maxSizeOf(prev) - (this.#sizes.get(prev) ?? 0);

        break;
    }

    if (delta === null) return;

    event.preventDefault();

    this.#syncSizesFromDOM();
    this.#applyDelta(prev, next, this.#sizes.get(prev) ?? 0, this.#sizes.get(next) ?? 0, delta);
  }

  /**
   * Collapses (or restores) the panel before the handle,
   * giving the space to (or taking it from) the panel after it.
   *
   * Only does anything when the preceding panel is `@collapsible`.
   */
  #toggleCollapse(prev: HTMLElement, next: HTMLElement): void {
    if (!isCollapsible(prev)) return;

    this.#syncSizesFromDOM();

    const prevSize = this.#sizes.get(prev) ?? 0;
    const nextSize = this.#sizes.get(next) ?? 0;

    if (this.#isCollapsed(prev)) {
      const preferred =
        this.#previousSizes.get(prev) ?? requestedSizeOf(prev) ?? Math.max(minSizeOf(prev), 10);
      const available = nextSize - minSizeOf(next);
      const restored = Math.min(preferred, available);

      if (restored <= 0) return;

      this.#setCollapsed(prev, false);
      this.#sizes.set(prev, restored);
      this.#sizes.set(next, nextSize - restored);
    } else {
      this.#previousSizes.set(prev, prevSize);
      this.#setCollapsed(prev, true);
      this.#sizes.set(prev, 0);
      this.#sizes.set(next, nextSize + prevSize);
    }

    this.#apply();
    this.#notify();
  }
}
