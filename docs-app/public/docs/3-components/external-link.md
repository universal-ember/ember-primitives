# ExternalLink

The `<ExternalLink />` component is a light wrapper around the [Anchor element][mdn-a], which will alawys make your link an external link.


[mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a

Unlike `<Link />`, `<ExternalLink />` uses the native `href` attribute.

This component always has `target=_blank` and `rel='noreferrer noopener'`.

## Example 

```gjs live preview
import { ExternalLink } from 'ember-primitives';

<template>
  <ExternalLink href="https://developer.mozilla.org">
    MDN ➚
  </ExternalLink>
</template>
```
