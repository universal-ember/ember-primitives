import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { registerDestructor, isDestroyed, isDestroying } from '@ember/destroyable';
import { buildWaiter } from '@ember/test-waiters';
import { cell } from 'ember-resources';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { n } from 'decorator-transforms/runtime';

const DEFAULT_BATCH_SIZE = 50;
const DEFAULT_INITIAL = "sync";
const waiter = buildWaiter("ember-primitives:incremental-each");
function chunk(arr, size) {
  const out = [];
  for (let i = 0; i < arr.length; i += size) {
    out.push(arr.slice(i, i + size));
  }
  return out;
}
// Safari has `requestIdleCallback` behind a flag, effectively absent
// for end users. Fall back to `setTimeout(cb, 0)` — Safari users get
// the chunking benefit (one batch per task) without the idle-priority
// hint that other browsers honor.
const ric = typeof requestIdleCallback === "function" ? requestIdleCallback : cb => setTimeout(() => cb({
  timeRemaining: () => 0,
  didTimeout: true
}), 0);
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
class IncrementalEach extends Component {
  #count = cell(0);
  #itemsRef = null;
  #waiterToken = null;
  #doneFor = null;
  constructor(owner, args) {
    super(owner, args);
    registerDestructor(this, () => this.#endWaiter());
  }
  // Reset progress and (re)open the test-waiter when `@items` identity
  // changes, so a swap restarts at the first batch, `@onDone` can fire
  // again for the new collection, and `await settled()` knows to wait
  // until `checkDone` closes the waiter. Mutating from a getter is safe
  // here because the writes happen before any consumer reads them in
  // the same render pass.
  /* eslint-disable ember/no-side-effects */
  get #items() {
    const items = this.args.items;
    assert(`@items must be an array`, items);
    if (items !== this.#itemsRef) {
      this.#itemsRef = items;
      this.#count.current = 0;
      this.#endWaiter();
      if (items.length > 0) {
        this.#waiterToken = waiter.beginAsync();
      }
    }
    return items;
  }
  /* eslint-enable ember/no-side-effects */ // `"sync"` keeps bucket 0 visible at count=0 (`i = 0 >= 0`); `"lazy"`
  // starts one step behind so even bucket 0 needs a tick.
  get #start() {
    return this.#initial === "sync" ? 0 : -1;
  }
  get i() {
    return this.#start + this.#count.current;
  }
  get bucketed() {
    const size = this.#batchSize;
    return chunk(this.#items, size).map((items, b) => {
      const start = b * size;
      return {
        isReady: () => this.i >= b,
        items: items.map((value, j) => ({
          value,
          index: start + j
        }))
      };
    });
  }
  static {
    n(this.prototype, "bucketed", [cached]);
  }
  get #batchSize() {
    const requested = this.args.batchSize ?? DEFAULT_BATCH_SIZE;
    assert(`<IncrementalEach> @batchSize must be a positive number, got ${requested}`, requested > 0);
    return requested;
  }
  get #initial() {
    const requested = this.args.initial ?? DEFAULT_INITIAL;
    assert(`<IncrementalEach> @initial must be "sync" or "lazy", got ${requested}`, requested === "sync" || requested === "lazy");
    return requested;
  }
  // `#items` is read before `#count` so the count-reset inside `#items`
  // (on `@items` swap) lands before this read of count this render —
  // otherwise tracked-value backtracking asserts.
  tick = () => {
    if (this.#items.length > this.#count.current) {
      ric(() => this.#count.current++, {
        timeout: 10
      });
    }
  };
  checkDone = () => {
    const bucketed = this.bucketed;
    if (this.#doneFor === bucketed) return;
    if (this.i < bucketed.length - 1) return;
    this.#doneFor = bucketed;
    queueMicrotask(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.args.onDone?.();
      this.#endWaiter();
    });
  };
  #endWaiter() {
    if (this.#waiterToken) waiter.endAsync(this.#waiterToken);
  }
  static {
    setComponentTemplate(precompileTemplate("{{(this.tick)}}{{#each this.bucketed as |bucket|}}{{#if (bucket.isReady)}}{{#each bucket.items as |entry|}}{{yield entry.value entry.index}}{{/each}}{{(this.checkDone)}}{{/if}}{{/each}}", {
      strictMode: true
    }), this);
  }
}

export { IncrementalEach };
//# sourceMappingURL=incremental-each.js.map
