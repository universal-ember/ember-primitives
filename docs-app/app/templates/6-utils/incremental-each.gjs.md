# IncrementalEach

A drop-in replacement for `{{#each}}` that renders a collection a batch at a time across several animation frames.

Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor links, screen readers, print, and SEO all work against the full list. Spreading the work across frames keeps the page responsive (clicks, scrolling, hover effects keep working) instead of stalling on one long task.

Use this for non-scrollable containers, or anywhere a virtual/windowed list does not apply (variable item heights, lists that grow the page, surfaces that need every row indexable). For a fixed-size scrollable viewport with a known item size, a virtual list will use less memory and produce less DOM.


## Install

```hbs live
<SetupInstructions @src="components/incremental-each.gts" />
```


## Usage

The demo renders 1,000 rows in batches of 100. The same shape scales to 10,000+ rows.

<div class="featured-demo">

```gjs live preview no-shadow
import { IncrementalEach } from 'ember-primitives';

const rows = Array.from({ length: 1_000 }, (_, i) => `Row ${i + 1}`);

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


## Batch size

`@batchSize` is the number of items added per animation frame. Defaults to `50`. Must be positive; `0` or less asserts in development.

Bigger batches finish sooner. Smaller batches keep the main thread freer between frames.

```gjs
import { IncrementalEach } from 'ember-primitives';

<template>
  <IncrementalEach @items={{this.rows}} @batchSize={{100}} as |row|>
    <my-row @row={{row}} />
  </IncrementalEach>
</template>
```


## onDone

`@onDone` fires once after the last batch lands in the DOM. It re-fires if `@items` is replaced and the new collection finishes rendering.

```gjs
import { IncrementalEach } from 'ember-primitives';

<template>
  <IncrementalEach
    @items={{this.rows}}
    @batchSize={{50}}
    @onDone={{this.scrollToAnchor}}
    as |row|
  >
    <my-row @row={{row}} />
  </IncrementalEach>
</template>
```


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

`IncrementalEach` registers an `@ember/test-waiters` waiter while batches are pending, so `await render(...)` and `await settled()` both wait for the full list. Tests can assert against the complete DOM just like with `{{#each}}`.
