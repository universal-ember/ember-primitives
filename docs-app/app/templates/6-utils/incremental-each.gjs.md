# IncrementalEach

A drop-in replacement for `{{#each}}` that renders a collection a batch at a time during the browser's idle periods.

Every item ends up in the DOM, so browser find (Ctrl+F / Cmd+F), anchor links, screen readers, print, and SEO all work against the full list. Yielding the main thread between batches keeps the page responsive (clicks, scrolling, hover effects keep working) while the rest of the list is filling in.

Use this for non-scrollable containers, or anywhere a virtual/windowed list does not apply (variable item heights, lists that grow the page, surfaces that need every row indexable). For a fixed-size scrollable viewport with a known item size, a virtual list will use less memory and produce less DOM.


## Install

```hbs live
<SetupInstructions @src="components/incremental-each.gts" @since="0.58.0" />
```

## Usage

The demo renders 20,000 rows in batches of 400. Use Ctrl+F / Cmd+F to search for any row number to confirm every row is real DOM. Toggle the button to unmount and re-mount the list — each "Show" brings back the first batch in the same paint, then the rest streams in.



<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { IncrementalEach } from 'ember-primitives';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { on } from '@ember/modifier';

const BATCH_SIZE = 400;
const rows = Array.from({ length: 20_000 }, (_, i) => `Row ${i + 1}`);

export default class IncrementalEachDemo extends Component {
  @tracked visible = true;
  @tracked elapsedMs = 0;
  @tracked batches = 0;
  @tracked done = false;
  @tracked mode = 'lazy';

  startedAt = performance.now();
  tickId = null;

  constructor(owner, args) {
    super(owner, args);
    this.startTicker();
    registerDestructor(this, () => this.stopTicker());
  }

  stopTicker = () => clearInterval(this.tickId);

  sample = () => {
    if (this.done) return;
    this.elapsedMs = Math.round(performance.now() - this.startedAt);
    const rendered = document.querySelectorAll('.incremental-demo li').length;
    this.batches = Math.ceil(rendered / BATCH_SIZE);
  };

  startTicker = () => {
    this.stopTicker();
    this.tickId = setInterval(this.sample, 100);
  };

  handleDone = () => {
    this.done = true;
    this.elapsedMs = Math.round(performance.now() - this.startedAt);
    this.batches = Math.ceil(rows.length / BATCH_SIZE);
    this.stopTicker();
  };

  toggleMode = async () => {
    this.handleDone();
    this.stop(); 
    this.mode = this.mode === 'lazy' ? 'sync' : 'lazy';
    // we have to give enough time for ember to delete all the nodes from 
    // the stop() call above
    requestAnimationFrame(() => {
      this.start();
    });
  };

  start = () => {
    this.startedAt = performance.now();
    this.done = false;
    this.elapsedMs = 0;
    this.batches = 0;
    this.visible = true;
    this.startTicker();
  }

  stop = () => {
    this.visible = false;
    this.done = false;
    this.elapsedMs = 0;
    this.batches = 0;
    this.stopTicker();
  }

  toggle = () => {
    if (this.visible) {
      this.stop();
      return;
    }

    this.start();
  };

  <template>
    <div class="incremental-card not-prose">
      <div class="incremental-controls">
        <button type="button" {{on "click" this.toggleMode}}>
          Mode: {{this.mode}}
        </button>
        <button type="button" {{on "click" this.toggle}}>
          {{if this.visible "Hide" "Show"}} rows
        </button>
        {{#if this.visible}}
          <span class="incremental-count">
            {{rows.length}} rows · {{this.batches}} batches ·
            {{this.elapsedMs}}ms{{if this.done " (done)"}}
          </span>
        {{/if}}
      </div>

      {{#if this.visible}}
        <ul class="incremental-demo">
          <IncrementalEach
            @items={{rows}}
            @batchSize={{BATCH_SIZE}}
            @initial={{this.mode}}
            @onDone={{this.handleDone}}
            as |row|
          ><li>{{row}}</li></IncrementalEach>
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
}
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
