# Accessibility

WIP

## Automatic Accountability

Violations that can be caught via CSS are highlighted in the UI so that the developer knows exactly what to fix.

For example, an `<ExternalLink />` missing an href

```gjs live no-shadow
import { ExternalLink } from 'ember-primitives';

<template>
  <ExternalLink>
    link to no where
  </ExternalLink>
</template>
```

<br>

Another example, a `<Switch />` without a label:

```gjs live no-shadow
import { Switch } from 'ember-primitives';

<template>
  <Switch style="display: inline-block" as |s|>
    <s.Control />
  </Switch>
</template>
```
