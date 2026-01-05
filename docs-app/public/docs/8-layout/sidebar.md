# Sidebar (Off-Canvas Menu)

For implementing an off-canvas sidebar menu (also known as a drawer or hamburger menu), we recommend using [ember-mobile-menu](https://nickschot.github.io/ember-mobile-menu).

<Callout>

This library doesn't need to implement an off-canvas sidebar because [ember-mobile-menu](https://nickschot.github.io/ember-mobile-menu) already exists and provides a robust, accessible solution. We document it here as a recommended tool for this common UI pattern. But please see [their docs](https://nickschot.github.io/ember-mobile-menu/) for more thorough examples.

</Callout>

## Features

- Good for use on non-touch devices as well as touch devices
- **Draggable sidebar** - Users can drag the sidebar open and closed
- **Touch-friendly** - Optimized for mobile devices with touch gestures
- **Multiple positions** - Support for left, right, top, and bottom sidebars
- **Multiple Menus** - have left right, etc simultaneously
- **Customizable** - Flexible styling and behavior options
- **Accessible** - Built with accessibility in mind
- **Shadow backdrop** - Optional backdrop overlay when sidebar is open

## Install

```hbs live
<SetupInstructions @name="ember-mobile-menu" />
```

## Example

<div class="featured-demo">

```gjs live preview
import { Shadowed } from "ember-primitives/components/shadowed";
import MobileMenuWrapper from "ember-mobile-menu/components/mobile-menu-wrapper";
import { on } from "@ember/modifier";

<template>
  <Shadowed>
    <div style="height:150px">
      <MobileMenuWrapper @embed={{true}} as |mmw|>
        <mmw.MobileMenu as |mm|>
          <button {{on "click" mm.actions.close}}>close</button>
        </mmw.MobileMenu>

        <mmw.Content>
          <mmw.Toggle>Menu</mmw.Toggle>

          content here
        </mmw.Content>
      </MobileMenuWrapper>
    </div>

    <style>
      /* The default theme included with the library */
      .mobile-menu {
        position: fixed;
        top: 0;
        width: 0;
      }

      .mobile-menu.mobile-menu--left {
        left: 0;
      }
      .mobile-menu.mobile-menu--right {
        right: 0;
      }

      /* variants */
      .mobile-menu--default {
        z-index: var(--mobile-menu-z-index);
      }
      .mobile-menu--squeeze,
      .mobile-menu--push {
        z-index: 2;
      }
      .mobile-menu--ios,
      .mobile-menu--reveal,
      .mobile-menu--squeeze-reveal {
        display: none;
        z-index: -1;
      }
      .mobile-menu--ios.mobile-menu--dragging,
      .mobile-menu--ios.mobile-menu--transitioning,
      .mobile-menu--ios.mobile-menu--open,
      .mobile-menu--reveal.mobile-menu--dragging,
      .mobile-menu--reveal.mobile-menu--transitioning,
      .mobile-menu--reveal.mobile-menu--open,
      .mobile-menu--squeeze-reveal.mobile-menu--dragging,
      .mobile-menu--squeeze-reveal.mobile-menu--transitioning,
      .mobile-menu--squeeze-reveal.mobile-menu--open {
        display: block;
        z-index: unset;
      }
      .mobile-menu--ios .mobile-menu__mask,
      .mobile-menu--reveal .mobile-menu__mask,
      .mobile-menu--squeeze-reveal .mobile-menu__mask {
        z-index: 1;
      }
      .mobile-menu--ios.mobile-menu--open .mobile-menu__mask,
      .mobile-menu--reveal.mobile-menu--open .mobile-menu__mask,
      .mobile-menu--squeeze-reveal.mobile-menu--open .mobile-menu__mask {
        display: none;
      }

      .mobile-menu-wrapper--embedded .mobile-menu {
        position: absolute;
      }
      .mobile-menu-wrapper--embedded .mobile-menu__mask,
      .mobile-menu-wrapper--embedded .mobile-menu.mobile-menu--open,
      .mobile-menu-wrapper--embedded .mobile-menu.mobile-menu--transitioning,
      .mobile-menu-wrapper--embedded .mobile-menu.mobile-menu--dragging {
        width: 100%;
      }
      .mobile-menu-wrapper--embedded .mobile-menu,
      .mobile-menu-wrapper--embedded .mobile-menu__mask,
      .mobile-menu-wrapper--embedded .mobile-menu .mobile-menu__tray {
        height: var(--mobile-menu-height);
      }

      .mobile-menu__toggle {
        cursor: pointer;
      }

      @layer ember-mobile-menu {
        :root {
          --mobile-menu-wrapper-width: 100%;
          --mobile-menu-wrapper-min-height: 100vh;

          --mobile-menu-height: 100vh;
          --mobile-menu-z-index: 2000;
        }
      }

      body.mobile-menu--prevent-scroll {
        overflow: hidden;
      }

      .mobile-menu-wrapper {
        overflow: hidden;
        width: var(--mobile-menu-wrapper-width);
        min-height: var(--mobile-menu-wrapper-min-height);
        /* Avoid Chrome to see Safari hack */
      }
      @supports (-webkit-touch-callout: none) {
        .mobile-menu-wrapper {
          /* The hack for Safari */
          min-height: -webkit-fill-available;
        }
      }

      .mobile-menu-wrapper--embedded {
        position: relative;
        min-height: 100%;
        min-width: 100%;
        overflow: hidden;
      }
      .mobile-menu-wrapper--embedded .mobile-menu-wrapper__content {
        min-height: 100%;
      }

      .mobile-menu-wrapper__content {
        color: black;
        padding: 0.5rem;
        min-height: var(--mobile-menu-wrapper-min-height);
        position: relative;
        background: #fff;
        will-change: transform, margin-left, margin-right;
        z-index: 1;
        touch-action: pan-y;
      }
      .mobile-menu-wrapper__content--shadow {
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
      }
      .mobile-menu-wrapper__content--ios,
      .mobile-menu-wrapper__content--reveal,
      .mobile-menu-wrapper__content--squeeze-reveal {
        z-index: 2;
      }

      .mobile-menu__mask {
        position: absolute;
        top: 0;
        left: 0;
        border: none;
        border-radius: 0;
        margin: 0;
        padding: 0;
        width: 100vw;
        height: 100vh;
        /* Avoid Chrome to see Safari hack */
        background: rgba(0, 0, 0, 0.3);
        opacity: 0;
        transition: none;
        touch-action: pan-y;
        will-change: opacity;
        visibility: hidden;
        outline: none;
        -webkit-tap-highlight-color: transparent;
      }
      @supports (-webkit-touch-callout: none) {
        .mobile-menu__mask {
          /* The hack for Safari */
          height: -webkit-fill-available;
        }
      }

      .mobile-menu__tray {
        position: absolute;
        top: 0;
        height: var(--mobile-menu-height);
        /* Avoid Chrome to see Safari hack */
        overflow-y: auto;
        touch-action: pan-y;
        background: #fff;
        will-change: transform;
      }
      @supports (-webkit-touch-callout: none) {
        .mobile-menu__tray {
          /* The hack for Safari */
          height: -webkit-fill-available;
        }
      }

      @layer ember-mobile-menu {
        :root {
          --mobile-menu-header-bg: #e04e39;

          --mobile-menu-item-color: #333;
          --mobile-menu-item-active-bg: #eee;
          --mobile-menu-item-link-disabled-color: #6c757d;
        }
      }

      .mobile-menu__tray .mobile-menu__header {
        min-height: 150px;
        background: var(--mobile-menu-header-bg);
        color: #fff;
        margin-bottom: 8px;
      }
      .mobile-menu__tray .mobile-menu__header .header__text {
        padding: 16px;
      }
      .mobile-menu__tray .mobile-menu__header .header__btn {
        padding: 16px;
        color: #fff;
        text-decoration: none;
      }

      .mobile-menu__tray .mobile-menu__nav {
        list-style: none;
        padding: 0;
        margin: 0;
      }
      .mobile-menu__tray .mobile-menu__nav .mobile-menu__nav-item a {
        display: block;
        font-size: 12px;
        font-weight: bold;
        color: var(--mobile-menu-item-color);
        line-height: 1.5;
        text-decoration: none !important;

        padding: 12px;
      }
      .mobile-menu__tray .mobile-menu__nav .mobile-menu__nav-item a.mobile-menu__nav-link.disabled {
        color: var(--mobile-menu-item-link-disabled-color);
      }
      .mobile-menu__tray .mobile-menu__nav .mobile-menu__nav-item a.active {
        background: var(--mobile-menu-item-active-bg);
      }
      .mobile-menu__tray .mobile-menu__nav .mobile-menu__nav-divider {
        margin: 8px 0;
        height: 0;
        border-bottom: 1px solid var(--mobile-menu-item-active-bg);
      }
    </style>
  </Shadowed>
</template>
```

</div>

## Styling

ember-mobile-menu provides default styles but allows for customization. You can override the default styles by targeting the component's CSS classes or by providing your own styles.

## Accessibility

ember-mobile-menu handles keyboard navigation and focus management automatically. The sidebar can be closed with the Escape key, and focus is properly managed when opening and closing.

## Resources

- [ember-mobile-menu Documentation](https://nickschot.github.io/ember-mobile-menu)
- [GitHub Repository](https://github.com/nickschot/ember-mobile-menu)
- [NPM Package](https://www.npmjs.com/package/ember-mobile-menu)

## Use Cases

Off-canvas sidebars are commonly used for:

- **Mobile navigation** - Primary navigation on mobile devices
- **Settings panels** - Side panels with filters or settings
- **Shopping carts** - Slide-out cart summaries in e-commerce
- **User profiles** - Quick access to user information
- **Notification panels** - Displaying notifications or messages

ember-mobile-menu provides a production-ready solution for all these use cases and more.
