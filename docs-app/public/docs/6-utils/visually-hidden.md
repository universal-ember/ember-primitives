# VisuallyHidden

Hides content from the screen in an accessible way.

Can be used as an attribute, `visually-hidden` on any element, or a Component. 

## Example

```gjs live live-preview no-shadow
import { VisuallyHidden } from 'ember-primitives';

<template>
  Visually <span visually-hidden>secrets!</span>
  seen

  <VisuallyHidden>
    This is visually hidden 
  </VisuallyHidden>
  Visually seen
</template>
```

## Features

- Visually hides content while preserving it for assistive technology.
- Just an attribute on any element, component optional.

## Anatomy

Using the attribute

```hbs
<span visually-hidden>...</span>
```

Using the component:

```js 
import { VisuallyHidden } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { VisuallyHidden } from 'ember-primitives/components/dialog';
```


```gjs 
import { VisuallyHidden } from 'ember-primitives';

<template>
  <VisuallyHidden>
    text here to hide visually
  </VisuallyHidden>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/visually-hidden" 
    @name="VisuallyHidden" 
  />
</template>
```

## Accessibility

This is useful in certain scenarios as an alternative to traditional labelling with `aria-label` or `aria-labelledby`.
