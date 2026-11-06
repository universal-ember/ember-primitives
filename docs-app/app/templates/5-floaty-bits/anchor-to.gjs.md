# anchorTo 

The `anchorTo` modifier uses [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning) to associate a floating element to an anchor element (such as for menus, popovers, etc).

The floating element flips, moves along its anchor to stay in the viewport, and hides when its anchor is not visible. See the [Popover](/5-floaty-bits/popover.md) page for the limits.

## Install


```hbs live
<SetupInstructions @src="floating-ui.ts" @since="0.15.0" />
```

## `{{anchorTo}}`

The main modifier for creating floating UIs with any elements.

Requires you to maintain a unique ID for every invocation. 


<div class="featured-demo">

```gjs live preview no-shadow
import { anchorTo } from 'ember-primitives/floating-ui';
import { InViewport } from 'ember-primitives/viewport';

<template>
  <InViewport>
    <button id="reference" popovertarget="floating">Click the reference element</button>
    <menu popover id="floating" {{anchorTo "#reference"}}>Here is <br> floating element</menu>
  </InViewport>

  <style>
    menu#floating {
      width: max-content;
      position: absolute;
      top: 0;
      left: 0;
      background: #222;
      color: white;
      font-weight: bold;
      padding: 2rem;
      border-radius: 4px;
      font-size: 90%;
      filter: drop-shadow(0 0 0.75rem rgba(0,0,0,0.4));
      z-index: 10;
    }
    button#reference {
      padding: 0.5rem;
      border: 1px solid;
      display: inline-block;
      background: white;
      color: black;
      border-radius: 0.25rem;

      &:hover {
        background: #ddd;
      }
    }
  </style>
</template>
```

</div>

Note that in this demo thare are _two_ sets of ids. One pair for the floating behavior, and another pair for the [popover](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/popover) wiring.  The component below handles the floating id, but to avoid needing to maintain _unique_ pairs of ids for each floating-ui you may be interested in the [Popover](/5-floaty-bits/popover.md) component (which also includes arrow support).

### API Reference for `{{anchorTo}}`

```gjs live no-shadow
import { ModifierSignature } from 'kolay';

<template>
  <ModifierSignature 
    @package="ember-primitives" 
    @module="declarations/floating-ui/modifier" 
    @name="Signature"
  />
</template>
```


