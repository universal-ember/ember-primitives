# Singletons

`createSingleton` will a singleton cached on any context (component, application, etc). Can be used to create private services that don't live in the registry, or any lazily created state private to certain components. Can also be combined wih DOM hierachy crawling to create DOM-based context/contextual state. 

It also handles appropriate linkage and destroyable linkage (via [`link`](https://reactive.nullvoxpopuli.com/functions/link.link.html))

```js

```

## API Reference


```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/singleton" 
    @name="createSingleton" 
  />
</template>
```
