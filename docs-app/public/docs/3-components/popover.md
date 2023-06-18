# Popover (wip)

Popovers are built with [ember-velcro][gh-e-velcro], which is an ergonomic wrapper around [Floating UI][docs-floating], the successor to older (and more clunky) [Popper.JS][docs-popper]. 


<!--
The goal of a popover is to provide additional behavioral functionality to make interacting with floaty bits easier easier:
- focus trapping (TODO)
- focus returning (TODO) 
-->

The `<Popover>` component uses portals in a way that totally solves layering issues. See the `<Portal>` and `<PortalTargets>` pages for more information.

One thing to note is that the position of the popover can _escape_ the boundary of a [ShadowDom][docs-shadow-dom](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM) -- all demos on this docs site for `ember-primitives` use a `ShadowDom` to allow for isolated CSS usage within the demos.

[gh-e-velcro]: https://github.com/CrowdStrike/ember-velcro
[docs-floating]: https://floating-ui.com/
[docs-popper]: https://popper.js.org/

<div class="featured-demo">

```gjs live preview
import { PortalTargets, Popover } from 'ember-primitives';

<template>
  <PortalTargets />

  <Popover as |p|>
    <div class="hook" {{p.hook}}>
      the hook / anchor of the popover.
      This demo looks best in light mode<br>
    </div>
    <p.Content class="floatybit">
      The floaty bit here
    </p.Content>
  </Popover>

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
      border: 1px solid;
    }
    .hook {
      padding: 1rem;
    }
  </style>
</template>
```

</div>
