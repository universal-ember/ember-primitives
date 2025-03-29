# Rating



<div class="featured-demo">

```gjs live preview no-shadow
import { Rating } from 'ember-primitives';

<template>
  <Rating />

  <style>
    .ember-primitives__rating {
      display: grid;
      gap: 0.5rem;
      grid-auto-flow: column;
      justify-content: center;
      align-items: center;
      height: 4rem;
    }

    .ember-primitives__rating__item {
        font-size: 3rem;
        line-height: 3rem;
        transition: all 0.1s;
        transform-origin: center;
        aspect-ratio: 1 / 1;
        cursor: pointer;
        user-select: none;
    } 

    .ember-primitives__rating__item:hover {
        transform: rotate3d(0, 0, 1, 15deg) scale(1.05);
    } 
  </style>
</template>
```

</div>

## Features

## Accessibility

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/rating" 
    @name="Rating" />
</template>
```

### Classes

- `ember-primitives__rating`
- `ember-primitives__rating__item`
- `ember-primitives__rating__label`

### State Attributes
