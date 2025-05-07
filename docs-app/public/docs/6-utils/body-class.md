# Body class

A utility template-helper for updating the `class` on the `document.body`, based on the rendered content. When `{{bodyClass ".."}}` is unrendered, the specified body classes will also be removed.

## Example

```gjs
import { bodyClass } from 'ember-primitives/helpers/body-class';

// When rendered: "prevent-scrolling" is added to the body class
// When unrendered: "prevent-scrolling" is removed from the body class
<template>
  {{bodyClass "prevent-scrolling"}}
</template>
```

## API Reference


```gjs live no-shadow
import { HelperSignature } from 'kolay';

<template>
  <HelperSignature 
    @package="ember-primitives" 
    @module="declarations/helpers/body-class" 
    @name="Signature" />
</template>
```
