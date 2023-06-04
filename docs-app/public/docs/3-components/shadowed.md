# Shadowed

The `<Shadowed />` component renders content using the [shadow DOM][mdn-shadow-dom].


[mdn-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

This is useful when you want to render content that escapes your app's styles. 

## Example

Almost all demos within these docs are rendered within a `<Shadowed />` wrapper.

```gjs live preview 
import { Shadowed } from 'ember-primitives';

<template>
  <style> 
    p {
      border: 1px solid;
      padding: 0.75rem;
      transform: skew(5deg, 5deg); 
      width: 100px;
    }
  </style>

  <p>
    This element is affected by the global styles
  </p>

  <Shadowed>
    <p>
      This element is not affected by global sytles
    </p>
  </Shadowed>
</template>
```

```gjs live 
import { APIDocs } from 'docs-app/docs-support';

<template>
  <APIDocs @module="index" @name="Shadowed" />
</template>
```
