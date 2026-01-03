# Toggle

A two-state button that can be either on or off.

This type of button could be used to enable or disable a feature, activate or deactivate a mode, or show or hide a particular element on a webpage.

`<Toggle />` can be used in any design system.

## Examples


<details open><summary><h3>Bold Text Toggle</h3></summary>


See [Bootstrap Toggle Button](https://getbootstrap.com/docs/5.3/forms/checks-radios/#toggle-buttons) docs.

```gjs live preview
import { Toggle } from 'ember-primitives';

<template>
  <Toggle aria-label="Toggle Bold Text" class="bold-toggle">
    B
  </Toggle>

  <style>
    .bold-toggle {
      border: 1px solid;
      padding: 5px 10px;
      font-size: 1.25rem;
      line-height: 1rem;
    }
    .bold-toggle[aria-pressed="true"] {
      font-weight: bold;
      backdrop-filter: blur(25px);
      background: gray;
    }
  </style>
  
</template>
```

</details>

## Install

```hbs live
<SetupInstructions @src="components/toggle.gts" />
```

## Features 

* Full keyboard navigation 
* Can be controlled or uncontrolled


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
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/toggle" 
    @name="Signature" 
  />
</template>
```

### State Attributes

| key | description |  
| :---: | :----------- |  
| aria-pressed | "true" or "false", depending on the state of the toggle button |  


## Accessibility

Uses [`aria-pressed`](https://www.w3.org/TR/wai-aria-1.2/#aria-pressed) but with only two possible states.

### Keyboard Interactions

| key | description |  
| :---: | :----------- |  
| <kbd>Space</kbd> | Toggles the component's state |  
| <kbd>Enter</kbd> | Toggles the component's state |  

In addition, a label is required so that users know what the toggle is for.
