# MenuBar

A visually persistent horizontal menu bar common in desktop applications that provides access to a consistent set of commands. It builds upon the existing `<Menu>` component by adding horizontal keyboard navigation between menu triggers.

The placement of each menu's content is handled by `<Popover>`, so each menu accepts the same arguments for positioning the dropdown as `<Menu>` does.

Like `<Menu>`, the `<MenuBar>` component uses portals in a way that totally solves layering issues. No more worrying about tooltips on varying layers of your UI sometimes appearing behind other floaty bits. See the `<Portal>` and `<PortalTargets>` pages for more information.

<div class="featured-demo">

```gjs live preview no-shadow
import { PortalTargets, MenuBar } from "ember-primitives";

<template>
  <PortalTargets />

  <MenuBar class="menubar">
    <:default as |mb|>
      <mb.Menu as |m|>
        <m.Trigger class="trigger">File</m.Trigger>

        <m.Content class="content" as |c|>
          <c.Item>New File</c.Item>
          <c.Item>Open File...</c.Item>
          <c.Separator />
          <c.Item>Save</c.Item>
          <c.Item>Save As...</c.Item>
          <c.Separator />
          <c.Item>Exit</c.Item>
        </m.Content>
      </mb.Menu>

      <mb.Menu as |m|>
        <m.Trigger class="trigger">Edit</m.Trigger>

        <m.Content class="content" as |c|>
          <c.Item>Undo</c.Item>
          <c.Item>Redo</c.Item>
          <c.Separator />
          <c.Item>Cut</c.Item>
          <c.Item>Copy</c.Item>
          <c.Item>Paste</c.Item>
        </m.Content>
      </mb.Menu>

      <mb.Menu as |m|>
        <m.Trigger class="trigger">View</m.Trigger>

        <m.Content class="content" as |c|>
          <c.Item>Zoom In</c.Item>
          <c.Item>Zoom Out</c.Item>
          <c.Separator />
          <c.Item>Full Screen</c.Item>
        </m.Content>
      </mb.Menu>
    </:default>
  </MenuBar>

  <style>
    .menubar {
      display: flex;
      gap: 4px;
      background: #f9fafb;
      padding: 4px;
      border-radius: 6px;
      border: 1px solid #e5e7eb;
    }

    .trigger {
      all: unset;
      padding: 6px 12px;
      font-size: 14px;
      cursor: pointer;
      border-radius: 4px;
      color: #111827;
    }

    .trigger:hover,
    .trigger:focus {
      background-color: #e5e7eb;
    }

    .content {
      all: unset;
      min-width: 180px;
      background: #fff;
      color: #111827;
      padding: 8px 0;
      border-radius: 6px;
      border: 1px solid #e5e7eb;
      font-size: 14px;
      z-index: 10;
      box-shadow:
        0 0 #0000,
        0 0 #0000,
        0 10px 15px -3px rgb(0 0 0 / 0.1),
        0 4px 6px -4px rgb(0 0 0 / 0.1);
      display: flex;
      flex-direction: column;
    }

    .content [role="menuitem"] {
      all: unset;
      display: block;
      padding: 8px 12px;
      cursor: pointer;
    }

    .content [role="menuitem"]:focus {
      background-color: #f3f4f6;
      outline: none;
    }

    .content [role="separator"] {
      border-bottom: 1px solid rgb(17 24 39 / 0.1);
      margin: 4px 0;
    }
  </style>
</template>
```

</div>

## Features

- **Horizontal Navigation**: Use <kbd>ArrowLeft</kbd> and <kbd>ArrowRight</kbd> to navigate between menu triggers.
- **Menu Item Navigation**: Use <kbd>ArrowDown</kbd> and <kbd>ArrowUp</kbd> to navigate within opened menus.
- **Cyclic Navigation**: Navigation wraps around from the last item to the first (and vice versa).
- **Accessible**: Adheres to the WAI-ARIA menubar pattern with proper roles and keyboard interactions.

## Using Link Items

Just like `<Menu>`, you can use `LinkItem` for navigation:

```hbs
<MenuBar as |mb|>
  <mb.Menu as |m|>
    <m.Trigger>File</m.Trigger>

    <m.Content as |c|>
      <c.LinkItem @href="/">Home</c.LinkItem>
      <c.LinkItem @href="/about">About</c.LinkItem>
    </m.Content>
  </mb.Menu>
</MenuBar>
```

## Install

```hbs live
<SetupInstructions @src="components/menubar.gts" />
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/menubar"
    @name="Signature"
  />
</template>
```

## Accessibility

Adheres to the [MenuBar WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menubar/).

### Keyboard Interactions

|                key                | description                                                                                                                  |
| :-------------------------------: | :--------------------------------------------------------------------------------------------------------------------------- |
|       <kbd>ArrowLeft</kbd>        | When focus is on a trigger in the menubar, moves to the previous trigger.                                                    |
|       <kbd>ArrowRight</kbd>       | When focus is on a trigger in the menubar, moves to the next trigger.                                                        |
| <kbd>Space</kbd> <kbd>Enter</kbd> | When focus is on a trigger, opens the menu and focuses the first item. When focus is on an item, activates the focused item. |
|       <kbd>ArrowDown</kbd>        | When a menu is open, moves to the next item.                                                                                 |
|        <kbd>ArrowUp</kbd>         | When a menu is open, moves to the previous item.                                                                             |
|          <kbd>Esc</kbd>           | Closes the open menu and moves focus back to its trigger.                                                                    |

## Comparison with Menu

`<MenuBar>` differs from `<Menu>` in the following ways:

- **Layout**: MenuBar provides a horizontal container with `role="menubar"` that groups multiple menus together.
- **Navigation**: Adds horizontal keyboard navigation between menu triggers with <kbd>ArrowLeft</kbd> and <kbd>ArrowRight</kbd>.
- **Use Case**: Best for application-level navigation bars, whereas `<Menu>` is better for standalone context menus or action menus.
