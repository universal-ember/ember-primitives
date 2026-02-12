# Hero

The hero pattern is for featuring large, eye-catching content, such as an image or video, along with a clear, easy to read headline or call to action.

## Features 

* Covers the full browser height and width, including proper dimensionality on dynamically sized viewports, such as on mobile.



## Install

```hbs live
<SetupInstructions @src="components/layout/hero.gts" />
```


## Anatomy

```js 
import { Hero } from 'ember-primitives/layout/hero';
```

```gjs 
import { Hero } from 'ember-primitives/layout/hero';

<template>
  <Hero>
    content
  </Hero>
</template>
```

There is 1 BEM-style class on the element to enable further customization or styling.
```css
/* 
  the containing element. 
  this is not the same element that `...attributes` is on.
*/ 
.ember-primitives__hero__wrapper
```

It has `position: relative` on it.
So elements within can be sticky or absolutely positioned along the outside, if needed (such as for headers and footers).

## Accessibility

This component provides no accessibility patterns and using `<main>` / `<footer>` or not is up to the use case of the `<Hero />` component.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/layout/hero" 
    @name="Hero" 
  />
</template>
```

### State Attributes

This component has no state.
