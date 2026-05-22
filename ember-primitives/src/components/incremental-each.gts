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
 * Intended for non-scrollable containers, or anywhere a virtual/windowed
 * list does not apply (variable item heights, lists that grow the page,
 * surfaces that need every row indexable).
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
  @tracked private renderedCount = 0;

  // Plain field (not tracked) so identity checks don't add a render-time
  // dependency on top of `args.items`.
  private itemsRef: readonly T[] | null = null;

  private idleHandle: number | null = null;

  private waiterToken: unknown = null;

  constructor(owner: Owner, args: Signature<T>["Args"]) {
    super(owner, args);

    registerDestructor(this, () => this.cancel());
  }

  get batchSize(): number {
    const requested = this.args.batchSize ?? DEFAULT_BATCH_SIZE;

    assert(
      `<IncrementalEach> @batchSize must be a positive number, got ${requested}`,
      requested > 0,
    );

    return requested;
  }

  get visible(): readonly T[] {
    return (this.args.items ?? []).slice(0, this.renderedCount);
  }

  // Called from the template before `{{#each}}` reads `visible`. The
  // write-before-read order keeps autotrack happy on the same render pass.
  tick = () => {
    const items = this.args.items ?? [];

    if (items !== this.itemsRef) {
      this.itemsRef = items;
      this.cancel();
      this.renderedCount = 0;
    }

    if (this.renderedCount < items.length && this.idleHandle === null) {
      this.scheduleNextBatch();
    }
  };

  private scheduleNextBatch() {
    this.waiterToken = waiter.beginAsync();

    this.idleHandle = requestIdleCallback(() => {
      this.idleHandle = null;

      if (isDestroyed(this) || isDestroying(this)) return;

      const items = this.args.items ?? [];
      const next = Math.min(this.renderedCount + this.batchSize, items.length);

      this.renderedCount = next;
      this.endWaiter();
    });
  }

  private cancel() {
    if (this.idleHandle !== null) {
      cancelIdleCallback(this.idleHandle);
      this.idleHandle = null;
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
