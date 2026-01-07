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
      <Separator @as="li">/</Separator>
      <li><a href="/docs">Docs</a></li>
      <Separator @as="li">/</Separator>
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

      li[aria-hidden] {
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
- Allows customizing the element tag via the `@as` argument

## The `@as` Argument

By default, the Separator renders as a `<span>` element. However, when used in lists where separators need to be siblings to `<li>` elements, you should use `@as="li"` to ensure proper HTML structure:

```gjs
<ol>
  <li>Item 1</li>
  <Separator @as="li">/</Separator>
  <li>Item 2</li>
</ol>
```

This is important because in HTML, `<ol>` and `<ul>` elements should only have `<li>` children. Using `<span>` elements as siblings to `<li>` elements is invalid HTML.

## Plain HTML Alternative

**Using plain HTML is just as easy!** The Separator component renders an element with `aria-hidden="true"`:

```gjs live preview
<template>
  <nav>
    <ol class="breadcrumb-list">
      <li><a href="/">Home</a></li>
      <li aria-hidden="true">/</li>
      <li><a href="/docs">Docs</a></li>
      <li aria-hidden="true">/</li>
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

      li[aria-hidden] {
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
  {{! Default: renders as <span> }}
  <Separator>/</Separator>

  {{! In lists: renders as <li> }}
  <Separator @as="li">/</Separator>
</template>
```

## Usage Examples

### In Breadcrumbs

When using with Breadcrumb, the yielded `b.Separator` is automatically configured with `@as="li"`:

```gjs live preview
import { Breadcrumb } from "ember-primitives";

<template>
  <Breadcrumb as |b|>
    <li><a href="/">Home</a></li>
    <b.Separator>/</b.Separator>
    <li><a href="/docs">Docs</a></li>
    <b.Separator>/</b.Separator>
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

      nav li[aria-hidden] {
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
      <Separator @as="li">&gt;</Separator>
      <li><a href="/products">Products</a></li>
      <Separator @as="li">→</Separator>
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

      li[aria-hidden] {
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
