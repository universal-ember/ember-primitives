# Sidebar (Off-Canvas Menu)

For implementing an off-canvas sidebar menu (also known as a drawer or hamburger menu), we recommend using [ember-mobile-menu](https://nickschot.github.io/ember-mobile-menu).

<Callout>

This library doesn't need to implement an off-canvas sidebar because [ember-mobile-menu](https://nickschot.github.io/ember-mobile-menu) already exists and provides a robust, accessible solution. We document it here as a recommended tool for this common UI pattern.

</Callout>

## Features

* **Draggable sidebar** - Users can drag the sidebar open and closed
* **Touch-friendly** - Optimized for mobile devices with touch gestures
* **Multiple positions** - Support for left, right, top, and bottom sidebars
* **Customizable** - Flexible styling and behavior options
* **Accessible** - Built with accessibility in mind
* **Shadow backdrop** - Optional backdrop overlay when sidebar is open

## Installation

```bash
npm install ember-mobile-menu
# or
pnpm add ember-mobile-menu
# or
yarn add ember-mobile-menu
```

## Basic Usage

```gjs
import MobileMenu from 'ember-mobile-menu/components/mobile-menu';

<template>
  <MobileMenu as |mmenu|>
    <mmenu.Toggle>
      <button type="button">
        Menu
      </button>
    </mmenu.Toggle>

    <mmenu.Sidebar as |s|>
      <s.Content>
        <nav>
          <ul>
            <li><a href="/home">Home</a></li>
            <li><a href="/about">About</a></li>
            <li><a href="/contact">Contact</a></li>
          </ul>
        </nav>
      </s.Content>
    </mmenu.Sidebar>

    <mmenu.Content>
      <main>
        Your main page content goes here
      </main>
    </mmenu.Content>
  </MobileMenu>
</template>
```

## Common Patterns

### Left Sidebar (Default)

The default position is on the left side of the screen:

```gjs
import MobileMenu from 'ember-mobile-menu/components/mobile-menu';

<template>
  <MobileMenu as |mmenu|>
    <mmenu.Toggle>
      <button type="button">☰</button>
    </mmenu.Toggle>

    <mmenu.Sidebar as |s|>
      <s.Content>
        <nav>
          <!-- Navigation items -->
        </nav>
      </s.Content>
    </mmenu.Sidebar>

    <mmenu.Content>
      <!-- Main content -->
    </mmenu.Content>
  </MobileMenu>
</template>
```

### Right Sidebar

To position the sidebar on the right:

```gjs
import MobileMenu from 'ember-mobile-menu/components/mobile-menu';

<template>
  <MobileMenu as |mmenu|>
    <mmenu.Toggle>
      <button type="button">Menu</button>
    </mmenu.Toggle>

    <mmenu.Sidebar @position="right" as |s|>
      <s.Content>
        <nav>
          <!-- Navigation items -->
        </nav>
      </s.Content>
    </mmenu.Sidebar>

    <mmenu.Content>
      <!-- Main content -->
    </mmenu.Content>
  </MobileMenu>
</template>
```

### With Shadow Backdrop

Add a shadow backdrop that appears when the sidebar is open:

```gjs
import MobileMenu from 'ember-mobile-menu/components/mobile-menu';

<template>
  <MobileMenu as |mmenu|>
    <mmenu.Toggle>
      <button type="button">Menu</button>
    </mmenu.Toggle>

    <mmenu.Sidebar as |s|>
      <s.Content>
        <nav>
          <!-- Navigation items -->
        </nav>
      </s.Content>
      <s.Shadow />
    </mmenu.Sidebar>

    <mmenu.Content>
      <!-- Main content -->
    </mmenu.Content>
  </MobileMenu>
</template>
```

## Configuration Options

The `<mmenu.Sidebar>` component accepts several options:

* `@position` - Position of the sidebar: `"left"`, `"right"`, `"top"`, or `"bottom"` (default: `"left"`)
* `@mask` - Whether to show a mask/backdrop (default: `true`)
* `@mode` - Opening mode: `"reveal"`, `"push"`, or `"slide"` (default: `"reveal"`)
* `@isOpen` - Control the open state programmatically

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

* **Mobile navigation** - Primary navigation on mobile devices
* **Settings panels** - Side panels with filters or settings
* **Shopping carts** - Slide-out cart summaries in e-commerce
* **User profiles** - Quick access to user information
* **Notification panels** - Displaying notifications or messages

ember-mobile-menu provides a production-ready solution for all these use cases and more.
