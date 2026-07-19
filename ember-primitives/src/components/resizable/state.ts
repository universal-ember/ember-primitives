import { tracked } from '@glimmer/tracking';
import { guidFor } from '@ember/object/internals';
import { scheduleOnce } from '@ember/runloop';
import { htmlSafe } from '@ember/template';

/**
 * `style` attribute values need to be SafeStrings to avoid Ember's
 * style-binding warning.
 */
export type StyleString = ReturnType<typeof htmlSafe>;

export type Orientation = 'horizontal' | 'vertical';

const DEFAULT_MIN = 0;
const DEFAULT_MAX = 100;

/**
 * Sizes are percentages (floats). Below this threshold a collapsible
 * panel is considered collapsed.
 */
const COLLAPSED_EPSILON = 0.5;

/**
 * How far (in %) one keyboard arrow press moves a handle.
 * Holding Shift moves in coarser increments.
 */
const KEYBOARD_STEP = 1;
const KEYBOARD_STEP_COARSE = 10;

function clamp(value: number, min: number, max: number): number {
  return Math.min(Math.max(value, min), max);
}

interface PanelOptions {
  minSize: () => number | undefined;
  maxSize: () => number | undefined;
  defaultSize: () => number | undefined;
  collapsible: () => boolean | undefined;
}

export class PanelState {
  /**
   * The panel's current size, as a percentage of the group's panel-space
   * (the group's size minus the space occupied by the handles).
   *
   * `null` until the group has performed its first layout.
   */
  @tracked size: number | null = null;

  /**
   * The size (%) this panel had before it was collapsed,
   * so that expanding restores it.
   */
  previousSize: number | null = null;

  element: HTMLElement | null = null;

  #options: PanelOptions;

  constructor(options: PanelOptions) {
    this.#options = options;
  }

  get id(): string {
    return guidFor(this);
  }

  get minSize(): number {
    return this.#options.minSize() ?? DEFAULT_MIN;
  }

  get maxSize(): number {
    return this.#options.maxSize() ?? DEFAULT_MAX;
  }

  get defaultSize(): number | undefined {
    return this.#options.defaultSize();
  }

  get collapsible(): boolean {
    return this.#options.collapsible() ?? false;
  }

  get isCollapsed(): boolean {
    return this.collapsible && this.size !== null && this.size <= COLLAPSED_EPSILON;
  }

  /**
   * Percentage-based flex-grow keeps sizing proportional without
   * needing to measure anything during render.
   */
  get style(): StyleString {
    if (this.size === null) {
      return htmlSafe(`flex: 1 1 0px;`);
    }

    return htmlSafe(`flex: ${this.size} 1 0px;`);
  }
}

interface DragState {
  prev: PanelState;
  next: PanelState;
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
  /**
   * Panels in document order. Only assigned during the scheduled sync,
   * never during render (avoids backtracking re-render assertions).
   */
  @tracked panels: PanelState[] = [];

  #registered: PanelState[] = [];
  #options: GroupOptions;
  #drag: DragState | null = null;

  constructor(options: GroupOptions) {
    this.#options = options;
  }

  get orientation(): Orientation {
    return this.#options.orientation() ?? 'horizontal';
  }

  get #isHorizontal(): boolean {
    return this.orientation === 'horizontal';
  }

  get sizes(): number[] {
    return this.panels.map((panel) => panel.size ?? 0);
  }

  registerPanel(panel: PanelState): void {
    this.#registered.push(panel);
    this.#scheduleSync();
  }

  unregisterPanel(panel: PanelState): void {
    this.#registered = this.#registered.filter((existing) => existing !== panel);
    this.#scheduleSync();
  }

  #scheduleSync(): void {
    // eslint-disable-next-line ember/no-runloop
    scheduleOnce('afterRender', this, this.#sync);
  }

  /**
   * Commits registration changes and (re)computes the layout.
   * Runs after render so that tracked state consumed by sibling panels
   * is never written to mid-render.
   */
  #sync = (): void => {
    const connected = this.#registered.filter((panel) => panel.element?.isConnected);

    connected.sort((a, b) => {
      if (!a.element || !b.element) return 0;

      /**
       * a.element precedes b.element => bitmask includes "preceding" from b's perspective
       */
      const position = b.element.compareDocumentPosition(a.element);

      return position & Node.DOCUMENT_POSITION_PRECEDING ? -1 : 1;
    });

    this.panels = connected;
    this.#layout();
  };

  /**
   * Panels that already have a size (or declare a defaultSize) keep it,
   * new panels take an equal share, then everything is normalized to 100.
   */
  #layout(): void {
    const panels = this.panels;

    if (panels.length === 0) return;

    const specified: PanelState[] = [];
    const unspecified: PanelState[] = [];
    let specifiedTotal = 0;

    for (const panel of panels) {
      const preferred = panel.size ?? panel.defaultSize;

      if (preferred === undefined) {
        unspecified.push(panel);
        continue;
      }

      panel.size = panel.isCollapsed ? panel.size : clamp(preferred, panel.minSize, panel.maxSize);
      specified.push(panel);
      specifiedTotal += panel.size ?? 0;
    }

    if (unspecified.length > 0) {
      /**
       * Panels without a (default)size share the remaining space.
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

          for (const panel of specified) {
            panel.size = (panel.size ?? 0) * scale;
          }
        }
      }

      for (const panel of unspecified) {
        panel.size = clamp(share, panel.minSize, panel.maxSize);
      }
    }

    this.#normalize();
    this.#notify();
  }

  #normalize(): void {
    const panels = this.panels;
    const total = panels.reduce((sum, panel) => sum + (panel.size ?? 0), 0);

    if (total <= 0 || Math.abs(total - 100) < 0.01) return;

    for (const panel of panels) {
      panel.size = ((panel.size ?? 0) / total) * 100;
    }
  }

  #notify(): void {
    this.#options.onLayoutChange()?.(this.sizes);
  }

  /**
   * Re-derive percentage sizes from actual rendered pixels.
   * Corrects any drift (e.g. from CSS min-sizes) before an interaction.
   */
  #syncSizesFromDOM(): void {
    const panels = this.panels;
    const px = panels.map((panel) => this.#pixelSizeOf(panel));
    const total = px.reduce((sum, value) => sum + value, 0);

    if (total <= 0) return;

    panels.forEach((panel, index) => {
      panel.size = ((px[index] ?? 0) / total) * 100;
    });
  }

  #pixelSizeOf(panel: PanelState): number {
    const box = panel.element?.getBoundingClientRect();

    if (!box) return 0;

    return this.#isHorizontal ? box.width : box.height;
  }

  /**
   * The panels immediately before and after the given handle element,
   * in document order.
   */
  neighborsOf(handleElement: HTMLElement): [PanelState | null, PanelState | null] {
    let prev: PanelState | null = null;
    let next: PanelState | null = null;

    for (const panel of this.panels) {
      if (!panel.element) continue;

      const position = handleElement.compareDocumentPosition(panel.element);

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
    prev: PanelState,
    next: PanelState,
    basePrevSize: number,
    baseNextSize: number,
    requestedDelta: number
  ): void {
    const total = basePrevSize + baseNextSize;

    let target = basePrevSize + requestedDelta;

    if (prev.collapsible && target < prev.minSize) {
      /**
       * Collapsible panels snap: below half the minimum they close
       * entirely; between half and the minimum they hold at the minimum.
       * (This also keeps a collapsed panel closed when its handle is
       * dragged further in the closing direction.)
       */
      target = target < prev.minSize / 2 ? 0 : prev.minSize;
    } else {
      target = clamp(target, prev.minSize, prev.maxSize);
    }

    /**
     * The neighbor absorbs whatever the target panel gives or takes,
     * so its constraints bound the target too.
     */
    const nextMin = total - next.maxSize;
    const nextMax = total - next.minSize;

    if (nextMin > nextMax) return;

    target = clamp(target, nextMin, nextMax);

    // both panels' constraints cannot be satisfied at once
    if (!prev.collapsible && (target < prev.minSize || target > prev.maxSize)) return;

    prev.size = target;
    next.size = total - target;

    this.#notify();
  }

  startDrag(handleElement: HTMLElement, event: PointerEvent): void {
    if (event.button !== 0) return;
    if (this.#drag) return;

    const [prev, next] = this.neighborsOf(handleElement);

    if (!prev || !next) return;

    this.#syncSizesFromDOM();

    const move = (moveEvent: PointerEvent) => this.#dragMove(moveEvent);
    const end = (endEvent: PointerEvent) => this.#endDrag(handleElement, endEvent);

    this.#drag = {
      prev,
      next,
      startPrevSize: prev.size ?? 0,
      startNextSize: next.size ?? 0,
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
    const [prev, next] = this.neighborsOf(handleElement);

    if (!prev || !next) return;

    if (event.key === 'Enter') {
      this.toggleCollapse(handleElement);

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
        delta = prev.minSize - (prev.size ?? 0);

        break;
      case 'End':
        this.#syncSizesFromDOM();
        delta = prev.maxSize - (prev.size ?? 0);

        break;
    }

    if (delta === null) return;

    event.preventDefault();

    this.#syncSizesFromDOM();
    this.#applyDelta(prev, next, prev.size ?? 0, next.size ?? 0, delta);
  }

  /**
   * Collapses (or restores) the panel before the handle,
   * giving the space to (or taking it from) the panel after it.
   *
   * Only does anything when the preceding panel is `@collapsible`.
   */
  toggleCollapse(handleElement: HTMLElement): void {
    const [prev, next] = this.neighborsOf(handleElement);

    if (!prev || !next) return;
    if (!prev.collapsible) return;

    this.#syncSizesFromDOM();

    const prevSize = prev.size ?? 0;
    const nextSize = next.size ?? 0;

    if (prev.isCollapsed) {
      const preferred = prev.previousSize ?? prev.defaultSize ?? Math.max(prev.minSize, 10);
      const available = nextSize - next.minSize;
      const restored = Math.min(preferred, available);

      if (restored <= 0) return;

      prev.size = restored;
      next.size = nextSize - restored;
    } else {
      prev.previousSize = prevSize;
      prev.size = 0;
      next.size = nextSize + prevSize;
    }

    this.#notify();
  }
}

export class HandleState {
  @tracked element: HTMLElement | null = null;

  #group: GroupState;

  constructor(group: GroupState) {
    this.#group = group;
  }

  get #neighbors(): [PanelState | null, PanelState | null] {
    if (!this.element) return [null, null];

    return this.#group.neighborsOf(this.element);
  }

  get #prevPanel(): PanelState | null {
    return this.#neighbors[0];
  }

  /**
   * Per the window-splitter pattern, a splitter between two side-by-side
   * panes is oriented *vertically* (and vice-versa).
   */
  get ariaOrientation(): Orientation {
    return this.#group.orientation === 'horizontal' ? 'vertical' : 'horizontal';
  }

  get valueNow(): number | undefined {
    const size = this.#prevPanel?.size;

    return size === null || size === undefined ? undefined : Math.round(size);
  }

  get valueMin(): number | undefined {
    return this.#prevPanel?.minSize;
  }

  get valueMax(): number | undefined {
    return this.#prevPanel?.maxSize;
  }

  get controls(): string | undefined {
    return this.#prevPanel?.id;
  }
}
