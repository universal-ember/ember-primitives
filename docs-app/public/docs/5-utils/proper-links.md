# Proper Links

Enables usage of plain `<a>` tags.
You no longer need to use a component to have single-app-app navigation 🎉.

## Setup

import `properLinks` and apply it to your Router.

```js
import EmberRouter from "@ember/routing/router";

import config from "docs-app/config/environment";
import { properLinks } from "ember-primitives/proper-links";

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  // ...
});
```

## Example

```gjs live preview 

<template>
  <nav style="display: flex; gap: 0.5rem">
    <a href="/">Home</a> 
    <a href="/3-components/link">Link docs</a> 
    <a href="/3-components/external-link">ExternalLink docs</a> 
    <a href="https://developer.mozilla.org">MDN ➚</a> 
  </nav>
</template>
```
