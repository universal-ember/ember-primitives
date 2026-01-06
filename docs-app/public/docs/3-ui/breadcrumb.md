# Breadcrumb

A breadcrumb navigation component that displays the current page's location within a navigational hierarchy.

Breadcrumbs help users understand their current location and provide a way to navigate back through the hierarchy.

<div class="featured-demo">

```gjs live preview no-shadow
import { Breadcrumb, Menu, PortalTargets } from 'ember-primitives';

<template>
  <PortalTargets />

  <Breadcrumb as |b|>
    <b.Item>
      <b.Link @href="/">Home</b.Link>
    </b.Item>
    <b.Separator>/</b.Separator>
    <b.Item>
      <Menu @offsetOptions={{8}} as |m|>
        <m.Trigger class="menu-trigger">
          Docs
          <ChevronDown />
        </m.Trigger>
        <m.Content class="menu-content" as |c|>
          <c.LinkItem class="not-prose" @href="/docs">Overview</c.LinkItem>
          <c.LinkItem class="not-prose" @href="/docs/getting-started">Getting Started</c.LinkItem>
          <c.LinkItem class="not-prose" @href="/docs/components">Components</c.LinkItem>
        </m.Content>
      </Menu>
    </b.Item>
    <b.Separator>/</b.Separator>
    <b.Item>
      <b.Link @href="/docs/components">Components</b.Link>
    </b.Item>
    <b.Separator>/</b.Separator>
    <b.Item aria-current="page">
      Breadcrumb
    </b.Item>
  </Breadcrumb>

  <style>
    nav[aria-label="Breadcrumb"] {
      padding: 1rem;
    }
    
    nav[aria-label="Breadcrumb"] ol {
      list-style: none;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0;
      margin: 0;
    }

    nav[aria-label="Breadcrumb"] a {
      color: #0066cc;
      text-decoration: none;
    }

    nav[aria-label="Breadcrumb"] a:hover {
      text-decoration: underline;
    }

    nav[aria-label="Breadcrumb"] li[aria-current="page"] {
      color: #666;
      font-weight: 600;
    }

    nav[aria-label="Breadcrumb"] span[aria-hidden] {
      color: #999;
      user-select: none;
    }

    .menu-trigger {
      all: unset;
      color: #0066cc;
      cursor: pointer;
      display: inline-flex;
      align-items: center;
      gap: 0.25rem;
    }

    .menu-trigger:hover {
      text-decoration: underline;
    }

    .menu-trigger svg {
      width: 12px;
      height: 12px;
    }

    .menu-content {
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

    .menu-content [role="menuitem"] {
      all: unset;
      display: block;
      padding: 4px 12px;
      cursor: pointer;
      color: #111827;
    }

    .menu-content [role="menuitem"]:focus,
    .menu-content [role="menuitem"]:hover {
      background-color: #f9fafb;
    }
  </style>
</template>

const ChevronDown = <template>
  <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
    <polyline points="6 9 12 15 18 9"></polyline>
  </svg>
</template>;
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/breadcrumb.gts" />
```

## Features

* Semantic HTML structure using `<nav>`, `<ol>`, and `<li>` elements
* Proper ARIA attributes for accessibility
* Flexible separator component
* Full control over styling

## Anatomy

```js
import { Breadcrumb } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js
import { Breadcrumb } from 'ember-primitives/components/breadcrumb';
```

```gjs
import { Breadcrumb } from 'ember-primitives';

<template>
  <Breadcrumb as |b|>
    <b.Item>
      <b.Link @href="/">Home</b.Link>
    </b.Item>
    <b.Separator>/</b.Separator>
    <b.Item>
      <b.Link @href="/docs">Docs</b.Link>
    </b.Item>
    <b.Separator>/</b.Separator>
    <b.Item aria-current="page">
      Current Page
    </b.Item>
  </Breadcrumb>
</template>
```

## Examples

### Custom Separator

You can use any content as a separator, including icons or symbols:

```gjs live preview
import { Breadcrumb } from 'ember-primitives';

<template>
  <Breadcrumb as |b|>
    <b.Item>
      <b.Link @href="/">Home</b.Link>
    </b.Item>
    <b.Separator>&gt;</b.Separator>
    <b.Item>
      <b.Link @href="/products">Products</b.Link>
    </b.Item>
    <b.Separator>&gt;</b.Separator>
    <b.Item aria-current="page">
      Details
    </b.Item>
  </Breadcrumb>

  <style>
    nav[aria-label="Breadcrumb"] {
      padding: 1rem;
    }
    
    nav[aria-label="Breadcrumb"] ol {
      list-style: none;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0;
      margin: 0;
    }

    nav[aria-label="Breadcrumb"] a {
      color: #0066cc;
      text-decoration: none;
    }

    nav[aria-label="Breadcrumb"] a:hover {
      text-decoration: underline;
    }

    nav[aria-label="Breadcrumb"] li[aria-current="page"] {
      color: #666;
    }

    nav[aria-label="Breadcrumb"] span[aria-hidden] {
      color: #999;
    }
  </style>
</template>
```

### Custom Label

You can provide a custom accessible label for the breadcrumb navigation:

```gjs live preview
import { Breadcrumb } from 'ember-primitives';

<template>
  <Breadcrumb @label="Page Navigation" as |b|>
    <b.Item>
      <b.Link @href="/">Home</b.Link>
    </b.Item>
    <b.Separator>/</b.Separator>
    <b.Item aria-current="page">
      About
    </b.Item>
  </Breadcrumb>

  <style>
    nav[aria-label] {
      padding: 1rem;
    }
    
    nav[aria-label] ol {
      list-style: none;
      display: flex;
      align-items: center;
      gap: 0.5rem;
      padding: 0;
      margin: 0;
    }

    nav[aria-label] a {
      color: #0066cc;
      text-decoration: none;
    }

    nav[aria-label] a:hover {
      text-decoration: underline;
    }

    nav[aria-label] li[aria-current="page"] {
      color: #666;
    }

    nav[aria-label] span[aria-hidden] {
      color: #999;
    }
  </style>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/breadcrumb" 
    @name="Signature" 
  />
</template>
```

## Accessibility

### ARIA Attributes

The breadcrumb component uses proper ARIA attributes to ensure accessibility:

* The root `<nav>` element has `aria-label="Breadcrumb"` (or a custom label if provided)
* Separators have `aria-hidden="true"` to hide them from screen readers
* The current page item should have `aria-current="page"` to indicate the current location

### Screen Reader Support

Screen readers will announce the breadcrumb navigation as a landmark with the label "Breadcrumb" (or custom label). Each link will be announced individually, and separators are hidden from screen readers to avoid clutter.

### Best Practices

* Always mark the current page with `aria-current="page"` on the last item
* The current page item should not be a link
* Keep breadcrumb labels concise and descriptive
* Ensure sufficient color contrast for links and text
