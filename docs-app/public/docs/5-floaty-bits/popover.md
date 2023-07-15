# Popover

Popovers are built with [ember-velcro][gh-e-velcro], which is an ergonomic wrapper around [Floating UI][docs-floating], the successor to older (and more clunky) [Popper.JS][docs-popper]. 


<!--
The goal of a popover is to provide additional behavioral functionality to make interacting with floaty bits easier easier:
- focus trapping (TODO)
- focus returning (TODO) 
-->

The `<Popover>` component uses portals in a way that totally solves layering issues. See the `<Portal>` and `<PortalTargets>` pages for more information.

One thing to note is that the position of the popover can _escape_ the boundary of a [ShadowDom][docs-shadow-dom] -- all demos on this docs site for `ember-primitives` use a `ShadowDom` to allow for isolated CSS usage within the demos.

[gh-e-velcro]: https://github.com/CrowdStrike/ember-velcro
[docs-floating]: https://floating-ui.com/
[docs-popper]: https://popper.js.org/
[docs-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

<div class="featured-demo">

```gjs live preview
import { PortalTargets, Popover } from 'ember-primitives';
import { hash } from '@ember/helper';
import { loremIpsum } from 'lorem-ipsum';

<template>
  <PortalTargets />

  <div class="scroll-content" tabindex="0">
    {{loremIpsum (hash count=1 units="paragraphs")}}

    <Popover @placement="top" @offsetOptions={{8}} as |p|>
      <div class="hook" {{p.hook}}>
        the hook / anchor of the popover.
        <br> it sticks the boundary of this element.
      </div>
      <p.Content class="floatybit">
        The floaty bit here
        <div class="arrow" {{p.arrow}}></div>
      </p.Content>
    </Popover>

    {{loremIpsum (hash count=2 units="paragraphs")}}
  </div>

  <style>
    .floatybit {
      width: max-content;
      position: absolute;
      top: 0;
      left: 0;
      background: #222;
      color: white;
      font-weight: bold;
      padding: 5px;
      border-radius: 4px;
      font-size: 90%;
      filter: drop-shadow(0 0 0.75rem rgba(0,0,0,0.4));
      z-index: 10;
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
      border: 1px solid;
      display: inline-block;
      color: black;
    }
    .scroll-content {
      max-height: 150px;
      overflow-y: auto;
      border: 1px solid;
      padding: 0.5rem;
      color: #888;
    }
  </style>
</template>
```

</div>


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/popover" @name="Signature" />
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
