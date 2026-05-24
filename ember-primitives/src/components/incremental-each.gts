import Component from "@glimmer/component";
import { cached } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { isDestroyed, isDestroying } from "@ember/destroyable";
import { buildWaiter } from "@ember/test-waiters";

import { cell } from "ember-resources";

const DEFAULT_BATCH_SIZE = 50;
const DEFAULT_INITIAL = "sync";

const waiter = buildWaiter("ember-primitives:incremental-each");

function chunk<T>(arr: readonly T[], size: number): T[][] {
  const out: T[][] = [];

  for (let i = 0; i < arr.length; i += size) {
    out.push(arr.slice(i, i + size));
  }

  return out;
}

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
     * How many items to add per animation frame.
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
     *   fills in one batch per animation frame. This is the right
     *   default for most lists — even a perceived "empty for one
     *   frame" is worse than rendering a few extra items synchronously.
     * - `"lazy"`: even the first batch waits for an animation frame, so
     *   the initial paint is empty and content arrives one batch per
     *   frame. Use this when the first batch itself would be expensive
     *   enough to block the first paint, and you'd rather show an
     *   empty container than delay it.
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
 * A drop-in replacement for `{{#each}}` that renders a large collection
 * a batch at a time on each animation frame, instead of all at once.
 *
 * Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor
 * links, screen readers, print, and SEO all work against the full list.
 * Yielding the main thread between batches keeps the page responsive while
 * the rest of the list is filling in.
 *
 * By default the first batch lands synchronously, so the user sees content
 * on the very first paint. Pass `@initial="lazy"` to defer the first batch
 * to an animation frame as well.
 *
 * Intended for non-scrollable containers, or anywhere a virtual/windowed
 * list does not apply (variable item heights, lists that grow the page,
 * surfaces that need every row indexable).
 *
 * Do not nest one `<IncrementalEach>` inside another. Each level adds an
 * animation-frame delay before its content paints; nesting compounds those
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
  #count = cell(0);
  #itemsRef: readonly T[] | null = null;
  #doneFor: object | null = null;

  // Reset progress when `@items` identity changes so a swap restarts at
  // the first batch (and so `@onDone` can fire again for the new
  // collection). Mutating `#count` from a getter is safe here because
  // the write happens before any consumer reads `#count` in the same
  // render pass.
  /* eslint-disable ember/no-side-effects */
  get #items(): readonly T[] {
    const items = this.args.items;

    assert(`@items must be an array`, items);

    if (items !== this.#itemsRef) {
      this.#itemsRef = items;
      this.#count.current = 0;
      this.#doneFor = null;
    }

    return items;
  }
  /* eslint-enable ember/no-side-effects */

  // `"sync"` keeps bucket 0 visible at count=0 (`i = 0 >= 0`); `"lazy"`
  // starts one step behind so even bucket 0 needs a tick.
  get #start() {
    return this.#initial === "sync" ? 0 : -1;
  }

  get i() {
    return this.#start + this.#count.current;
  }

  @cached
  get bucketed() {
    const size = this.#batchSize;

    return chunk(this.#items, size).map((items, b) => {
      const start = b * size;

      return {
        isReady: () => this.i >= b,
        items: items.map((value, j) => ({ value, index: start + j })),
      };
    });
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

  tick = () => {
    // Read `bucketed` before `i` so the count-reset inside `#items`
    // (on `@items` swap) happens before any read of `#count` this
    // render — otherwise tracked-value backtracking asserts.
    const lastIdx = this.bucketed.length - 1;

    if (this.i >= lastIdx) return;

    const token = waiter.beginAsync();

    requestIdleCallback(
      () => {
        if (!isDestroyed(this) && !isDestroying(this)) {
          this.#count.current++;
        }

        waiter.endAsync(token);
      },
      { timeout: 10 },
    );
  };

  checkDone = () => {
    const bucketed = this.bucketed;

    if (this.#doneFor === bucketed) return;
    if (this.i < bucketed.length - 1) return;

    this.#doneFor = bucketed;
    queueMicrotask(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.args.onDone?.();
    });
  };

  <template>
    {{(this.tick)}}{{#each this.bucketed as |bucket|}}{{#if (bucket.isReady)}}{{#each
          bucket.items
          as |entry|
        }}{{yield entry.value entry.index}}{{/each}}{{(this.checkDone)}}{{/if}}{{/each}}
  </template>
}
