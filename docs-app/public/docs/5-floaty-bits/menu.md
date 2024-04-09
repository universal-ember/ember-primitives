# Menu

Menus are built with Popovers, with added features for keyboard navigation and accessibility. 

The `<Menu>` component uses portals in a way that totally solves layering issues. No more worrying about tooltips on varying layers of your UI sometimes appearing behind other floaty bits. See the `<Portal>` and `<PortalTargets>` pages for more information.

<div class="featured-demo">

```gjs live preview
import { PortalTargets, Menu } from 'ember-primitives';
import { array, hash } from '@ember/helper';
import { loremIpsum } from 'lorem-ipsum';

<template>
  <PortalTargets />

  <Menu @offsetOptions={{8}} as |m|>
    <button type="button" class="hook" {{m.trigger}}>
      <EllipsisVertical />
    </button>
    <m.Content class="floatybit">
      The floaty bit here3
      <div class="arrow" {{m.arrow}}></div>
    </m.Content>
  </Menu>

  <style>
    .floatybit {
      width: max-content;
      position: absolute;
      top: 0;
      left: 0;
      background: #fff;
      color: #111827;
      padding: 5px;
      border-radius: 4px;
      filter: drop-shadow(0 0 0.75rem rgba(0,0,0,0.4));
      z-index: 10;
      border-color: rgb(17 24 39 / 5%)
      border-width: 1px;
    }
    .arrow {
      position: absolute;
      background: #222;
      width: 8px;
      height: 8px;
      transform: rotate(45deg);
    }
    .hook {
      padding: 0.5rem;
      display: inline-block;
      border-radius: 4px;
      background-color: #4f46e5;
      color: #fff;
    }
    .hook svg {
      width: 18px;
      height: 18px;
      color: #fff;
    }
  </style>
</template>

const EllipsisVertical = <template>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 512" fill="currentColor"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M64 360a56 56 0 1 0 0 112 56 56 0 1 0 0-112zm0-160a56 56 0 1 0 0 112 56 56 0 1 0 0-112zM120 96A56 56 0 1 0 8 96a56 56 0 1 0 112 0z"/></svg>
</template>;
```

</div>


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/menu" @name="Signature" />
</template>
```

## Accessibility

The `Content` of a popover is focusable, so that keyboard (and screenreader) users can interact with the Popover content. Generally this is great for modals, but also extends to things like tooltips, so that folks can copy the content out.

Since a `Popover` isn't an explicit design pattern provided by W3, but instead, `Popover` is a low level primitive that could be used to build the W3 examples of
- [Modal Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/dialog/)
- [Date Picker Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/)
- [Date Picker Combobox](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-datepicker/)
- [Select-Only Combobox](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-select-only/)
- and more



