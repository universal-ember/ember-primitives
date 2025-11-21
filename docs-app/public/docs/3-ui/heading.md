# Heading

The `<Heading>` component correlates to the `<h1>` through `<h6>` [Section Heading][mdn-h] elements, where the **level** is determined _automatically_ based on how the DOM has rendered.

This enables distributed teams to correctly produce appropriate section heading levels without knowledge of where their work will be rendered in the overall document -- and extra helpful for design systems teams where is _is not possible_ to know the appropriate heading level ahead of time.

[mdn-h]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/Heading_Elements

<section>

## Usage

In your app (and in this demo), you'll use `<section>` elements to denote when the [_Section Heading_][mdn-h] element should change its level.
Note that this demo starts with `h3`, because this docs page already has an `h1`, and _this_ section (Usage) uses an `h2`.

<div class="featured-demo auto-height">

```gjs live preview 
import { Heading } from 'ember-primitives/components/heading';
  
<template>
  <Heading>a heading</Heading>
  <Heading>a heading</Heading>

  <section>
    <Heading>a heading</Heading>
    <Heading>a heading</Heading>
    <section>
      <Heading>a heading</Heading>
      <section>
        <Heading>a heading</Heading>
        <Heading>a heading</Heading>
      </section>
      <Heading>a heading</Heading>
    </section>
  </section>

  <style>
    h3, h4, h5, h6 { margin: 0; }

    h3::before, h4::before, h5::before, h6::before {
      position: absolute;
      margin-left: -1.2em;
      font-size: 0.7em;
      text-align: right;
      opacity: 0.8;
    }

    h3 { font-size: 2rem; }
    h4 { font-size: 1.5rem; }
    h5 { font-size: 1.25rem; }
    h6 { font-size: 1rem; }

    h3::before { content: 'h3'; }
    h4::before { content: 'h4'; }
    h5::before { content: 'h5'; }
    h6::before { content: 'h6'; }
  </style>
</template>
```

</div>
</section>

## Setup

```bash 
pnpm add ember-primitives
```

Introduced in [0.44.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.44.0-ember-primitives)

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/heading" 
    @name="Heading" />
</template>
```
