# ToggleGroup

A group of two-state buttons that can be toggled on or off.


<div class="featured-demo">

```gjs live preview no-shadow
import { ToggleGroup } from 'ember-primitives';

<template>
  <div class="demo">
    <ToggleGroup class="toggle-group" as |t|>
      <t.Item @value="left" aria-label="Left align">
        <AlignLeft />
      </t.Item> 
      <t.Item @value="center" aria-label="Center align">
        <AlignCenter />
      </t.Item> 
      <t.Item @value="right" aria-label="Right align">
        <AlignRight />
      </t.Item> 
    </ToggleGroup>

    <ToggleGroup @type="multi" class="toggle-group" as |t|>
      <t.Item @value="bold" aria-label="Bold text">
        B
      </t.Item> 
      <t.Item @value="italic" aria-label="Italicize text">
        I
      </t.Item> 
      <t.Item @value="underline" aria-label="Underline text">
        U
      </t.Item> 
    </ToggleGroup>
  </div>

  <style>
    button[aria-label="Bold text"] { font-weight: bold; }
    button[aria-label="Italicize text"] { font-style: italic; }
    button[aria-label="Underline text"] { text-decoration: underline; } 

    .demo { 
      display: flex; 
      justify-content: center; 
      align-items: center; 
      gap: 1rem; 
    }

    .toggle-group {
      display: inline-flex;
      background-color: #fff;
      border-radius: 0.25rem;
      filter: drop-shadow(0 2px 2px rgba(0,0,0,0.5));
    }

    .toggle-group > button {
      background-color: white;
      color: #000;
      height: 35px;
      width: 35px;
      display: flex;
      font-size: 15px;
      padding: 0.5rem;
      line-height: 1;
      align-items: center;
      justify-content: center;
      margin-left: 1px;
      border: 0;
    }
    .toggle-group > button:first-child {
      margin-left: 0;
      border-top-left-radius: 4px;
      border-bottom-left-radius: 4px;
    }
    .toggle-group > button:last-child {
      border-top-right-radius: 4px;
      border-bottom-right-radius: 4px;
    }
    .toggle-group > button:hover {
      background-color: #eee;
    }
    .toggle-group > button[aria-pressed='true'] {
      background-color: #ddf;
      color: black;
    }
    .toggle-group > button:focus {
      position: relative;
      box-shadow: 0 0 0 2px black;
    }
  </style>
</template>

const AlignLeft = <template>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M288 64c0 17.7-14.3 32-32 32H32C14.3 96 0 81.7 0 64S14.3 32 32 32H256c17.7 0 32 14.3 32 32zm0 256c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H256c17.7 0 32 14.3 32 32zM0 192c0-17.7 14.3-32 32-32H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32c-17.7 0-32-14.3-32-32zM448 448c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32z"/></svg>
</template>;
const AlignCenter = <template>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M352 64c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32s14.3 32 32 32H320c17.7 0 32-14.3 32-32zm96 128c0-17.7-14.3-32-32-32H32c-17.7 0-32 14.3-32 32s14.3 32 32 32H416c17.7 0 32-14.3 32-32zM0 448c0 17.7 14.3 32 32 32H416c17.7 0 32-14.3 32-32s-14.3-32-32-32H32c-17.7 0-32 14.3-32 32zM352 320c0-17.7-14.3-32-32-32H128c-17.7 0-32 14.3-32 32s14.3 32 32 32H320c17.7 0 32-14.3 32-32z"/></svg>
</template>;
const AlignRight = <template>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><!--!Font Awesome Free 6.5.1 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M448 64c0 17.7-14.3 32-32 32H192c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32zm0 256c0 17.7-14.3 32-32 32H192c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32zM0 192c0-17.7 14.3-32 32-32H416c17.7 0 32 14.3 32 32s-14.3 32-32 32H32c-17.7 0-32-14.3-32-32zM448 448c0 17.7-14.3 32-32 32H32c-17.7 0-32-14.3-32-32s14.3-32 32-32H416c17.7 0 32 14.3 32 32z"/></svg>
</template>;
```

</div>

## Features

* Full keyboard navigation
* Supports horizontal / vertical orientation
* Support single and multiple pressed buttons
* Can be controlled or uncontrolled

## Anatomy

```js 
import { ToggleGroup } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { ToggleGroup } from 'ember-primitives/components/toggle';
```


```gjs 
import { ToggleGroup } from 'ember-primitives';

<template>
  <ToggleGroup as |t|>
    <t.Item /> 
  </ToggleGroup>
</template>
```

## API Reference: `@type='single'` (default)

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature @module="components/toggle-group" @name="SingleSignature" />
</template>
```

## API Reference: `@type='multi'` 

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature @module="components/toggle-group" @name="MultiSignature" />
</template>
```


<hr>

## API Reference: `Item`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature @module="components/toggle-group" @name="ItemSignature" />
</template>
```

## Accessibility

Uses [roving tabindex](https://www.w3.org/TR/wai-aria-practices-1.2/examples/radio/radio.html) to manage focus movement among items using the [tabster](https://tabster.io/) library.

As a caveat to using [tabster](https://tabster.io/), a "tabster-root" will need to be established separately if this component is used within a shadow-root, which escapes the parent-DOM's tabster instance.

For more information, see [The Accessibility guide](/2-accessibility/intro.md).

### Keyboard Interactions

| key | description |  
| :---: | :----------- |  
| <kbd>Tab</kbd> | Moves focus to the first item in the group |  
| <kbd>Space</kbd> | Toggles the item's state |  
| <kbd>Enter</kbd> | Toggles the item's state |  
| <kbd>ArrowDown</kbd> | Moves focus to the next item in the group |  
| <kbd>ArrowRight</kbd> | Moves focus to the next item in the group |  
| <kbd>ArrowDown</kbd> | Moves focus to the previous item in the group |  
| <kbd>ArrowLeft</kbd> | Moves focus to the previous item in the group |  
| <kbd>Home</kbd> | Moves focus to the first item in the group |  
| <kbd>End</kbd> | Moves focus to the last item in the group |  
