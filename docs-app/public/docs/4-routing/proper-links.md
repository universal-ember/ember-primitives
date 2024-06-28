# Proper Links

Enables usage of plain `<a>` tags.
You no longer need to use a component to have single-page-app navigation 🎉.

## Setup

import `properLinks` and apply it to your Router.

```diff
  // app/router.js
  import EmberRouter from "@ember/routing/router";

  import config from "docs-app/config/environment";
+ import { properLinks } from "ember-primitives/proper-links";

+ @properLinks
  export default class Router extends EmberRouter {
    location = config.locationType;
    rootURL = config.rootURL;
  }
```

## Example

Once `@properLinks` is installed and setup, you can use plain `<a>` tags for navigation like this

```gjs live preview
<template>
  <nav id="example" style="display: flex; gap: 0.5rem">
    <a href="/">Home</a>
    <a href="#example">Link using a hash</a>
    <a href="/4-routing/link">Link docs</a>
    <a href="/4-routing/external-link">ExternalLink docs</a>
    <a href="https://developer.mozilla.org">MDN ➚</a>
  </nav>
</template>
```
