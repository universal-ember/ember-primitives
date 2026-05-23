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


> [!WARNING]

<div class="featured-demo">

```gjs live preview no-shadow
import { IncrementalEach } from 'ember-primitives';
import { cell } from 'ember-resources';
import { on } from '@ember/modifier';

const rows = Array.from({ length: 20_000 }, (_, i) => `Row ${i + 1}`);
const visible = cell(true);
const toggle = () => (visible.current = !visible.current);

<template>
  <div class="incremental-controls">
    <button type="button" {{on "click" toggle}}>
      {{if visible.current "Hide" "Show"}} rows
    </button>
  </div>

  {{#if visible.current}}
    <ul class="incremental-demo">
      <IncrementalEach @items={{rows}} @batchSize={{100}} as |row index|>
        <li>{{index}}: {{row}}</li>
      </IncrementalEach>
    </ul>
  {{/if}}

  <style>
    .incremental-controls {
      margin-bottom: 0.75rem;
    }
    .incremental-controls button {
      padding: 0.4rem 0.9rem;
      font: inherit;
      border: 1px solid gray;
      border-radius: 0.25rem;
      background: white;
      cursor: pointer;
    }
    .incremental-demo {
      max-height: 240px;
      overflow: auto;
      border: 1px solid gray;
      padding: 1rem;
      margin: 0;
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
