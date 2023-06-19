# Portal

A `<Portal>` allows teleporting elements to another place in the DOM tree. This can be used for components altering the layout of the page, or getting around z-index issues with modals, popovers, etc.

`<Portal>` must be combined with `<PortalTargets>`, or your own portal targets that match the requirements of portalling.  Additionally, a `<Portal>` will render in to the nearest `<PortalTargets>` it can find, allowing for UI layering, e.g.: Modals have their own `<PortalTargets>` so they can have their own tooltips and popovers.

The following example demonstrates this Portal-nesting:

<div class="featured-demo">

```gjs live preview
import { PortalTargets, Portal, PORTALS } from 'ember-primitives';

<template>
  <div class="style-wrapper">
    <PortalTargets />

    main content

    <Portal @to={{PORTALS.popover}}>
      <div class="first">
        <PortalTargets />
        first layer

        <Portal @to={{PORTALS.popover}}>
          <div class="second">
            <PortalTargets />
            second layer 

            <Portal @to={{PORTALS.tooltip}}>
              <div class="third">
                tooltip / third layer
              </div>
            </Portal>
          </div>
        </Portal>

      </div>
    </Portal>
  </div>

  <style>
    .first, .second, .third {
      position: absolute;
      width: max-content;
      border: 1px solid;
      padding: 1rem;
      margin: 1.25rem;
      background: #fefefe;
      filter: drop-shadow(0 0 0.75rem rgba(0,0,0,0.2));
      border-radius: 4px;
    }
    .style-wrapper { 
      height: 100px;
      position: relative;
    }
  </style>
</template>
```

</div>


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/portal" @name="Signature" />
</template>
```

## Accessibility

When portalling content, we break away from how the browser natively handles focus, and returning focus to certain elements. This is important in Modals and other Popovers that can be made with portalling. During the rendering phase of portaled elements, you'll want to store the `activeElement` so that it can be restored when that portaled content is discarded. 
