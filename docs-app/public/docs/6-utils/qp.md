# qp 

Utilities for accessing query-params without the need for creating a class-component, or injecting the [router service][router-service].

[router-service]: https://api.emberjs.com/ember/release/classes/routerservice/

## Setup

```bash 
pnpm add ember-primitives
```

## Usage

```gjs
import { qp, castToBoolean } 'ember-primitives/qp'; 

<template>
  {{qp "the-query-param-name"}} <- is a string

  {{#if (castToBoolean (qp 'some-qp'))}}
    ...
  {{/if}}
</template>
```



## API Reference

There are two exports from `ember-primitives/qp`

### `{{qp 'qp-name'}}`

Grabs a query-param off the current route from the router service.

```gjs live no-shadow
import { HelperSignature } from 'kolay';

<template>
  <HelperSignature 
    @package="ember-primitives" 
    @module="declarations/qp" 
    @name="Signature" />
</template>
```

### `castToBoolean`

Cast a query-param string value to a boolean.

The following values are considered "false"
- `undefined`
- `""`
- `"0"`
- `"false"`
- `"f"`
- `"off"`
- `"no"`
- `"null"`
- `"undefined"`

All other values are considered truthy

```gjs live no-shadow
import { HelperSignature } from 'kolay';

<template>
  <HelperSignature 
    @package="ember-primitives" 
    @module="declarations/qp" 
    @name="castToBoolean" />
</template>
```

