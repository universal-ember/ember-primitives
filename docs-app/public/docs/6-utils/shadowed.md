# Shadowed

```gjs live no-shadow
import { CommentQuery } from 'kolay';

<template>
  <CommentQuery @module="components/shadowed" @name="Shadowed" />
</template>
```

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


## Setup

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
