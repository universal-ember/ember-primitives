import Component from "@glimmer/component";
import type Owner from "@ember/owner";
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
export declare class IncrementalEach<T = unknown> extends Component<Signature<T>> {
    #private;
    constructor(owner: Owner, args: Signature<T>["Args"]);
    get i(): number;
    get bucketed(): {
        isReady: () => boolean;
        items: {
            value: T;
            index: number;
        }[];
    }[];
    tick: () => void;
    checkDone: () => void;
}
//# sourceMappingURL=incremental-each.d.ts.map