# Shadowed

```gjs live no-shadow
import { CommentQuery } from 'kolay';

<template>
  <CommentQuery @package="ember-primitives" @module="declarations/components/shadowed" @name="Shadowed" />
</template>
```

## Example

```gjs live preview 
import { Shadowed } from 'ember-primitives';

<template>
  <style> 
    p.shadow-demo {
      border: 1px solid;
      padding: 0.75rem;
      transform: skew(5deg, 5deg); 
      width: 100px;
    }
  </style>

  <p class="shadow-demo">
    This element is affected by the global styles
  </p>

  <Shadowed>
    <p class="shadow-demo">
      This element is not affected by global sytles
    </p>
  </Shadowed>
</template>
```


## Install

```hbs live
<SetupInstructions @src="components/shadowed.gts" />
```


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/shadowed" 
    @name="Shadowed" 
  />
</template>
```
