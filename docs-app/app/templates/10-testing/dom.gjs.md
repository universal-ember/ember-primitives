# Testing: dom

Utilities for interacting with the (shadow) dom in testing

```gjs live no-shadow
import { APIDocs } from 'kolay';

<template>
  <APIDocs 
    @package="ember-primitives"  
    @module="declarations/test-support/dom" 
    @name="findInFirstShadow" />

  <APIDocs 
    @package="ember-primitives"  
    @module="declarations/test-support/dom" 
    @name="findInShadow" />

  <APIDocs 
    @package="ember-primitives"  
    @module="declarations/test-support/dom" 
    @name="findShadow" />

  <APIDocs 
    @package="ember-primitives"  
    @module="declarations/test-support/dom" 
    @name="hasShadowRoot" />
</template>
```
