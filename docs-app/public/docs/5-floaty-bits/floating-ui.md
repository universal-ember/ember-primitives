# Floating UI

The `FloatingUI` component (and modifier) provides a wrapper for using [Floating UI](https://floating-ui.com/), for associating a floating element to an anchor element (such as for menus, popovers, etc. 

<Callout>

The usage of a 3rd-party library will be removed when [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning) lands and is widely supported (This component and modifier will still exist for the purpose of wiring up the ids between anchor and target). 

</Callout>

Several of Floating UI's functions and [middleware](https://floating-ui.com/docs/middleware) are used to create an experience out of the box that is useful and expected.
See Floating UI's [documentation](https://floating-ui.com/docs/getting-started) for more information on any of the following included functionality.


## `{{floatingUI}}`

The main modifier for creating floating UIs with any elements.

Requires you to maintain a unique ID for every invocation. 


<div class="featured-demo">

```gjs live preview no-shadow
import { floatingUI } from 'ember-primitives/floating-ui';

<template>
  <button id="reference" popovertarget="floating">Click the reference element</button>
  <menu popover id="floating" {{floatingUI "#reference"}}>Here is <br> floating element</menu>

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


```gjs no-shadow
import { ModifierSignature } from 'kolay';

<template>
  <ModifierSignature 
    @package="ember-primitives" 
    @module="declarations/floating-ui/modifier" 
    @name="Signature"
  />
</template>
```

## `<FloatingUI>`

This component takes the above modifier and abstracts away the need to manage the `id`-relationship between reference and floating elements -- since every ID on the page needs to be unique, it is useful to have this automatically managed for you.

This component has no DOM of its own, but provides two modifiers to attach to both reference and floating elements.

<div class="featured-demo">

```gjs live preview no-shadow
import { FloatingUI } from 'ember-primitives/floating-ui';

<template>
  <FloatingUI as |reference floating|>
    <button {{reference}} popovertarget="floating2">Click the reference element</button>
    <menu {{floating}} popover id="floating2">Here is <br> floating element</menu>
  </FloatingUI>

  <style>
    menu#floating2 {
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
    button[popovertarget="floating2"] {
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

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/floating-ui/component" 
    @name="Signature" />
</template>
```

## Comparison to similar projects

Similar projects include:

* [ember-popperjs](https://github.com/NullVoxPopuli/ember-popperjs)
* [ember-popper-modifier](https://github.com/adopted-ember-addons/ember-popper-modifier)

The above projects both use [Popper](https://popper.js.org/). In contrast, Ember Velcro uses Floating UI. Floating UI is the successor to Popper - see their [migration guide](https://floating-ui.com/docs/migration) for a complete comparison.

There is also:

* [ember-velcro](https://github.com/CrowdStrike/ember-velcro)

which this project is a fork up, and ditches the velcro (hook / loop) verbiage and fixes bugs and improves ergonomics.

