# Query Params 

Utilities for accessing query-params without the need for creating a class-component, or injecting the [router service][router-service].

[router-service]: https://api.emberjs.com/ember/release/classes/routerservice/

## Setup

```bash 
pnpm add ember-primitives
```

## API Reference

There are a few exports from `ember-primitives/qp`

### `{{qp 'qp-name'}}`

Grabs a query-param off the current route from the router service.

```gjs
import { qp } from 'ember-primitives/qp';

<template>
 {{qp "query-param"}}
</template>
```

```gjs live no-shadow
import { HelperSignature } from 'kolay';

<template>
  <HelperSignature 
    @package="ember-primitives" 
    @module="declarations/qp" 
    @name="qp" />
</template>
```

### `{{withQP 'qp-name' value}}`

Returns a string for use as an `href` on `<a>` tags, updated with the passed query param

```gjs
import { withQP } from 'ember-primitives/qp';

<template>
  <a href={{withQP "foo" "2"}}>
    ...
  </a>
</template>
```

```gjs live no-shadow
import { HelperSignature } from 'kolay';

<template>
  <HelperSignature 
    @package="ember-primitives" 
    @module="declarations/qp" 
    @name="withQP" />
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

