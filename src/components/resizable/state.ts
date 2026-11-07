export type Orientation = 'horizontal' | 'vertical';

const GROUP_SELECTOR = '.ember-primitives__resizable';
const PANEL_CLASS = 'ember-primitives__resizable__panel';
const HANDLE_CLASS = 'ember-primitives__resizable__handle';
const MEMBER_SELECTOR = `.${PANEL_CLASS}, .${HANDLE_CLASS}`;

const DEFAULT_MIN = 0;
const DEFAULT_MAX = 100;

/**
 * How far (in %) one keyboard arrow press moves a handle.
 * Holding Shift moves in coarser increments.
 */
const KEYBOARD_STEP = 1;
const KEYBOARD_STEP_COARSE = 10;

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

function precedes(a: Element, b: Element): boolean {
  return Boolean(b.compareDocumentPosition(a) & Node.DOCUMENT_POSITION_PRECEDING);
}

/**
 * The `data-collapsed` attribute is the source of truth for collapse
 * state (it is also the styling hook consumers use).
 */
function isCollapsed(panel: HTMLElement): boolean {
  return isCollapsible(panel) && panel.hasAttribute('data-collapsed');
}

function setCollapsed(panel: HTMLElement, collapsed: boolean): void {
  if (collapsed === panel.hasAttribute('data-collapsed')) return;

  if (collapsed) {
    panel.setAttribute('data-collapsed', '');
  } else {
    panel.removeAttribute('data-collapsed');
  }
}

/**
 * The panels immediately before and after the given handle element,
 * in document order.
 */
function neighborsOf(
  handleElement: HTMLElement,
  panels: HTMLElement[]
): [HTMLElement | null, HTMLElement | null] {
  let prev: HTMLElement | null = null;
  let next: HTMLElement | null = null;

  for (const panel of panels) {
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
 * Sizes are floats that get re-derived (measurement, normalization),
 * so "unchanged" means within a small tolerance.
 */
function isSameSize(existing: number | undefined, size: number): boolean {
  return existing !== undefined && Math.abs(existing - size) < 0.0001;
}

/**
 * Pixel measurements round to device pixels, so re-measuring a layout
 * yields values that differ from the stored ones by sub-pixel noise.
 * Only differences beyond this (in %) count as real drift worth
 * adopting -- re-encoding identical pixels as slightly different
 * percentages would dirty every panel for no visual change.
 */
const MEASUREMENT_TOLERANCE = 0.25;

/**
 * Skips the write when the attribute already has the desired value,
 * so unchanged elements are left untouched.
 */
function setAttribute(element: Element, name: string, value: string): void {
  if (element.getAttribute(name) !== value) {
    element.setAttribute(name, value);
  }
}

interface Members {
  panels: HTMLElement[];
  handles: HTMLElement[];
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
  members: Members;
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

  /**
   * The percentage that a flex-grow of 1 represents in this group.
   *
   * Panels without an inline style render at the CSS default
   * (`flex: 1 1 0px`), so an all-equal group needs no styles at all --
   * mounting one writes nothing. The unit is fixed the first time a
   * panel actually diverges, and from then on grow values are written
   * relative to it, so panels whose share doesn't change keep their
   * (possibly absent) style untouched.
   */
  #unit: number | null = null;

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
    return this.#members().panels;
  }

  get handles(): HTMLElement[] {
    return this.#members().handles;
  }

  #members(): Members {
    const panels: HTMLElement[] = [];
    const handles: HTMLElement[] = [];
    const element = this.element;

    if (!element) return { panels, handles };

    for (const member of element.querySelectorAll<HTMLElement>(MEMBER_SELECTOR)) {
      if (member.closest(GROUP_SELECTOR) !== element) continue;

      (member.classList.contains(PANEL_CLASS) ? panels : handles).push(member);
    }

    return { panels, handles };
  }

  get sizes(): number[] {
    return this.panels.map((panel) => this.#sizes.get(panel) ?? 0);
  }

  /**
   * One MutationObserver for every group on the page. Each record is
   * routed to the group that owns it (the nearest group ancestor), so
   * churn inside a nested group never even pings its ancestors.
   */
  static #observed = new Map<HTMLElement, GroupState>();
  static #observer: MutationObserver | null = null;

  static #observerOptions: MutationObserverInit = {
    childList: true,
    subtree: true,
    attributes: true,
    attributeFilter: ['data-orientation'],
    // to distinguish real changes from same-value writes (see below)
    attributeOldValue: true,
  };

  static #handleMutations(mutations: MutationRecord[]): void {
    /**
     * true = the group's own data-orientation changed,
     * false = something in its subtree changed (membership check needed)
     */
    const affected = new Map<GroupState, boolean>();

    for (const mutation of mutations) {
      const target = mutation.target;

      if (!(target instanceof Element)) continue;

      if (mutation.type === 'attributes') {
        const group = GroupState.#observed.get(target as HTMLElement);

        /**
         * setAttribute queues a record even when the value is
         * unchanged (renderers do rewrite attributes with the same
         * value); only actual changes warrant a relayout.
         */
        const changed =
          mutation.attributeName &&
          mutation.oldValue !== target.getAttribute(mutation.attributeName);

        if (group && changed) affected.set(group, true);
        continue;
      }

      const groupElement = target.closest<HTMLElement>(GROUP_SELECTOR);
      const group = groupElement && GroupState.#observed.get(groupElement);

      if (group && !affected.has(group)) affected.set(group, false);
    }

    for (const [group, orientationChanged] of affected) {
      const members = group.#members();

      if (orientationChanged || group.#membershipChanged(members)) group.#layout(members);
    }
  }

  static #observe(element: HTMLElement, group: GroupState): void {
    GroupState.#observed.set(element, group);
    GroupState.#observer ??= new MutationObserver((mutations) =>
      GroupState.#handleMutations(mutations)
    );
    GroupState.#observer.observe(element, GroupState.#observerOptions);
  }

  static #unobserve(element: HTMLElement): void {
    GroupState.#observed.delete(element);

    const observer = GroupState.#observer;

    if (!observer) return;

    /**
     * MutationObserver has no per-target unobserve; disconnect and
     * re-observe the remaining groups (rare -- teardown only).
     */
    observer.disconnect();

    if (GroupState.#observed.size === 0) {
      GroupState.#observer = null;

      return;
    }

    for (const remaining of GroupState.#observed.keys()) {
      observer.observe(remaining, GroupState.#observerOptions);
    }
  }

  /**
   * Called (via modifier) when the group element is inserted.
   * Watches for panels being added/removed (and the orientation
   * changing) and performs the initial layout.
   */
  attach = (element: HTMLElement): (() => void) => {
    this.element = element;

    GroupState.#observe(element, this);

    this.#layout();

    return () => {
      GroupState.#unobserve(element);
      this.element = null;
    };
  };

  #membershipChanged(members: Members): boolean {
    return (
      !sameMembers(members.panels, this.#knownPanels) ||
      !sameMembers(members.handles, this.#knownHandles)
    );
  }

  /**
   * Panels that already have a size (or request one via `data-size`)
   * keep it; new panels take a share of the remaining space; everything
   * is normalized to 100.
   */
  #layout(members: Members = this.#members()): void {
    const { panels, handles } = members;

    if (this.#drag) this.#drag.members = members;

    this.#knownPanels = panels;
    this.#knownHandles = handles;

    if (panels.length === 0) return;

    let changed = false;

    // forget sizes of panels that left the DOM
    const current = new Set(panels);

    for (const known of this.#sizes.keys()) {
      if (!current.has(known)) {
        this.#sizes.delete(known);
        changed = true;
      }
    }

    // scratch space for the math below; #sizes itself is only
    // touched at the end, and only where values actually changed
    const computed = new Map<HTMLElement, number>();
    const unspecified: HTMLElement[] = [];
    let specifiedTotal = 0;

    for (const panel of panels) {
      const preferred = this.#sizes.get(panel) ?? requestedSizeOf(panel);

      if (preferred === undefined) {
        unspecified.push(panel);
        continue;
      }

      const size = isCollapsed(panel)
        ? preferred
        : clamp(preferred, minSizeOf(panel), maxSizeOf(panel));

      computed.set(panel, size);
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

          for (const [panel, size] of computed) {
            computed.set(panel, size * scale);
          }
        }
      }

      for (const panel of unspecified) {
        computed.set(panel, clamp(share, minSizeOf(panel), maxSizeOf(panel)));
      }
    }

    // normalize to 100
    let total = 0;

    for (const size of computed.values()) total += size;

    if (total > 0 && Math.abs(total - 100) > 0.01) {
      for (const [panel, size] of computed) {
        computed.set(panel, (size / total) * 100);
      }
    }

    /**
     * Commit minimally: keep the #sizes map, update only entries whose
     * value actually changed (with a small tolerance, so float dust
     * from re-normalizing doesn't count as a change).
     */
    const changedPanels: HTMLElement[] = [];

    for (const [panel, size] of computed) {
      if (!isSameSize(this.#sizes.get(panel), size)) {
        this.#sizes.set(panel, size);
        changedPanels.push(panel);
        changed = true;
      }
    }

    this.#apply(changedPanels, members);

    if (changed) this.#notify(panels);
  }

  /**
   * Writes the layout back to the DOM: flex sizing for exactly the
   * candidate panels whose rendered share would actually change, plus
   * the handles' ARIA attributes (which are guarded per-attribute).
   * (`data-collapsed` is managed at the explicit collapse/expand
   * points, not derived from sizes -- rendered pixel sizes include
   * borders/padding, so a collapsed panel rarely measures exactly 0.)
   */
  #apply(candidates: HTMLElement[], members: Members): void {
    /**
     * With no unit fixed yet, nothing has ever been written, so every
     * panel renders at the CSS default -- an equal 1/n share.
     */
    const unit = this.#unit ?? 100 / members.panels.length;

    for (const panel of candidates) {
      const size = this.#sizes.get(panel);

      if (size === undefined) continue;

      const inlineGrow = panel.style.flexGrow;
      const impliedPercent = (inlineGrow === '' ? 1 : parseFloat(inlineGrow)) * unit;

      if (isSameSize(impliedPercent, size)) continue;

      this.#unit ??= unit;
      panel.style.flex = `${size / unit} 1 0px`;
    }

    this.#syncHandles(members);
  }

  /**
   * Per the window-splitter pattern, each handle describes the panel
   * immediately before it. (A splitter between two side-by-side panes
   * is oriented *vertically*, and vice-versa.)
   */
  #syncHandles(members: Members): void {
    const { panels, handles } = members;
    const ariaOrientation = this.#isHorizontal ? 'vertical' : 'horizontal';

    let index = 0;

    for (const handle of handles) {
      let following = panels[index];

      while (following && precedes(following, handle)) {
        index++;
        following = panels[index];
      }

      const prev = panels[index - 1];

      setAttribute(handle, 'aria-orientation', ariaOrientation);

      if (!prev) continue;

      // Panels render their own (component-owned, incrementing) id
      if (prev.id) setAttribute(handle, 'aria-controls', prev.id);

      setAttribute(handle, 'aria-valuemin', `${minSizeOf(prev)}`);
      setAttribute(handle, 'aria-valuemax', `${maxSizeOf(prev)}`);
      setAttribute(handle, 'aria-valuenow', `${Math.round(this.#sizes.get(prev) ?? 0)}`);
    }
  }

  #notify(panels: HTMLElement[]): void {
    this.#options.onLayoutChange()?.(panels.map((panel) => this.#sizes.get(panel) ?? 0));
  }

  /**
   * Re-derive percentage sizes from actual rendered pixels.
   * Corrects any drift (e.g. from CSS min-sizes) before an interaction.
   */
  #syncSizesFromDOM(panels: HTMLElement[], measured?: number[]): void {
    // collapsed panels are 0 even though their borders/padding measure larger
    const px = panels.map((panel, index) =>
      isCollapsed(panel) ? 0 : (measured?.[index] ?? this.#pixelSizeOf(panel))
    );
    const total = px.reduce((sum, value) => sum + value, 0);

    if (total <= 0) return;

    panels.forEach((panel, index) => {
      const size = ((px[index] ?? 0) / total) * 100;
      const existing = this.#sizes.get(panel);

      if (existing === undefined || Math.abs(existing - size) > MEASUREMENT_TOLERANCE) {
        this.#sizes.set(panel, size);
      }
    });
  }

  #pixelSizeOf(panel: HTMLElement): number {
    const box = panel.getBoundingClientRect();

    return this.#isHorizontal ? box.width : box.height;
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
    requestedDelta: number,
    members: Members
  ): void {
    const total = basePrevSize + baseNextSize;
    const prevMin = minSizeOf(prev);
    const prevMax = maxSizeOf(prev);
    const prevCollapsible = isCollapsible(prev);

    let target = basePrevSize + requestedDelta;

    if (prevCollapsible && target < prevMin) {
      /**
       * Collapsible panels snap: below half the minimum they close
       * entirely; between half and the minimum they hold at the minimum.
       * (This also keeps a collapsed panel closed when its handle is
       * dragged further in the closing direction.)
       */
      target = target < prevMin / 2 ? 0 : prevMin;
    } else {
      target = clamp(target, prevMin, prevMax);
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
    if (!prevCollapsible && (target < prevMin || target > prevMax)) return;

    /**
     * Nothing to do when the clamped result matches the current sizes
     * (e.g. every pointermove past a min/max limit).
     */
    if (
      isSameSize(this.#sizes.get(prev), target) &&
      isSameSize(this.#sizes.get(next), total - target)
    ) {
      return;
    }

    if (prevCollapsible) {
      if (target === 0 && !isCollapsed(prev)) {
        this.#previousSizes.set(prev, basePrevSize);
      }

      setCollapsed(prev, target === 0);
    }

    this.#sizes.set(prev, target);
    this.#sizes.set(next, total - target);

    this.#apply([prev, next], members);
    this.#notify(members.panels);
  }

  startDrag(handleElement: HTMLElement, event: PointerEvent): void {
    if (event.button !== 0) return;
    if (this.#drag) return;

    const members = this.#members();
    const [prev, next] = neighborsOf(handleElement, members.panels);

    if (!prev || !next) return;

    const measured = members.panels.map((panel) => this.#pixelSizeOf(panel));

    this.#syncSizesFromDOM(members.panels, measured);

    const move = (moveEvent: PointerEvent) => this.#dragMove(moveEvent);
    const end = (endEvent: PointerEvent) => this.#endDrag(handleElement, endEvent);

    this.#drag = {
      prev,
      next,
      startPrevSize: this.#sizes.get(prev) ?? 0,
      startNextSize: this.#sizes.get(next) ?? 0,
      startCoordinate: this.#isHorizontal ? event.clientX : event.clientY,
      totalPx: measured.reduce((sum, value) => sum + value, 0),
      members,
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

    handleElement.addEventListener('pointermove', move);
    handleElement.addEventListener('pointerup', end);
    handleElement.addEventListener('pointercancel', end);
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

    this.#applyDelta(
      drag.prev,
      drag.next,
      drag.startPrevSize,
      drag.startNextSize,
      deltaPercent,
      drag.members
    );
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
    const members = this.#members();
    const [prev, next] = neighborsOf(handleElement, members.panels);

    if (!prev || !next) return;

    if (event.key === 'Enter') {
      this.#toggleCollapse(prev, next, members);

      return;
    }

    const step = event.shiftKey ? KEYBOARD_STEP_COARSE : KEYBOARD_STEP;
    const isHorizontal = this.#isHorizontal;

    let toDelta: ((prevSize: number) => number) | null = null;

    switch (event.key) {
      case 'ArrowLeft':
        if (isHorizontal) toDelta = () => -step;

        break;
      case 'ArrowRight':
        if (isHorizontal) toDelta = () => step;

        break;
      case 'ArrowUp':
        if (!isHorizontal) toDelta = () => -step;

        break;
      case 'ArrowDown':
        if (!isHorizontal) toDelta = () => step;

        break;
      case 'Home':
        toDelta = (prevSize) => minSizeOf(prev) - prevSize;

        break;
      case 'End':
        toDelta = (prevSize) => maxSizeOf(prev) - prevSize;

        break;
    }

    if (!toDelta) return;

    event.preventDefault();

    this.#syncSizesFromDOM(members.panels);

    const prevSize = this.#sizes.get(prev) ?? 0;

    this.#applyDelta(prev, next, prevSize, this.#sizes.get(next) ?? 0, toDelta(prevSize), members);
  }

  /**
   * Collapses (or restores) the panel before the handle,
   * giving the space to (or taking it from) the panel after it.
   *
   * Only does anything when the preceding panel is `@collapsible`.
   */
  #toggleCollapse(prev: HTMLElement, next: HTMLElement, members: Members): void {
    if (!isCollapsible(prev)) return;

    this.#syncSizesFromDOM(members.panels);

    const prevSize = this.#sizes.get(prev) ?? 0;
    const nextSize = this.#sizes.get(next) ?? 0;

    if (isCollapsed(prev)) {
      const preferred =
        this.#previousSizes.get(prev) ?? requestedSizeOf(prev) ?? Math.max(minSizeOf(prev), 10);
      const available = nextSize - minSizeOf(next);
      const restored = Math.min(preferred, available);

      if (restored <= 0) return;

      setCollapsed(prev, false);
      this.#sizes.set(prev, restored);
      this.#sizes.set(next, nextSize - restored);
    } else {
      this.#previousSizes.set(prev, prevSize);
      setCollapsed(prev, true);
      this.#sizes.set(prev, 0);
      this.#sizes.set(next, nextSize + prevSize);
    }

    this.#apply([prev, next], members);
    this.#notify(members.panels);
  }
}
