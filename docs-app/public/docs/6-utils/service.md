# Service

This helper enables typed access to services without a backing class or even a component.

## Example

```gjs live preview
import { service } from "ember-primitives/helpers/service";

<template>
  {{#let (service "router") as |router|}}

    {{router.currentURL}}
    :
    <br />
    <pre>{{JSON.stringify router.currentRoute.attributes null 2}}</pre>

  {{/let}}
</template>
```

## Install

```hbs live
<SetupInstructions @src="helpers/service.ts" />
```
