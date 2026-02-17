# Portal

A `<Portal>` allows teleporting elements to another place in the DOM tree. This can be used for components altering the layout of the page, or getting around z-index issues with modals, popovers, etc.

`<Portal>` must be combined with `<PortalTargets>`, or your own portal targets that match the requirements of portalling.  Additionally, a `<Portal>` will render in to the nearest `<PortalTargets>` it can find, allowing for UI layering, e.g.: Modals have their own `<PortalTargets>` so they can have their own tooltips and popovers.  _For use with popovers_, this portalling can be a way to support [popover](https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/popover) on older browsers. But there are many other use cases outside of popovers as well.

**The `@to` argument accepts any valid CSS selector** (like `[data-portal-target]`, `.my-class`, `#my-id`), a PortalTarget name (like `popover`, `tooltip`, or `modal`), or an Element object.

<h2 visually-hidden>Usage</h2>

The following example demonstrates Portal-nesting:

<div class="featured-demo">

```gjs live preview
import { Portal } from 'ember-primitives/components/portal';

<template>
  <div class="style-wrapper">
    <div data-portal-target></div>

    <button>main content</button>

    <Portal @to="[data-portal-target]">
      <div class="popover">
        <div data-portal-target></div>
        first layer

        <Portal @to="[data-portal-target]">
          <div class="popover">
            <div data-portal-target></div>
            second layer 

            <Portal @to="[data-portal-target]">
              <div class="popover">
                tooltip / third layer
              </div>
            </Portal>
          </div>
        </Portal>

      </div>
    </Portal>
  </div>

  <style>
    .popover {
      position: absolute;
      width: max-content;
      border: 1px solid;
      padding: 1rem;
      color: black;
      margin: 1.25rem;
      background: #fefefe;
      filter: invert(1)  drop-shadow(0 0 0.75rem rgba(0,0,0,0.2));
      border-radius: 4px;
    }
    .button {
      padding: 0.5rem 1rem;
    }
    .style-wrapper { 
      height: 100px;
      position: relative;
    }
  </style>
</template>
```

</div>

<Callout>

When using a popover pattern, you'll want to use the native [`popover`](https://developer.mozilla.org/en-US/docs/Web/API/Popover_API/Using#nested_popovers) capabilities of browsers. When coupled with [Floating UI](/5-floaty-bits/floating-ui.md), you also can correctly position a popover to a target element.

</Callout>

### Component-controlled Layout

Using Portals enables you to be able to have sub-components (or even sub-routes render into elements that live outside of their hierarchy. 

<div class="featured-demo">

```gjs live preview
import { Portal } from 'ember-primitives/components/portal';


<template>
  <div class="layout">
    <div class="header-container"></div>
    <div class="main-container"></div>
    <div class="sidebar-container"></div>
    <div class="footer-container"></div>
  </div>

  <ExampleA />
  <ExampleB />
  {{!-- or yield or outlet --}}

  <style>
    .header-container { grid-area: header; }
    .main-container { grid-area: main; }
    .sidebar-container { grid-area: sidebar; }
    .footer-container { grid-area: footer; }
    .layout {
      display: grid;
      grid-template-columns: 1fr 1fr 50px 1fr;
      grid-template-rows: auto;
      grid-template-areas: 
        "header header header header"
        "main main . sidebar"
        "footer footer footer footer";
      gap: 0.5rem;
    }


    .header-container, .main-container, .sidebar-container, .footer-container {
      border: 1px solid;
    }
  </style>
</template>

// Var used for hoisting, so that the 
// layout component can be seen first
var ExampleA = <template>
  <Portal @to=".main-container" @append={{true}}>
    ExampleA main
  </Portal>
  <Portal @to=".header-container" @append={{true}}>
    ExampleA header
  </Portal>
  <Portal @to=".sidebar-container" @append={{true}}>
    ExampleA sidebar
  </Portal>
</template>;


var ExampleB = <template>
  <Portal @to=".main-container" @append={{true}}>
    ExampleB main
  </Portal>
  <Portal @to=".sidebar-container" @append={{true}}>
    ExampleB sidebar
  </Portal>
  <Portal @to=".footer-container" @append={{true}}>
    ExampleB footer
  </Portal>
</template>;
```

</div>

### Why not just `in-element`?

The [`in-element`](https://api.emberjs.com/ember/6.5/classes/Ember.Templates.helpers/methods/in-element?anchor=in-element) utility is built in to Ember, but it requires the user handle how to find the element that is passed to in-element's first positional argument.

```hbs
{{#in-element (getElementSomehow)}}
    content portaled to the element
{{/in-element}}
```

This Portal and other implementatiosn solve this in various ways.
- [ember-wormhole](https://github.com/yapplabs/ember-wormhole/blob/master/addon/components/ember-wormhole.js) - created before `in-element` existed, so it contains _a lot_ of code (but can be used as a sortof polyfill for _very_ old ember versions).
- [ember-stargate](https://github.com/simonihmig/ember-stargate)  - builds on top of in-element and uses one of the techniques that this Portal component uses 

### `@to` can be an element

The element can be created dynamically (for rendering off screen), or any other element obtained by other means.

<div class="featured-demo">

```gjs live preview
import { Portal } from 'ember-primitives/components/portal';

let element = document.createElement('div');

<template>
  <fieldset class="border">
    <legend>origin</legend>
    <Portal @to={{element}}>
      content
    </Portal>
  </fieldset>

  element is wherever we want:
  {{element}}
</template>
```

</div>

### ember-wormhole

If you're migrating from [ember-wormhole](https://github.com/yapplabs/ember-wormhole/), a migration path using this Portal component would look like this:

<div class="featured-demo">

```gjs live preview no-shadow
import { Portal } from 'ember-primitives/components/portal';
import { InViewport } from 'ember-primitives/viewport';

<template>
  <InViewport>
    <fieldset class="border">
      <legend>origin</legend>
      Two portals:
      <Portal @wormhole="wormhole-target">
        content
      </Portal>

      <Portal @wormhole="#wormhole-target">
        extra content
      </Portal>
    </fieldset>

    element is wherever we want:
    <div id="wormhole-target"></div>
  </InViewport>
</template>
```

</div>

The wormhole compatibility mode assumes that an element will be rendered in to the DOM before the next cycle of the runloop. This approach is non-reactive, and doesn't handle portal nesting -- which is why it can't use the same `@to` argument as the other usages (the code that polyfills ember-wormhole is _very small_).

Additionally, ember-wormhole allows passing a plain `id` as in `#selector` without the leading `#`. But because we don't want to only support ids, any valid CSS selector is also allowed.

And an improvement upon ember-wormhole is that if the element can already be found in the DOM, the portaled contents will render right away, and not wait until the next render cycle.
Of note, the default behavior here is to append to the portal target instead of replace. The other usages do not default to this behavior.

A major limitation of the wormhole approach is that it does not work well within shadowdom nor does it work with off-canvas rendering (fragments not yet part of the DOM tree (which is a strategy that [repl-sdk](https://limber.glimdown.com/docs/repl-sdk) employs)).


### ember-stargate

ember-stargate uses reactive registration for the portal targets. 

Note that when doing this, you also get the nested portals functionality demo'd at the top of this page.

Here is what using ember-primitive's Portal in an ember-stargate style would look like:

<div class="featured-demo">

```gjs live preview no-shadow
import { Portal } from 'ember-primitives/components/portal';
import { PortalTarget } from 'ember-primitives/components/portal-targets';

<template>
  <fieldset class="border">
    <legend>origin</legend>

    <Portal @to="name-here">
      content
    </Portal>
  </fieldset>

  <PortalTarget @name="name-here" />
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/portal.gts" />
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/portal" 
    @name="Signature" 
  />
</template>
```

## Accessibility

When portalling content, we break away from how the browser natively handles focus, and returning focus to certain elements. This is important in Modals and other Popovers that can be made with portalling. During the rendering phase of portaled elements, you'll want to store the `activeElement` so that it can be restored when that portaled content is discarded. 
