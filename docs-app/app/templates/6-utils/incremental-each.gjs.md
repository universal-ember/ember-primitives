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
import { cell } from 'ember-resources';
import { on } from '@ember/modifier';

const rows = Array.from({ length: 20_000 }, (_, i) => `Row ${i + 1}`);
const visible = cell(true);
const startedAt = cell(performance.now());
const elapsedMs = cell(null);

const toggle = () => {
  if (visible.current) {
    visible.current = false;
    elapsedMs.current = null;
  } else {
    startedAt.current = performance.now();
    visible.current = true;
  }
};

const handleDone = () => {
  elapsedMs.current = Math.round(performance.now() - startedAt.current);
};

<template>
  <div class="incremental-card not-prose">
    <div class="incremental-controls">
      <button type="button" {{on "click" toggle}}>
        {{if visible.current "Hide" "Show"}} rows
      </button>
      {{#if visible.current}}
        <span class="incremental-count">
          {{rows.length}} rows
          {{#if elapsedMs.current}}
            · rendered in {{elapsedMs.current}}ms
          {{/if}}
        </span>
      {{/if}}
    </div>

    {{#if visible.current}}
      <ul class="incremental-demo">
        <IncrementalEach
          @items={{rows}}
          @batchSize={{100}}
          @onDone={{handleDone}}
          as |row index|
        >
          <li>{{index}}: {{row}}</li>
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
