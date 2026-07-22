# Toggle

A two-state button that can be either on or off.

This type of button could be used to enable or disable a feature, activate or deactivate a mode, or show or hide a particular element on a webpage.

`<Toggle />` can be used in any design system.

## Examples


<details open><summary><h3>Bold text toggle</h3></summary>

A pressable button that stays pressed — useful for formatting toolbars.

```gjs live preview
import { Toggle } from 'ember-primitives';

<template>
  <Toggle aria-label="Bold" class="bold-toggle">
    B
  </Toggle>

  <style>
    .bold-toggle {
      min-width: 2.25rem;
      min-height: 2.25rem;
      padding: 0.35rem 0.7rem;
      border: 1px solid var(--doc-border);
      border-radius: 0.5rem;
      background: var(--doc-bg);
      color: var(--doc-text-2);
      font-size: 1rem;
      font-weight: 600;
      font-family: var(--font-sans);
      cursor: pointer;
    }

    .bold-toggle[aria-pressed="true"] {
      color: var(--doc-brand-1);
      background: var(--doc-brand-soft);
      border-color: color-mix(in srgb, var(--doc-brand-1) 35%, var(--doc-border));
    }
  </style>
</template>
```

</details>

## Install

```hbs live
<SetupInstructions @src="components/toggle.gts" @since="0.0.3" />
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
