# Link

The `<Link />` component is a light wrapper around the [Anchor element][mdn-a], which will appropriately make your link an external link if the passed `@href` is not on the same domain.


[mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a


## Example


```gjs live preview
import { Link } from 'ember-primitives';

<template>
  <Link @href="https://developer.mozilla.org" as |a|>
    MDN

    {{#if a.isExternal}}
      ➚
    {{/if}}
  </Link>

  &nbsp;&nbsp;

  <Link @href="/">Home</Link>
</template>
```
