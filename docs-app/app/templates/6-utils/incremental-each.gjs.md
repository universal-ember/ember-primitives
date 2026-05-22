# IncrementalEach

A drop-in replacement for `{{#each}}` that renders a collection a batch at a time during the browser's idle periods.

Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor links, screen readers, print, and SEO all work against the full list. Yielding the main thread between batches keeps the page responsive (clicks, scrolling, hover effects keep working) while the rest of the list is filling in.

Use this for non-scrollable containers, or anywhere a virtual/windowed list does not apply (variable item heights, lists that grow the page, surfaces that need every row indexable). For a fixed-size scrollable viewport with a known item size, a virtual list will use less memory and produce less DOM.


## Install

```hbs live
<SetupInstructions @src="components/incremental-each.gts" />
```


## Usage

The demo renders 10,000 rows in batches of 100. Use Ctrl+F / Cmd+F to search for any row number to confirm every row is real DOM.

<div class="featured-demo">

```gjs live preview no-shadow
import { IncrementalEach } from 'ember-primitives';

const rows = Array.from({ length: 10_000 }, (_, i) => `Row ${i + 1}`);

<template>
  <ul class="incremental-demo">
    <IncrementalEach @items={{rows}} @batchSize={{100}} as |row index|>
      <li>{{index}}: {{row}}</li>
    </IncrementalEach>
  </ul>

  <style>
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
  <IncrementalEach @items={{this.items}} @batchSize={{50}} as |item index|>
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
