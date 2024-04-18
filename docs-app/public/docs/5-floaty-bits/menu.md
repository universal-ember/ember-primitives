# Menu

Menus are built with Popovers, with added features for keyboard navigation and accessibility. 

The placement of the menu content is handled by `<Popover>`, so `<Menu>` accepts the same arguments for positioning the dropdown.

Like `<Popover>`, the `<Menu>` component uses portals in a way that totally solves layering issues. No more worrying about tooltips on varying layers of your UI sometimes appearing behind other floaty bits. See the `<Portal>` and `<PortalTargets>` pages for more information.

<div class="featured-demo">

```gjs live preview no-shadow
import { PortalTargets, Menu } from 'ember-primitives';

<template>
  <PortalTargets />

  <Menu @offsetOptions={{8}} as |m|>
    <m.Trigger class="trigger" aria-label="Options">
      <EllipsisVertical />
    </m.Trigger>

    <m.Content class="content" as |c|>
      <c.Item>Item 1</c.Item>
      <c.Item>Item 2</c.Item>
      <c.Separator />
      <c.Item>Item 3</c.Item>
    </m.Content>
  </Menu>

  <style>
    .content {
      all: unset;
      min-width: 180px;
      background: #fff;
      color: #111827;
      padding: 8px 0;
      border-radius: 6px;
      border: none;
      font-size: 14px;
      z-index: 10;
      box-shadow: 0 0 #0000, 0 0 #0000, 0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1);
      display: flex;
      flex-direction: column;
    }

    .content [role="menuitem"] {
      all: unset;
      display: block;
      padding: 4px 12px;
      cursor: pointer;
    }

    .content [role="menuitem"]:focus, .trigger:hover {
      background-color: #f9fafb;
    }

    .content [role="separator"] {
      border-bottom: 1px solid rgb(17 24 39 / 0.1);
    }

    .trigger {
      display: inline-block;
      border-radius: 4px;
      border-width: 0;
      background-color: #fff;
      color: #111827;
      border-radius: 100%;
      padding: 10px;
      box-shadow: rgba(0, 0, 0, 0.2) 0px 2px 10px;
      cursor: pointer;
    }

    .trigger svg {
      width: 15px;
      height: 15px;
      display: block;
    }
  </style>
</template>

const EllipsisVertical = <template>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 128 512" fill="currentColor"><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path d="M64 360a56 56 0 1 0 0 112 56 56 0 1 0 0-112zm0-160a56 56 0 1 0 0 112 56 56 0 1 0 0-112zM120 96A56 56 0 1 0 8 96a56 56 0 1 0 112 0z"/></svg>
</template>;
```

</div>


Sometimes, you need to use an existing component as the trigger. `<Menu>` also yields a `trigger` modifier that you can use anywhere, even on your own components (e.g a custom button):


```hbs
<Menu as |m|>
  <MyButton {{m.trigger}}>
    <EllipsisVertical />
  </MyButton>

  <m.Content class="content" as |c|>
    <c.Item>Item 1</c.Item>
    <c.Item>Item 2</c.Item>
    <c.Separator />
    <c.Item>Item 3</c.Item>
  </m.Content>
</Menu>
```

Keep in mind that for the modifier to do its work, your custom component must use [`...attributes`](https://guides.emberjs.com/v5.7.0/components/component-arguments-and-html-attributes/#toc_html-attributes) in some HTML element.


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/menu" @name="Signature" />
</template>
```

## Accessibility

Adheres to the [Menu Button WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/).

### Keyboard Interactions

| key | description |
| :---: | :----------- |
| <kbd>Space</kbd> <kbd>Enter</kbd>  | When focus is on `Trigger`, opens the menu and focuses the first item. When focus is on an `Item`, activates the focused item. |
| <kbd>ArrowDown</kbd> <kbd>ArrowRight</kbd> | When `Content` is open, moves to the next item.  |
| <kbd>ArrowUp</kbd> <kbd>ArrowLeft</kbd> | When `Content` is open, moves to the previous item.  |
| <kbd>Esc</kbd> | Closes the menu and moves focus to `Trigger`. |

In addition, a label is required so that users know what the switch is for.
