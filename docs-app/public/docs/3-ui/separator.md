# Separator

A semantic wrapper component that renders separators with proper ARIA attributes.

The `Separator` is **80% documentation and 20% boilerplate reduction**. It's a simple, semantic wrapper that automatically adds `aria-hidden="true"` to hide decorative content from screen readers.

<div class="featured-demo">

```gjs live preview
import { Separator } from "ember-primitives";

<template>
  <nav>
    <ol class="breadcrumb-list">
      <li><a href="/">Home</a></li>
      <Separator>/</Separator>
      <li><a href="/docs">Docs</a></li>
      <Separator>/</Separator>
      <li aria-current="page">Separator</li>
    </ol>
  </nav>

  <style>
    @scope {
      nav {
        user-select: none;
        background: var(--color-page-background);
        border-radius: 0.25rem;
        filter: drop-shadow(0 0 0.75rem rgba(0, 0, 0, 0.2));
        padding: 0.25rem 1rem;
        width: min-content;
      }

      .breadcrumb-list {
        list-style: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0;
        margin: 0;
      }

      a {
        color: #0066cc;
        text-decoration: none;
      }

      a:hover {
        text-decoration: underline;
      }

      li[aria-current="page"] {
        color: #666;
        font-weight: 600;
      }

      span[aria-hidden] {
        color: #999;
        user-select: none;
      }
    }
  </style>
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/separator.gts" />
```

## What It Does

The `Separator` component is primarily a **documentation and readability tool**. It:

- Makes the code more readable by clearly marking separator elements
- Automatically adds `aria-hidden="true"` to hide decorators from screen readers
- Provides a consistent pattern across your codebase

## Plain HTML Alternative

**Using plain HTML is just as easy!** The Separator component simply renders a `<span aria-hidden="true">` element with your content:

```gjs live preview
<template>
  <nav>
    <ol class="breadcrumb-list">
      <li><a href="/">Home</a></li>
      <span aria-hidden="true">/</span>
      <li><a href="/docs">Docs</a></li>
      <span aria-hidden="true">/</span>
      <li aria-current="page">Plain HTML</li>
    </ol>
  </nav>

  <style>
    @scope {
      nav {
        user-select: none;
        background: var(--color-page-background);
        border-radius: 0.25rem;
        filter: drop-shadow(0 0 0.75rem rgba(0, 0, 0, 0.2));
        padding: 0.25rem 1rem;
        width: min-content;
      }

      .breadcrumb-list {
        list-style: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0;
        margin: 0;
      }

      a {
        color: #0066cc;
        text-decoration: none;
      }

      a:hover {
        text-decoration: underline;
      }

      li[aria-current="page"] {
        color: #666;
        font-weight: 600;
      }

      span[aria-hidden] {
        color: #999;
        user-select: none;
      }
    }
  </style>
</template>
```

Both approaches are equally valid. Choose whichever feels more natural for your codebase!

## Anatomy

```gjs
import { Separator } from "ember-primitives/components/separator";

<template>
  <Separator>/</Separator>
</template>
```

## Usage Examples

### In Breadcrumbs

```gjs live preview
import { Breadcrumb, Separator } from "ember-primitives";

<template>
  <Breadcrumb as |b|>
    <li><a href="/">Home</a></li>
    <Separator>/</Separator>
    <li><a href="/docs">Docs</a></li>
    <Separator>/</Separator>
    <li aria-current="page">Current</li>
  </Breadcrumb>

  <style>
    @scope {
      nav {
        background: var(--color-page-background);
        padding: 0.25rem 1rem;
      }

      nav ol {
        list-style: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0;
        margin: 0;
      }

      nav a {
        color: #0066cc;
        text-decoration: none;
      }

      nav a:hover {
        text-decoration: underline;
      }

      nav li[aria-current="page"] {
        color: #666;
        font-weight: 600;
      }

      nav span[aria-hidden] {
        color: #999;
      }
    }
  </style>
</template>
```

### Custom Separators

You can use any content as a separator, including icons or symbols:

```gjs live preview
import { Separator } from "ember-primitives";

<template>
  <nav>
    <ol class="breadcrumb-list">
      <li><a href="/">Home</a></li>
      <Separator>&gt;</Separator>
      <li><a href="/products">Products</a></li>
      <Separator>→</Separator>
      <li aria-current="page">Details</li>
    </ol>
  </nav>

  <style>
    @scope {
      nav {
        user-select: none;
        background: var(--color-page-background);
        border-radius: 0.25rem;
        padding: 0.25rem 1rem;
        width: min-content;
      }

      .breadcrumb-list {
        list-style: none;
        display: flex;
        align-items: center;
        gap: 0.5rem;
        padding: 0;
        margin: 0;
      }

      a {
        color: #0066cc;
        text-decoration: none;
      }

      a:hover {
        text-decoration: underline;
      }

      li[aria-current="page"] {
        color: #666;
      }

      span[aria-hidden] {
        color: #999;
      }
    }
  </style>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/separator"
    @name="Signature"
  />
</template>
```

## Accessibility

The Separator component uses `aria-hidden="true"` to hide decorative content from screen readers. This ensures that screen reader users don't hear unnecessary separators like "/" or ">" when navigating breadcrumbs or other lists.

### Best Practices

- Use Separator for decorative visual separators only
- The content is hidden from screen readers, so don't use it for meaningful content
- Ensure sufficient color contrast between separators and background
