# Rating

Ratings are used for displaying a score within a given range.

When interactive, the underlying implementation is a radio button for maximum accessibility.

<div class="featured-demo">

```gjs live preview
import { Rating } from 'ember-primitives';
import { cell } from 'ember-resources';

const capturedValue = cell(2);

<template>
  Current Value: {{capturedValue.current}}<br><hr>
  <Rating @value={{capturedValue.current}} @onChange={{capturedValue.set}}>
    <:label>Rate me</:label>
  </Rating>

  <style>
    @import "/demo-support/utilities.css";

    .ember-primitives__rating__items {
      width: fit-content;
      display: grid;
      gap: 0.5rem;
      grid-auto-flow: column;
      justify-content: center;
      align-items: center;
      height: 4rem;
    }

    .ember-primitives__rating__item {
      font-size: 3rem;
      line-height: 1em;
      transition: all 0.1s;
      transform-origin: center;
      aspect-ratio: 1 / 1;
      user-select: none;
      width: 3rem;
      text-align: center;
      border-radius: 1.5rem;

      label:hover {
        cursor: pointer;
      }

      &:has(input:focus-visible) {
        --tw-ring-opacity: 1;
        --tw-ring-offset-color: #000;
        --tw-ring-offset-width: 2px;
        --tw-ring-color: rgb(224 78 57 / var(--tw-ring-opacity, 1));
        --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
        --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color);
        box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000);
        outline: 2px solid transparent;
        outline-offset: 2px;
      }

      input {
        appearance: none;
        position: absolute;

        &:focus-visible, &:focus {
          outline: none;
          box-shadow: none;
        }
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
  <Rating @value={{3}} @interactive={{false}} as |rating|>
    <rating.Stars />
    {{rating.value}} of {{rating.total}}
  </Rating>

  <style>
    @import "/demo-support/utilities.css";

    .ember-primitives__rating {
      width: fit-content;
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
</details>
<details><summary>Custom Component / Icons</summary>
<div class="featured-demo">

```gjs live preview 
import { Rating } from 'ember-primitives';

const Icon = <template>
  <div ...attributes style={{if @isSelected "transform:rotate(180deg)"}}>
    {{@value}}
  </div>
</template>;


<template>
  <Rating @icon={{Icon}} />

  <style>
    @import "/demo-support/utilities.css";

    .ember-primitives__rating__items {
      width: fit-content;
      display: grid;
      gap: 0.5rem;
      grid-auto-flow: column;
      justify-content: center;
      align-items: center;
      height: 4rem;
    }

    .ember-primitives__rating__item {
      font-size: 3rem;
      line-height: 1em;
      transition: all 0.1s;
      transform-origin: center;
      aspect-ratio: 1 / 1;
      user-select: none;
      width: 3rem;
      text-align: center;
      border-radius: 1.5rem;

      label:hover {
        cursor: pointer;
      }

      &:has(input:focus-visible) {
        --tw-ring-opacity: 1;
        --tw-ring-offset-color: #000;
        --tw-ring-offset-width: 2px;
        --tw-ring-color: rgb(224 78 57 / var(--tw-ring-opacity, 1));
        --tw-ring-offset-shadow: var(--tw-ring-inset) 0 0 0 var(--tw-ring-offset-width) var(--tw-ring-offset-color);
        --tw-ring-shadow: var(--tw-ring-inset) 0 0 0 calc(2px + var(--tw-ring-offset-width)) var(--tw-ring-color);
        box-shadow: var(--tw-ring-offset-shadow), var(--tw-ring-shadow), var(--tw-shadow, 0 0 #0000);
        outline: 2px solid transparent;
        outline-offset: 2px;
      }

      input {
        appearance: none;
        position: absolute;

        &:focus-visible, &:focus {
          outline: none;
          box-shadow: none;
        }
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
</details>
<details><summary>Fractional Ratings</summary>
<div class="featured-demo">

```gjs live preview
import { Rating } from 'ember-primitives';

const Star = <template>
    <div class="item">
        <span class="icon">★</span>
        <div class="overlay" style="--percent: {{@percentSelected}}%;"></div>
    </div>
  </template>;

<template>
  <Rating id="demo4" as |rating|>
    {{rating.value}} of {{rating.total}}<br>
    <input type="number" min=0 max={{rating.max}} step="0.25" name={{rating.name}} oninput><br>
    <rating.Stars @icon={{Star}} />
  </Rating>

  <style>
    #demo4 {
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

      .ember-primitives__rating__item .item {
          position: relative;
      }
      .overlay {
          width: var(--percent);
          height: 100%;
          background: red;
          position: absolute;
          top: 0;
          mix-blend-mode: color;
      }
    }

    fieldset { border: none; }
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
<details><summary>No Styles</summary>
<div class="featured-demo">

```gjs live preview
import { Rating } from 'ember-primitives';

const Star = <template>
    <div class="item">
        <span class="icon">★</span>
        <div class="overlay" style="--percent: {{@percentSelected}}%;"></div>
    </div>
  </template>;

<template>
  <Rating as |rating|>
    {{rating.value}} of {{rating.total}}<br>
    <rating.Stars @icon={{Star}} />
  </Rating>

  <style>
    /* just layout, since we don't want to use all the vertical space */
    .ember-primitives__rating__items {
      display: flex;
      gap: 1rem;
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

### Keyboard

Using this component works the same as a radio group. 
- Tab to focus the group as a whole
- Arrow keys to select
- Space toggles

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
