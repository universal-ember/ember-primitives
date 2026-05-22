# IncrementalEach

A component that renders a collection a batch at a time, on consecutive
animation frames, instead of all at once. Useful when you want every item
in the DOM eventually, but can't afford to render the whole list in a
single frame.

## When to reach for this

`IncrementalEach` is designed for **non-scrollable containers**, or for
any case where a virtualized list would not be applicable. Typical use
cases:

- The list lives in a container that grows the page (e.g. a long article,
  a settings page, a print/SEO surface) instead of scrolling within a
  fixed-size viewport — a virtual list has no scroll position to drive
  what to render.
- Items have variable, content-driven heights you don't want to measure
  up front.
- You want the entire list eventually in the DOM (for in-page search,
  anchor links, browser-find, accessibility) but want to break the
  rendering work across several frames so the page paints quickly.

If your items render inside a scrollable viewport of known size, a
windowed/virtual list will use less memory and produce less DOM —
`IncrementalEach` is **not** a replacement for that.

## Install

```hbs live
<SetupInstructions @src="components/incremental-each.gts" />
```

## Usage

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

## Batch size

Pass `@batchSize` to control how many items are added to the DOM per
animation frame. Defaults to `50`. Must be a positive number — a value
of `0` or less would never finish rendering and is asserted against in
development.

```gjs
import { IncrementalEach } from 'ember-primitives';

<template>
  <IncrementalEach @items={{this.rows}} @batchSize={{50}} as |row|>
    <my-row @row={{row}} />
  </IncrementalEach>
</template>
```

Larger batches finish sooner but each frame does more work; smaller
batches keep the main thread more responsive at the cost of taking more
total time.

## Knowing when rendering is done

Pass an `@onDone` callback if you need to react once every item has been
committed to the DOM (e.g. to focus something, scroll to an anchor, or
hide a "still loading" affordance). It re-fires if `@items` is replaced
and the new collection finishes rendering.

```gjs
import { IncrementalEach } from 'ember-primitives';

<template>
  <IncrementalEach
    @items={{this.rows}}
    @batchSize={{25}}
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
  <IncrementalEach @items={{this.items}} @batchSize={{20}} as |item index|>
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

## How it works

`IncrementalEach` keeps a tracked `renderedCount` that grows by
`@batchSize` on every animation frame until it reaches `@items.length`.
Each batch increment triggers a normal Glimmer re-render with a larger
slice of the source array.

The very first batch is also scheduled via an animation frame, so
mounting the component never blocks initial paint with item rendering —
the browser is free to paint surrounding content first, then the list
fills in.

Replacing `@items` with a different array identity resets the count to
zero and starts again from the first batch. Any pending frame is
cancelled, so swapping items mid-flight doesn't render orphaned chunks
of the previous collection.

Each pending batch holds an `@ember/test-waiters` waiter open, so
`await settled()` in tests waits for the full list to render. This means
your test can simply `await render(...)` and then assert against the
complete DOM, just like you would with `{{#each}}`.
