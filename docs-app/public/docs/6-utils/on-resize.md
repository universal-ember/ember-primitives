# on-resize

## Usage

```gts
import { onResize } from 'ember-primitives/on-resize';

function handleResize({ target, contentRect: { width, height } }: ResizeObserverEntry) {
  target.classList.toggle('large', width > 1200);
  target.classList.toggle('portrait', height > width);
}

<template>
  <div {{onResize handleResize}}>
    Resize me
  </div>
</template>
```

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
