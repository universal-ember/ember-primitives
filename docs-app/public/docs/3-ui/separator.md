# Separator

A component for rendering both **semantic** separators and **decorative** separators.

The `Separator` is **80% documentation and 20% boilerplate reduction**.

- By default it renders a semantic separator (`<hr>`) that is exposed to assistive technology.
- For purely visual glyph separators (like `/` in breadcrumbs), use `@decorative={{true}}` to apply `aria-hidden="true"`.

<div class="featured-demo">

```gjs live preview
import { Separator } from "ember-primitives";

<template>
  <nav>
    <ol class="breadcrumb-list">
      <li><a href="/">Home</a></li>
      <Separator @as="li" @decorative={{true}}>/</Separator>
      <li><a href="/docs">Docs</a></li>
      <Separator @as="li" @decorative={{true}}>/</Separator>
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
- Renders a semantic separator (`<hr>`) by default
- Provides an explicit `@decorative` mode for purely visual separators (adds `aria-hidden="true"`)
- Provides a consistent pattern across your codebase
- Allows customizing the element tag via the `@as` argument

This `Separator` is intended for **non-interactive** use-cases (semantic `<hr>` and decorative glyph separators). It does **not** implement focus/drag/keyboard behaviors for splitter-style UI.

## The `@as` Argument

By default, the Separator renders as an `<hr>` element.

When you are using `@decorative={{true}}` (for glyph separators like `/`), you typically want a non-void element so you can provide visible content. In lists, use `@as="li"` so separators are siblings to `<li>` elements:

```gjs
<ol>
  <li>Item 1</li>
  <Separator @as="li" @decorative={{true}}>/</Separator>
  <li>Item 2</li>
</ol>
```

This is important because in HTML, `<ol>` and `<ul>` elements should only have `<li>` children. Using `<span>` elements as siblings to `<li>` elements is invalid HTML.

## Plain HTML Alternative

**Using plain HTML is just as easy!**

- For a semantic separator, use `<hr>`.
- For a decorative glyph separator in breadcrumbs, use an element with `aria-hidden="true"`.

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
  {{! Default: semantic separator (renders as <hr>) }}
  <Separator />

  {{! Decorative glyph separator (renders as <span aria-hidden="true">) }}
  <Separator @as="span" @decorative={{true}}>/</Separator>

  {{! Decorative glyph separator in lists (renders as <li aria-hidden="true">) }}
  <Separator @as="li" @decorative={{true}}>/</Separator>
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
      <Separator @as="li" @decorative={{true}}>&gt;</Separator>
      <li><a href="/products">Products</a></li>
      <Separator @as="li" @decorative={{true}}>→</Separator>
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

When used as a semantic separator (`<Separator />`), the separator is exposed to assistive technology.

When used as a decorative glyph separator (`@decorative={{true}}`), the component adds `aria-hidden="true"` so screen reader users don't hear unnecessary characters like "/" or ">".

### Best Practices

- Use `<Separator />` (semantic) when the separation itself is meaningful structure.
- Use `@decorative={{true}}` only for visual separators.
- When decorative, the content is hidden from screen readers, so don't use it for meaningful content.
- Ensure sufficient color contrast between separators and background.
