# IncrementalEach

A drop-in replacement for `{{#each}}` that renders a collection a batch at a time during the browser's idle periods.

Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor links, screen readers, print, and SEO all work against the full list. Yielding the main thread between batches keeps the page responsive (clicks, scrolling, hover effects keep working) while the rest of the list is filling in.

Use this for non-scrollable containers, or anywhere a virtual/windowed list does not apply (variable item heights, lists that grow the page, surfaces that need every row indexable). For a fixed-size scrollable viewport with a known item size, a virtual list will use less memory and produce less DOM.


## Install

```hbs live
<SetupInstructions @src="components/incremental-each.gts" />
```

Introduced in [0.58.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.58.0-ember-primitives)


## Usage

The demo renders 20,000 rows in batches of 100. Use Ctrl+F / Cmd+F to search for any row number to confirm every row is real DOM. Toggle the button to unmount and re-mount the list — each "Show" brings back the first batch in the same paint, then the rest streams in via idle callbacks.



<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { IncrementalEach } from 'ember-primitives';
import { trackedObject } from '@ember/reactive/collections';
import { on } from '@ember/modifier';

const BATCH_SIZE = 100;
const rows = Array.from({ length: 20_000 }, (_, i) => `Row ${i + 1}`);

const state = trackedObject({
  visible: true,
  elapsedMs: 0,
  batches: 0,
  done: false,
});

// Not tracked: plain mutable state used to drive `state.elapsedMs`.
// Reading it from a render path doesn't entangle with anything.
let startedAt = performance.now();
let tickId = null;

const stopTicker = () => {
  if (tickId !== null) {
    clearInterval(tickId);
    tickId = null;
  }
};

const sample = () => {
  state.elapsedMs = Math.round(performance.now() - startedAt);
  const rendered = document.querySelectorAll('.incremental-demo li').length;
  state.batches = Math.ceil(rendered / BATCH_SIZE);
};

const startTicker = () => {
  stopTicker();
  tickId = setInterval(sample, 50);
};

const handleDone = () => {
  state.done = true;
  state.elapsedMs = Math.round(performance.now() - startedAt);
  // Use the source-of-truth count instead of polling the DOM here —
  // `@onDone` runs in a microtask before Glimmer has committed the
  // final batch to the DOM, so a `querySelectorAll` count would
  // under-report by one batch.
  state.batches = Math.ceil(rows.length / BATCH_SIZE);
  stopTicker();
};

const toggle = () => {
  if (state.visible) {
    state.visible = false;
    state.done = false;
    state.elapsedMs = 0;
    state.batches = 0;
    stopTicker();
  } else {
    startedAt = performance.now();
    state.done = false;
    state.elapsedMs = 0;
    state.batches = 0;
    state.visible = true;
    startTicker();
  }
};

startTicker();

<template>
  <div class="incremental-card not-prose">
    <div class="incremental-controls">
      <button type="button" {{on "click" toggle}}>
        {{if state.visible "Hide" "Show"}} rows
      </button>
      {{#if state.visible}}
        <span class="incremental-count">
          {{rows.length}} rows · {{state.batches}} batches ·
          {{state.elapsedMs}}ms{{if state.done " (done)"}}
        </span>
      {{/if}}
    </div>

    {{#if state.visible}}
      <ul class="incremental-demo">
        <IncrementalEach
          @items={{rows}}
          @batchSize={{BATCH_SIZE}}
          @onDone={{handleDone}}
          as |row|
        >
          <li>{{row}}</li>
        </IncrementalEach>
      </ul>
    {{/if}}
  </div>

  <style>
    .incremental-card {
      background: #fff;
      color: #111827;
      border-radius: 8px;
      padding: 1rem;
      box-shadow:
        0 10px 15px -3px rgb(0 0 0 / 0.1),
        0 4px 6px -4px rgb(0 0 0 / 0.1);
      display: flex;
      flex-direction: column;
      gap: 0.75rem;
    }
    .incremental-controls {
      display: flex;
      align-items: center;
      gap: 0.75rem;
    }
    .incremental-controls button {
      padding: 0.4rem 0.9rem;
      font: inherit;
      color: #fff;
      background: #4f46e5;
      border: 0;
      border-radius: 6px;
      cursor: pointer;
    }
    .incremental-controls button:hover {
      background: #4338ca;
    }
    .incremental-count {
      color: #6b7280;
      font-size: 0.875rem;
    }
    .incremental-demo {
      max-height: 320px;
      overflow: auto;
      background: #f9fafb;
      border: 1px solid #e5e7eb;
      border-radius: 6px;
      padding: 0.75rem 1rem;
      margin: 0;
      list-style: none;
    }
    .incremental-demo li {
      padding: 0.125rem 0;
      font-family: ui-monospace, SFMono-Regular, Menlo, monospace;
      font-size: 0.875rem;
      color: #111827;
    }
  </style>
</template>
```

</div>


## Anatomy

```js
import { IncrementalEach } from 'ember-primitives';
```

or for non-tree-shaking environments:

```js
import { IncrementalEach } from 'ember-primitives/components/incremental-each';
```

```gjs
import { IncrementalEach } from 'ember-primitives';

<template>
  <IncrementalEach
    @items={{this.items}}
    @batchSize={{50}}
    @initial="sync"
    as |item index|
  >
    {{index}}: {{item}}
  </IncrementalEach>
</template>
```


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/incremental-each"
    @name="Signature" />
</template>
```


## Tests

`IncrementalEach` registers an `@ember/test-waiters` waiter while batches are pending, so `await render(...)` and `await settled()` both wait for every batch. Tests can assert against the complete DOM just like with `{{#each}}`.
