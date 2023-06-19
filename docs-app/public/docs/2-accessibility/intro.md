# Accessibility

All components strive for compliance with the [WAI-ARIA](https://www.w3.org/TR/wai-aria/) specification, which is a set of guidelines for accessibility, following [the recommended patterns](https://www.w3.org/WAI/ARIA/apg/patterns/).
The ARIA design patterns can be easily searched on [their site index](https://www.w3.org/WAI/ARIA/apg/example-index/).


## Automatic Accountability

Violations that can be caught via CSS are highlighted in the UI so that the developer knows exactly what to fix.

For example, an `<ExternalLink />` missing an href

![image of a link without the href, being highlighted in text that can't be ignored](/images/link-missing-href.png)
<!--
```gjs live no-shadow
import { ExternalLink } from 'ember-primitives';

<template>
  <ExternalLink>
    link to no where
  </ExternalLink>
</template>
```
-->


Another example, a `<Switch />` without a label:

![image of a switch without a label, being highlighted in text that can't be ignored](/images/checkbox-missing-label.png)

<!--
```gjs live no-shadow
import { Switch } from 'ember-primitives';

<template>
  <Switch style="display: inline-block" as |s|>
    <s.Control />
  </Switch>
</template>
```
-->

This only happens during development, and in production, the CSS that applies these warnings is not included.
