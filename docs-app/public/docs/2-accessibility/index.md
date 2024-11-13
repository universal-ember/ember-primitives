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

## Keyboard Support

ember-primitives uses _The Platform_ where possible and implements W3C recommendations for patterns where _The Platform_ does not provide solutions. To help lift the burden of maintenance for keyboard support implementation, ember-primitives uses [tabster](https://tabster.io/) for adding that additional keyboard support. Using tabster is optional, and is not included in your build if you don't use the below setup instructions (for example, if you had a different keyboard manager in your project and wanted to use that)

This keyboard support is enabled by default but does require initialization. You can initialize keyboard support in your application router by calling the `setupTabster()` function:
```ts
import Route from '@ember/routing/route';
import { service } from '@ember/service';
import{ setupTabster } from 'ember-primitives/tabster';

export default class Application extends Route {
  async beforeModel() {
    // the 'this' is passed so that tabster is cleaned up
    // when the route (or in this case: application)
    // is destroyed  or unmounted
    await setupTabster(this);
  }
}
```

This is customizable, in case your application already uses tabster -- you may pass options to the `setup()` method:
```ts
// To use your own tabster
await setupTabster(this, { tabster: myTabsterCoreInstance });
// To specify your own "tabster root" 
await setupTabster(this, { setTabsterRoot: false });
```

The tabster root is an element which which tells tabster to pay attention for tabster-using features.
It can be set this way:
```html
<div data-tabster='{ "root": {} }'></div>
```

By default, this attribute-value pair is set on the `body` element.
