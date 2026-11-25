# Menu

Menus are built with Popovers, with added features for keyboard navigation and accessibility.

The placement of the menu content is handled by `<Popover>`, so `<Menu>` accepts the same arguments for positioning the dropdown.

Like `<Popover>`, the `<Menu>` component uses the [Popover API](https://developer.mozilla.org/en-US/docs/Web/API/Popover_API) for layering, which totally solves z-index and overflow clipping issues, no portals needed.

<div class="featured-demo">

```gjs live preview no-shadow
import { Menu } from "ember-primitives";

<template>
  <Menu @offsetOptions={{8}} as |m|>
    <m.Trigger class="trigger" aria-label="Options">
      <EllipsisVertical />
    </m.Trigger>

    <m.Content class="content" as |c|>
      <c.Item>Item 1</c.Item>
      <c.Item>Item 2</c.Item>
      <c.Separator />
      <c.LinkItem class="not-prose" @href="/">Item 3</c.LinkItem>
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
      padding: 4px 12px;
      cursor: pointer;
    }

    .content [role="menuitem"]:focus,
    .trigger:hover {
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
  <svg
    xmlns="http://www.w3.org/2000/svg"
    viewBox="0 0 128 512"
    fill="currentColor"
  ><!--!Font Awesome Free 6.5.2 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license/free Copyright 2024 Fonticons, Inc.--><path
      d="M64 360a56 56 0 1 0 0 112 56 56 0 1 0 0-112zm0-160a56 56 0 1 0 0 112 56 56 0 1 0 0-112zM120 96A56 56 0 1 0 8 96a56 56 0 1 0 112 0z"
    /></svg>
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

## Disabled items

Pass `@disabled` to an `Item` or a `LinkItem` to disable it. A disabled item renders a `DisabledItem` in its place. You can also use `DisabledItem` directly.

A disabled `LinkItem` renders a `<button>` with no `href`.

A disabled item:

- stays focusable, and arrow keys still move to it
- has `aria-disabled="true"`, not the `disabled` attribute
- does nothing when you click it or press <kbd>Enter</kbd>
- does not close the menu

Screen reader users can find a disabled item and hear that it is unavailable. See [Focusability of disabled controls](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/#focusabilityofdisabledcontrols).

```gjs live preview no-shadow
import { Menu } from "ember-primitives";

<template>
  <Menu @offsetOptions={{8}} as |m|>
    <m.Trigger class="trigger">Actions</m.Trigger>

    <m.Content class="content" as |c|>
      <c.Item>Edit</c.Item>
      <c.Item @disabled={{true}}>Delete</c.Item>
      <c.LinkItem @href="/" @disabled={{true}}>Settings</c.LinkItem>
      <c.DisabledItem>Archive</c.DisabledItem>
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
      font-size: 14px;
      box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
      display: flex;
      flex-direction: column;
    }

    .content [role="menuitem"] {
      all: unset;
      display: block;
      padding: 4px 12px;
      cursor: pointer;
    }

    .content [role="menuitem"]:focus {
      background-color: #f9fafb;
    }

    .content [role="menuitem"][aria-disabled="true"] {
      color: #6b7280;
      cursor: not-allowed;
    }

    .trigger {
      border: 0;
      border-radius: 4px;
      background-color: #fff;
      color: #111827;
      padding: 6px 12px;
      box-shadow: rgba(0, 0, 0, 0.2) 0px 2px 10px;
      cursor: pointer;
    }
  </style>
</template>
```

## Custom items

You can wrap `Item` or `DisabledItem` in your own component. Pass the yielded component to your component as an argument, and forward `...attributes` to it.

The yielded `Item` is the only way to close the menu from inside it. `Item` also gives you:

- `role="menuitem"` on a `<button type="button">`
- `@onSelect`, and a menu that closes after a click or <kbd>Enter</kbd>
- focus that follows the pointer, as in native menus

You can use your own element instead of `Item`. Give it `role="menuitem"` and make it focusable, and arrow keys will move to it. The menu does not close when you click it, so do this only for items that keep the menu open.

This example shows why an item is disabled. The reason shows under the item label. `aria-describedby` makes screen readers read the reason after the label.

```gjs live preview no-shadow
import { uniqueId } from "@ember/helper";
import { Menu } from "ember-primitives";

const actions = [
  { label: "Edit" },
  { label: "Delete", disabledReason: "Only admins can delete this project." },
];

/**
 * `aria-labelledby` keeps the reason out of the item name.
 */
const DisabledWithReason = <template>
  {{#let (uniqueId) (uniqueId) as |labelId reasonId|}}
    <@DisabledItem aria-labelledby={{labelId}} aria-describedby={{reasonId}} ...attributes>
      <span id={{labelId}}>{{yield}}</span>
      <span id={{reasonId}} class="reason">{{@reason}}</span>
    </@DisabledItem>
  {{/let}}
</template>;

<template>
  <Menu @offsetOptions={{8}} as |m|>
    <m.Trigger class="trigger">Actions</m.Trigger>

    <m.Content class="content" as |c|>
      {{#each actions as |action|}}
        {{#if action.disabledReason}}
          <DisabledWithReason @DisabledItem={{c.DisabledItem}} @reason={{action.disabledReason}}>
            {{action.label}}
          </DisabledWithReason>
        {{else}}
          <c.Item>{{action.label}}</c.Item>
        {{/if}}
      {{/each}}
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
      font-size: 14px;
      box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
      display: flex;
      flex-direction: column;
    }

    .content [role="menuitem"] {
      all: unset;
      display: flex;
      flex-direction: column;
      padding: 4px 12px;
      cursor: pointer;
    }

    .content [role="menuitem"]:focus {
      background-color: #f9fafb;
    }

    .content [role="menuitem"][aria-disabled="true"] {
      color: #6b7280;
      cursor: not-allowed;
    }

    .content .reason {
      font-size: 12px;
    }

    .trigger {
      border: 0;
      border-radius: 4px;
      background-color: #fff;
      color: #111827;
      padding: 6px 12px;
      box-shadow: rgba(0, 0, 0, 0.2) 0px 2px 10px;
      cursor: pointer;
    }
  </style>
</template>
```

## Install

```hbs live
<SetupInstructions @src="components/menu.gts" @since="0.15.0" />
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/menu"
    @name="Signature"
  />
</template>
```

## Accessibility

Adheres to the [Menu Button WAI-ARIA design pattern](https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/).

Disabled items stay in the keyboard order. <kbd>Space</kbd> and <kbd>Enter</kbd> on a disabled item do nothing.

### Keyboard Interactions

|                    key                     | description                                                                                                                    |
| :----------------------------------------: | :----------------------------------------------------------------------------------------------------------------------------- |
|     <kbd>Space</kbd> <kbd>Enter</kbd>      | When focus is on `Trigger`, opens the menu and focuses the first item. When focus is on an `Item`, activates the focused item. |
| <kbd>ArrowDown</kbd> <kbd>ArrowRight</kbd> | When `Content` is open, moves to the next item.                                                                                |
|  <kbd>ArrowUp</kbd> <kbd>ArrowLeft</kbd>   | When `Content` is open, moves to the previous item.                                                                            |
|               <kbd>Esc</kbd>               | Closes the menu and moves focus to `Trigger`.                                                                                  |

## Migrating from <= v0.55

### Remove `<PortalTargets />`

`<Menu>` now uses the browser's Popover API for layering. You no longer need `<PortalTargets />` in your templates.

```diff
- import { PortalTargets, Menu } from 'ember-primitives';
+ import { Menu } from 'ember-primitives/components/menu';

  <template>
-   <PortalTargets />
    <Menu as |m|>
      ...
    </Menu>
  </template>
```

### Remove `@inline`

The `@inline` argument has been removed. Menu content now renders inline in the DOM and uses the Popover API for layering.

### CSS considerations

The `popover` HTML attribute has a browser UA stylesheet that adds default `border` and `overflow` styles to elements with `[popover]`. You may need to set `border: none` on your menu content if you don't want the browser's default `[popover]` border. The component resets `overflow: visible` automatically.
