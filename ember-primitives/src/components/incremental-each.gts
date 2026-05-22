import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { isDestroyed, isDestroying, registerDestructor } from "@ember/destroyable";
import { buildWaiter } from "@ember/test-waiters";

import type Owner from "@ember/owner";

const DEFAULT_BATCH_SIZE = 50;

const waiter = buildWaiter("ember-primitives:incremental-each");

export interface Signature<T = unknown> {
  Args: {
    /**
     * The collection of items to render.
     *
     * Items are appended to the rendered output in batches.
     * Changing the array identity resets the render progress
     * and starts again from the first batch.
     */
    items: readonly T[];

    /**
     * How many items to render per batch.
     *
     * Each batch is appended on the next animation frame, yielding back to
     * the browser between batches so long lists don't block the main thread.
     * The very first batch is also scheduled via an animation frame, so the
     * initial paint isn't delayed by item rendering.
     *
     * Defaults to `50`. Must be a positive integer — a value of `0` or less
     * would never finish rendering and is asserted against in development.
     */
    batchSize?: number;

    /**
     * Optional callback fired once every item has been rendered.
     *
     * Called after the final batch is committed to the DOM. Re-fires if
     * `@items` is replaced and the new collection finishes rendering.
     */
    onDone?: () => void;
  };
  Blocks: {
    /**
     * Yielded for each item that is currently visible.
     *
     * Mirrors the block signature of the built-in `{{#each}}`:
     * the item, then its index in the original `@items` array.
     */
    default: [item: T, index: number];
  };
}

/**
 * Render a large collection incrementally, a batch at a time.
 *
 * Use this when you need to render a list that is too long to comfortably
 * render in a single frame, but for which a virtualized list does not
 * apply. Common cases:
 *
 * - The list lives inside a non-scrollable container (it grows the page
 *   rather than scrolling within a fixed-size viewport), so a virtual list
 *   cannot use scroll position to decide what to render.
 * - Items have variable, content-driven heights you don't want to measure.
 * - You want the entire list eventually in the DOM (for in-page search,
 *   anchor links, print, SEO, etc.) but want to avoid a long task on first
 *   paint.
 *
 * `IncrementalEach` is not a substitute for a virtual list when items render
 * inside a scrollable viewport with a known size — for that case a windowed
 * list will use less memory and produce less DOM.
 *
 * @example
 * ```gjs
 * import { IncrementalEach } from 'ember-primitives';
 *
 * <template>
 *   <ul>
 *     <IncrementalEach @items={{this.rows}} @batchSize={{50}} as |row index|>
 *       <li>{{index}}: {{row.label}}</li>
 *     </IncrementalEach>
 *   </ul>
 * </template>
 * ```
 */
export class IncrementalEach<T = unknown> extends Component<Signature<T>> {
  /**
   * Number of items currently rendered. Updated one batch at a time,
   * which causes the template to re-render with an expanded slice of `@items`.
   */
  @tracked private renderedCount = 0;

  /**
   * Identity of the array we last started rendering for. Used to detect when
   * `@items` is swapped for a new array so we can restart from the first
   * batch. Plain (non-tracked) so checking it doesn't create a render-time
   * dependency on top of `args.items` itself.
   */
  private itemsRef: readonly T[] | null = null;

  /**
   * The currently scheduled animation frame, if any. Cancelled when the
   * component is torn down or when `@items` changes mid-flight.
   */
  private frame: number | null = null;

  /**
   * Outstanding test-waiter token. Held open while a batch is pending so
   * `await settled()` in tests waits until the full list has been rendered.
   */
  private waiterToken: unknown = null;

  constructor(owner: Owner, args: Signature<T>["Args"]) {
    super(owner, args);

    registerDestructor(this, () => this.cancel());
  }

  /**
   * Effective batch size. A non-positive value would never finish rendering,
   * so anything `<= 0` is asserted against in development.
   */
  get batchSize(): number {
    const requested = this.args.batchSize ?? DEFAULT_BATCH_SIZE;

    assert(
      `<IncrementalEach> @batchSize must be a positive number, got ${requested}`,
      requested > 0,
    );

    return requested;
  }

  /**
   * The slice of items that should currently be rendered.
   *
   * Pure projection of `args.items` over the tracked `renderedCount` —
   * the side-effects that drive `renderedCount` forward live in
   * `tick`, which the template invokes before reading `visible`.
   */
  get visible(): readonly T[] {
    return (this.args.items ?? []).slice(0, this.renderedCount);
  }

  /**
   * Drive rendering forward by one frame.
   *
   * Invoked from the template before the `{{#each}}` consumes `visible`,
   * so any write to `renderedCount` here happens before its read in the
   * same render pass (preserving the autotrack write-before-read
   * invariant). Detects `@items` identity changes and resets, then
   * schedules the next batch on the next animation frame if there is
   * still work to do.
   */
  tick = () => {
    const items = this.args.items ?? [];

    if (items !== this.itemsRef) {
      this.itemsRef = items;
      this.cancel();
      this.renderedCount = 0;
    }

    if (this.renderedCount < items.length && this.frame === null) {
      this.scheduleNextBatch();
    }
  };

  /**
   * Schedule the next batch on the next animation frame.
   *
   * A test waiter is opened so `await settled()` in tests waits for the
   * full list to render. The frame is a no-op if the component (or its
   * owner) was torn down before the frame fired — the registered
   * destructor takes care of closing the waiter in that case.
   */
  private scheduleNextBatch() {
    this.waiterToken = waiter.beginAsync();

    this.frame = requestAnimationFrame(() => {
      this.frame = null;

      if (isDestroyed(this) || isDestroying(this)) return;

      const items = this.args.items ?? [];
      const next = Math.min(this.renderedCount + this.batchSize, items.length);

      this.renderedCount = next;
      this.endWaiter();

      if (next >= items.length) {
        this.args.onDone?.();
      }
    });
  }

  private cancel() {
    if (this.frame !== null) {
      cancelAnimationFrame(this.frame);
      this.frame = null;
    }

    this.endWaiter();
  }

  private endWaiter() {
    if (this.waiterToken !== null) {
      waiter.endAsync(this.waiterToken);
      this.waiterToken = null;
    }
  }

  <template>
    {{(this.tick)}}
    {{#each this.visible as |item index|}}
      {{yield item index}}
    {{/each}}
  </template>
}

export default IncrementalEach;
