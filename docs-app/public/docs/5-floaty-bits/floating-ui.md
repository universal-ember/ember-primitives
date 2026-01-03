# Floating UI

The `FloatingUI` component provides a wrapper for using [Floating UI](https://floating-ui.com/), for associating a floating element to an anchor element (such as for menus, popovers, etc). 

This component uses the native [popover](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/popover) attribute to automatically make the intended floating element behave correctly.

<Callout>

The usage of a 3rd-party library will be removed when [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning) lands and is widely supported (This component and modifier will still exist for the purpose of wiring up the ids between anchor and target). 

</Callout>

Several of Floating UI's functions and [middleware](https://floating-ui.com/docs/middleware) are used to create an experience out of the box that is useful and expected.
See Floating UI's [documentation](https://floating-ui.com/docs/getting-started) for more information on any of the following included functionality.


## Install


```hbs live
<SetupInstructions @src="floating-ui.ts" />
```

## `<FloatingUI>`

This component takes the [`archorTo` modifier](/5-floaty-bits/anchor-to.md) and abstracts away the need to manage the `id`-relationship between reference and floating elements -- since every ID on the page needs to be unique, it is useful to have this automatically managed for you.

This component has no DOM of its own, but provides two modifiers to attach to both reference and floating elements.

<div class="featured-demo">

```gjs live preview no-shadow
import { FloatingUI } from 'ember-primitives/floating-ui';

<template>
  <FloatingUI as |reference floating|>
    <button {{reference}}>Click the reference element</button>
    <menu {{floating}}>Here is <br> floating element</menu>
  </FloatingUI>

  <style>
    @scope {
      menu {
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
      button {
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
    }
  </style>
</template>
```

</div>

Note that this demo has to main a unique id/target for the popover behavior. If you'd like to not have to manage ids at all, you may be interested in the [Popover](/5-floaty-bits/popover.md) component (which also includes arrow support).

### API Reference for `<FloatingUI>`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/floating-ui/component" 
    @name="Signature" />
</template>
```

## References

- [Positioning Anchored Popovers](https://hidde.blog/positioning-anchored-popovers/)
- [Floating UI Documentation](https://floating-ui.com/)

## Comparison to similar projects

Similar projects include:

* [ember-popperjs](https://github.com/NullVoxPopuli/ember-popperjs)
* [ember-popper-modifier](https://github.com/adopted-ember-addons/ember-popper-modifier)

The above projects both use [Popper](https://popper.js.org/). In contrast, Ember Velcro uses Floating UI. Floating UI is the successor to Popper - see their [migration guide](https://floating-ui.com/docs/migration) for a complete comparison.

There is also:

* [ember-velcro](https://github.com/CrowdStrike/ember-velcro)

which this project is a fork up, and ditches the velcro (hook / loop) verbiage and fixes bugs and improves ergonomics.

