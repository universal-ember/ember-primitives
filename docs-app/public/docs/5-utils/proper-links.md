# Proper Links

Enables usage of plain `<a>` tags.

## Setup 

import `properLinks` and apply it to your Router.

```js 
import EmberRouter from '@ember/routing/router';

import config from 'docs-app/config/environment';
import { properLinks } from 'ember-primitives/proper-links';

@properLinks
export default class Router extends EmberRouter {
  location = config.locationType;
  rootURL = config.rootURL;
}

Router.map(function () {
  // ...
});

```
