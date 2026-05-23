import Component from "@glimmer/component";
import { assert } from "@ember/debug";
import { isDestroyed, isDestroying, registerDestructor } from "@ember/destroyable";
import { buildWaiter } from "@ember/test-waiters";

import { cell } from "ember-resources";

import type Owner from "@ember/owner";

const DEFAULT_BATCH_SIZE = 50;
const DEFAULT_INITIAL = "sync";

const waiter = buildWaiter("ember-primitives:incremental-each");

export interface Signature<T = unknown> {
  Args: {
    /**
     * The collection of items to render.
     *
     * Replacing the array (new identity) restarts rendering from the
     * first batch.
     *
     * ```gjs
     * import { IncrementalEach } from 'ember-primitives';
     *
     * <template>
     *   <IncrementalEach @items={{this.rows}} as |row|>
     *     <my-row @row={{row}} />
     *   </IncrementalEach>
     * </template>
     * ```
     */
    items: readonly T[];

    /**
     * How many items to add per idle callback.
     *
     * Larger batches add more items per chunk; smaller batches yield to
     * the browser more often.
     *
     * Default: 50. Must be positive; `0` or less asserts in development.
     *
     * ```gjs
     * import { IncrementalEach } from 'ember-primitives';
     *
     * <template>
     *   <IncrementalEach @items={{this.rows}} @batchSize={{100}} as |row|>
     *     <my-row @row={{row}} />
     *   </IncrementalEach>
     * </template>
     * ```
     */
    batchSize?: number;

    /**
     * Controls how the initial batch is committed.
     *
     * - `"sync"` (default): the first `@batchSize` items render in the
     *   same render pass as mount / `@items` change. The user sees
     *   content on the very first paint, and the rest of the list
     *   fills in via idle callbacks. This is the right default for
     *   most lists — even a perceived "empty for one frame" is worse
     *   than rendering a few extra items synchronously.
     * - `"lazy"`: even the first batch waits for an idle callback,
     *   so the initial paint is empty and content arrives one batch
     *   per idle tick. Use this when the first batch itself would be
     *   expensive enough to block the first paint, and you'd rather
     *   show an empty container than delay it.
     *
     * Default: `"sync"`.
     *
     * ```gjs
     * import { IncrementalEach } from 'ember-primitives';
     *
     * <template>
     *   <IncrementalEach @items={{this.rows}} @initial="lazy" as |row|>
     *     <my-row @row={{row}} />
     *   </IncrementalEach>
     * </template>
     * ```
     */
    initial?: "sync" | "lazy";

    /**
     * Called once with no arguments when every item in `@items` has
     * been committed to the DOM. Fires after the final batch lands;
     * does not fire on intermediate batches.
     *
     * Fires again on a fresh swap (new `@items` identity) once that
     * new collection finishes rendering. An empty `@items` array
     * does not fire the callback.
     *
     * Useful for marking the list as ready for screenshot tests,
     * dismissing a loading indicator, or measuring how long the
     * whole render took.
     *
     * ```gjs
     * import { IncrementalEach } from 'ember-primitives';
     *
     * <template>
     *   <IncrementalEach @items={{this.rows}} @onDone={{this.handleDone}} as |row|>
     *     <my-row @row={{row}} />
     *   </IncrementalEach>
     * </template>
     * ```
     */
    onDone?: () => void;
  };
  Blocks: {
    /**
     * Yielded for each rendered item, with the index in the original
     * `@items` array.
     *
     * ```gjs
     * import { IncrementalEach } from 'ember-primitives';
     *
     * <template>
     *   <IncrementalEach @items={{this.rows}} as |row index|>
     *     {{index}}: {{row.label}}
     *   </IncrementalEach>
     * </template>
     * ```
     */
    default: [item: T, index: number];
  };
}

/**
 * A drop-in replacement for `{{#each}}` that renders a large collection a
 * batch at a time during the browser's idle periods, instead of all at once.
 *
 * Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor
 * links, screen readers, print, and SEO all work against the full list.
 * Yielding the main thread between batches keeps the page responsive while
 * the rest of the list is filling in.
 *
 * By default the first batch lands synchronously, so the user sees content
 * on the very first paint. Pass `@initial="lazy"` to defer the first batch
 * to an idle callback as well.
 *
 * Intended for non-scrollable containers, or anywhere a virtual/windowed
 * list does not apply (variable item heights, lists that grow the page,
 * surfaces that need every row indexable).
 *
 * Do not nest one `<IncrementalEach>` inside another. Each level adds an
 * idle-callback delay before its content paints; nesting compounds those
 * delays, so inner rows appear to flicker in with missing sub-content.
 * If you have nested loops, only the outermost one should be
 * `<IncrementalEach>`; leave deeper loops as plain `{{#each}}`.
 *
 * @example
 * ```gjs
 * import { IncrementalEach } from 'ember-primitives';
 *
 * <template>
 *   <ul>
 *     <IncrementalEach @items={{this.rows}} @batchSize={{100}} as |row index|>
 *       <li>{{index}}: {{row.label}}</li>
 *     </IncrementalEach>
 *   </ul>
 * </template>
 * ```
 */
export class IncrementalEach<T = unknown> extends Component<Signature<T>> {
  // How many items have been committed to the DOM so far. Bumped one
  // batch at a time by the idle callback. Wrapped in a `cell` because
  // `@tracked` doesn't compose with `#`-private fields under this
  // codebase's decorator transform.
  #count = cell(0);

  // Plain field so identity checks don't add a render-time dependency
  // on top of `args.items`.
  #itemsRef: readonly T[] | null = null;

  #idleHandle: number | null = null;

  #waiterToken: unknown = null;

  // The `@items` reference we have already fired `@onDone` for. Reset
  // to `null` on every `@items` swap so a new collection can fire its
  // own completion callback.
  #onDoneFiredFor: readonly T[] | null = null;

  constructor(owner: Owner, args: Signature<T>["Args"]) {
    super(owner, args);

    registerDestructor(this, () => this.#cancel());
  }

  get #batchSize(): number {
    const requested = this.args.batchSize ?? DEFAULT_BATCH_SIZE;

    assert(
      `<IncrementalEach> @batchSize must be a positive number, got ${requested}`,
      requested > 0,
    );

    return requested;
  }

  get #initial(): "sync" | "lazy" {
    const requested = this.args.initial ?? DEFAULT_INITIAL;

    assert(
      `<IncrementalEach> @initial must be "sync" or "lazy", got ${requested}`,
      requested === "sync" || requested === "lazy",
    );

    return requested;
  }

  // The items that should currently be rendered. This is also where
  // scheduling is driven from: `@items` identity changes reset
  // `#count` (to the first batch under `@initial="sync"`, or to zero
  // under `@initial="lazy"`), and any remaining items queue the next
  // idle callback. Autotrack stays consistent because the only
  // synchronous writes here (`#count.current = ...`) happen before
  // `#count` is read.
  /* eslint-disable ember/no-side-effects */
  get visible(): readonly T[] {
    const items = this.args.items ?? [];

    if (items !== this.#itemsRef) {
      this.#itemsRef = items;
      this.#onDoneFiredFor = null;
      this.#cancel();
      this.#count.current = this.#initial === "sync" ? Math.min(this.#batchSize, items.length) : 0;
    }

    if (this.#count.current < items.length && this.#idleHandle === null) {
      this.#scheduleNextBatch();
    } else {
      // Already at the end (sync mode finished the whole list in one
      // batch, or batches landed and we just re-rendered). Schedule
      // `@onDone` so it fires after this render commits.
      this.#maybeFireDone();
    }

    return items.slice(0, this.#count.current);
  }
  /* eslint-enable ember/no-side-effects */

  #maybeFireDone() {
    const items = this.#itemsRef ?? [];

    if (items.length === 0) return;
    if (this.#count.current < items.length) return;
    if (this.#onDoneFiredFor === items) return;

    this.#onDoneFiredFor = items;

    // Defer to a microtask so the callback runs after the current
    // render commits, not during it.
    queueMicrotask(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.args.onDone?.();
    });
  }

  #scheduleNextBatch() {
    // Defensive: if a batch is already pending, drop it before
    // queueing a new one. The `visible` getter already guards on
    // `#idleHandle === null`, but a future caller might not.
    this.#cancel();

    this.#waiterToken = waiter.beginAsync();

    // The `timeout` cap ensures forward progress even when the host
    // is CPU-bound and the browser never reports a free idle slot.
    // In normal use this is a no-op because real idle time arrives
    // far sooner.
    this.#idleHandle = requestIdleCallback(
      () => {
        this.#idleHandle = null;

        if (isDestroyed(this) || isDestroying(this)) return;

        const items = this.args.items ?? [];

        this.#count.current = Math.min(this.#count.current + this.#batchSize, items.length);
        this.#endWaiter();
        this.#maybeFireDone();
      },
      { timeout: 100 },
    );
  }

  #cancel() {
    if (this.#idleHandle !== null) {
      cancelIdleCallback(this.#idleHandle);
      this.#idleHandle = null;
    }

    this.#endWaiter();
  }

  #endWaiter() {
    if (this.#waiterToken !== null) {
      waiter.endAsync(this.#waiterToken);
      this.#waiterToken = null;
    }
  }

  <template>
    {{#each this.visible as |item index|}}
      {{yield item index}}
    {{/each}}
  </template>
}
