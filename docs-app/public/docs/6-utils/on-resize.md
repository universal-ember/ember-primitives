# on-resize

Utility for efficiently interacting with a [`ResizeObserver`](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver) on any element.
No matter how many times `{{onResize}}` is used within your application, only one `ResizeObserver` will exist.

This utility also handles the ["ResizeObserver loop limit exceeded"](https://stackoverflow.com/questions/49384120/resizeobserver-loop-limit-exceeded) error that can happen when resize event happens too quickly for the _browser_ to handle.


## Setup

```bash 
pnpm add ember-primitives
```

## Usage

<div class="featured-demo">

```gjs live preview
import { onResize } from 'ember-primitives/on-resize';
import { cell } from 'ember-resources';

const inner = cell();

function handleResize(entry) {
  const { width, height } = entry.contentRect;

  inner.current = `${width} x ${height}`;
}

<template>
  Inner Dimensions: {{inner.current}}<br>

  <div class="resizable" {{onResize handleResize}}>
    Resize me
  </div>
  
  <style>
    .resizable {
      border: 2px black dashed;
      resize: both;
      overflow: auto;
      padding: 0.5rem;
    }
  </style>
</template>
```

</div>

## API Reference

```gjs live no-shadow
import { ModifierSignature } from 'kolay';

<template>
  <ModifierSignature 
    @package="ember-primitives" 
    @module="declarations/on-resize" 
    @name="Signature" />
</template>
```


## Reference

- originally from [ember-on-resize-modifier](https://github.com/PrecisionNutrition/ember-resize-kitchen-sink/tree/main/packages/ember-on-resize-modifier)
