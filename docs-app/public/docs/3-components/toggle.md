# Toggle



`<Toggle />` can be used in any design system.

## Examples


<details><summary><h3>Bootstrap</h3></summary>

</details>

## Features 

* Full keyboard navigation 
* Can be controlled or uncontrolled


## Installation 

```bash 
pnpm add ember-primitives
```

## Anatomy

```js 
import { Toggle } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Toggle } from 'ember-primitives/components/toggle';
```


```gjs 
import { Toggle } from 'ember-primitives';

<template>
  <Toggle aria-label="Toggle Bold Text">
    B
  </Toggle>
</template>
```


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/switch" @name="Signature" />
</template>
```

### Data Attributes

## Accessibility


### Keyboard Interactions

Uses [`aria-pressed`](https://www.w3.org/TR/wai-aria-1.2/#aria-pressed)


| key | description |  
| :---: | :----------- |  
| <kbd>Space</kbd> | Toggles the component's state |  
| <kbd>Enter</kbd> | Toggles the component's state |  

In addition, a label is required so that users know what the toggle is for.
