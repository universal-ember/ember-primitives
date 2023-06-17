# Accessibility

WIP

All components strive for compliance with the [WAI-ARIA](https://www.w3.org/TR/wai-aria/) specification, which is a set of guidelines for accessibility, following [the recommended patterns](https://www.w3.org/WAI/ARIA/apg/patterns/).


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

This only happens during development, and in production, the CSS that applies these warnings is not included (the development version of this docs site is deployed, instead of the production build).
