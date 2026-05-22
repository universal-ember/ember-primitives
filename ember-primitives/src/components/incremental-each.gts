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
     * Replacing the array (new identity) restarts rendering from the first batch.
     */
    items: readonly T[];

    /**
     * How many items to render per animation frame.
     *
     * Default: 50. Must be positive; `0` or less asserts in development.
     */
    batchSize?: number;

    /**
     * Called once after the last batch has been committed to the DOM.
     *
     * Re-fires if `@items` is replaced and the new collection finishes rendering.
     */
    onDone?: () => void;
  };
  Blocks: {
    /**
     * Yielded for each rendered item, with the index in the original `@items` array.
     */
    default: [item: T, index: number];
  };
}

/**
 * A drop-in replacement for `{{#each}}` that renders a large collection a
 * batch at a time, on consecutive animation frames, instead of all at once.
 *
 * Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor
 * links, screen readers, print, and SEO all work against the full list.
 * Spreading the work across frames keeps the page responsive during the
 * initial render.
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

  private frame: number | null = null;

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

    if (this.renderedCount < items.length && this.frame === null) {
      this.scheduleNextBatch();
    }
  };

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
