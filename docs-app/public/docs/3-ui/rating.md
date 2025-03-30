# Rating

Ratings are used for displaying a score within a given range.

When interactive, the underlying implementation is a radio button for maximum accessibility.


<div class="featured-demo">

```gjs live preview no-shadow
import { Rating } from 'ember-primitives';

<template>
  <Rating @value={{2}}>
    <:label>Rate me</:label>
  </Rating>

  <style>
    .ember-primitives__rating__items {
      width: fit-content;
      display: grid;
      gap: 0.5rem;
      grid-auto-flow: column;
      justify-content: center;
      align-items: center;
      height: 4rem;
    }

      input { color: black; }

    .ember-primitives__rating__item {
        font-size: 3rem;
        line-height: 3rem;
        transition: all 0.1s;
        transform-origin: center;
        aspect-ratio: 1 / 1;
        cursor: pointer;
        user-select: none;

      input {
          display: none;
      }

      &[data-selected] {
        color: gold;
      }
    } 

    .ember-primitives__rating__item:hover {
        transform: rotate3d(0, 0, 1, 15deg) scale(1.05);
    } 
  </style>
</template>
```

</div>

<details><summary>non-interactive (display-only) mode</summary>
<div class="featured-demo">

```gjs live preview 
import { Rating } from 'ember-primitives';

<template>
  <Rating @value={{2}} @interactive={{false}} />
  <Rating @value={{4}} @interactive={{false}}>
    <:label as |rating|>
      {{rating.value}} of {{rating.total}}
    </:label>
  </Rating>
  {{!--
  <Rating @value={{3}} @interactive={{false}} as |rating|>
    <rating.Stars />
    <rating.Label as |state|>
      {{state.value}} of {{state.total}}
    </rating.Label>
  </Rating>
  --}}

  <style>
    fieldset { border: none; padding: 0; }
    .ember-primitives__rating {
      width: fit-content;
      display: grid;
      gap: 0.5rem;
      grid-auto-flow: column;
      justify-content: center;
      align-items: center;
      height: 4rem;
    }

    input { color: black; }

    .ember-primitives__rating__item {
        font-size: 3rem;
        line-height: 3rem;
        transition: all 0.1s;
        transform-origin: center;
        aspect-ratio: 1 / 1;
        cursor: pointer;
        user-select: none;

      input {
          display: none;
      }

      &[data-selected] {
        color: gold;
      }
    } 

    .ember-primitives__rating__item:hover {
        transform: rotate3d(0, 0, 1, 15deg) scale(1.05);
    } 

    [visually-hidden] {
      position: absolute;
      border: 0;
      width: 1px;
      height: 1px;
      padding: 0;
      margin: -1px;
      overflow: hidden;
      clip: rect(0, 0, 0, 0);
      white-space: nowrap;
      word-wrap: normal;
    }
  </style>
</template>
```

</div>
</details>
<details><summary>Custom Component / Icons</summary>
<div class="featured-demo">

```gjs live preview no-shadow
import { Rating } from 'ember-primitives';

const Selected = <template>
  <div ...attributes>(x)</div>
</template>;

<template>
  <Rating id="demo3" @icon={{Selected}} />

  <style>
    #demo2 {
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
          font-family: monospace;
      } 

      .ember-primitives__rating__item:hover {
          transform: rotate3d(0, 0, 1, 15deg) scale(1.05);
      } 
    }
  </style>
</template>
```

</div>
</details>
<details><summary>Fractional Ratings</summary>
<div class="featured-demo">

```gjs live preview no-shadow
import { Rating } from 'ember-primitives';

const Star = <template>
    <div class="item">
        <span class="icon">★</span>
        <div class="overlay" style="var --percent: {{@percentSelected}};"></div>
    </div>
  </template>;

<template>
  <Rating id="demo4" @icon={{Star}} @iconSelected={{Star}} />

  <style>
    #demo4 {
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
          font-family: monospace;
      } 

      .ember-primitives__rating__item:hover {
          transform: rotate3d(0, 0, 1, 15deg) scale(1.05);
      } 
    }
  </style>
</template>
```

</div>
</details>

## Features

- Any shape can be used
- All styles / directions possible via CSS
- Full componets can be passed for the rating items / stars, and will have all the same information is available (properties, state, etc). This allows for custom icons, svgs, or some more complex pattern.

## Accessibility

Keyboard users can always change the star rating as every variant of the component has individually selectable elements.

Screen reader users will have a summary of the state of the component read to them as "Rated $Current of $Total"

## Testing

```ts
import * as primitiveHelpers from 'ember-primitives/test-support';

const rating = primitiveHelpers.rating();
```


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
- `ember-primitives__rating__items`
- `ember-primitives__rating__item`
- `ember-primitives__rating__label`

### State Attributes

#### The root element

- `data-total`
- `data-value`

#### Each Item

- `data-number`
- `data-selected`
- `data-readonly`
- `data-disabled`
