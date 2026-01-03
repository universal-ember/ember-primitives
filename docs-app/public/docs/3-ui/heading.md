# Heading

The `<Heading>` component correlates to the `<h1>` through `<h6>` [Section Heading][mdn-h] elements, where the **level** is determined _automatically_ based on how the DOM has rendered.

This enables distributed teams to correctly produce appropriate section heading levels without knowledge of where their work will be rendered in the overall document -- and extra helpful for design systems teams where is _is not possible_ to know the appropriate heading level ahead of time.

[mdn-h]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/Heading_Elements

<section>

## Usage

In your app, you can use any of `<section>`, `<article>`, and `<aside>` elements to denote when the [_Section Heading_][mdn-h] element should change its level.
Note that this demo starts with `h3`, because this docs page already has an `h1`, and _this_ section (Usage) uses an `h2`.

<div class="featured-demo auto-height">

```gjs live preview 
import { Heading } from 'ember-primitives/components/heading';
import { InViewport } from 'ember-primitives/viewport';
  
<template>
  <InViewport style="min-height:300px;">
  <main aria-label="heading-demo" class="not-prose">
    <Heading>a heading</Heading>

    <nav>
      <Heading>a heading</Heading>
    </nav>

    <article>
      <Heading>a heading</Heading>
      <a href="#">
        <Heading>a heading</Heading>
      </a>
      <section>
        <Heading>a heading</Heading>
        <article>
          <Heading>a heading</Heading>
        </article>
      </section>
      <footer>
        <Heading>a heading</Heading>

      </footer>
    </article>
  </main>
  </InViewport>

  <style>
    @scope {
      h1, h2, h3, h4, h5, h6 { 
        margin-top: 0; margin-bottom: 0;
        color: white;
      }

      h1::before, h2::before, h3::before, h4::before, h5::before, h6::before {
        position: absolute;
        margin-left: -1.2em;
        font-size: 0.7em;
        text-align: right;
        opacity: 0.8;
      }

      h1 { font-size: 2.5rem; }
      h2 { font-size: 2.25rem; }
      h3 { font-size: 2rem; }
      h4 { font-size: 1.5rem; }
      h5 { font-size: 1.25rem; }
      h6 { font-size: 1rem; }
      a { color: white; }

      h1::before { content: 'h1'; }
      h2::before { content: 'h2'; }
      h3::before { content: 'h3'; }
      h4::before { content: 'h4'; }
      h5::before { content: 'h5'; }
      h6::before { content: 'h6'; }

      article, section, aside, nav, main, footer {
        border: 1px dotted;
        padding: 0.25rem 1.5rem;
        padding-left: 2rem;
        padding-right: 0.5rem;
        position: relative;

        &::before {
          position: absolute;
          right: 0.5rem;
          top: -1rem;
          font-size: 0.7rem;
          text-align: right;
          opacity: 0.8;
        }
      }

      section, article {
        display: flex;
        flex-direction: column;
        gap: 0.75rem;
      }

      article::before { content: '<article>'; }
      section::before { content: '<section>'; }
      aside::before { content: '<aside>'; }
      nav::before { content: '<nav>'; }
      main::before { content: '<main>'; }
      footer::before { content: '<footer>'; }

      main {
        display: grid;
        gap: 2.5rem;
        grid-template-columns: max-content 1fr;
        grid-template-areas:
          "heading heading"
          "nav content"
          "nav content"
          "nav content";

      }

      >:first-child { grid-area: heading; }
      nav { grid-area: nav; }
      article { grid-area: content; }
    }
  </style>
</template>
```

</div>
</section>

## Setup

```hbs live
<SetupInstructions @src="components/heading.gts" />
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
