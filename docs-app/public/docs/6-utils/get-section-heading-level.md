# Heading Level 📦

Used by the [`<Heading>`](/3-ui/heading.md) component, and available for use in all frameworks (React, Svelte, Ember, etc). `getSectionHeadingLevel` is the primary function exported by this utility library and correctly determines which of the `<h1>` through `<h6>` [Section Heading][mdn-h] elements to use, where the **level** is determined _automatically_ based on how the DOM has rendered.

This enables distributed teams to correctly produce appropriate section heading levels without knowledge of where their work will be rendered in the overall document -- and extra helpful for design systems teams where is _is not possible_ to know the appropriate heading level ahead of time.

[mdn-h]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/Heading_Elements

## Install

```bash
pnpm add which-heading-do-i-need
```

## Usage

In your app, you can use any of `<section>`, `<article>`, and `<aside>` elements to denote when the [_Section Heading_][mdn-h] element should change its level.
Note that this demo starts with `h3`, because this docs page already has an `h1`, and _this_ section (Usage) uses an `h2`.

In this example, we dynamically create a TextNode and Element, where, since the TextNode is rendered first, the Element can traverse from the TextNode up the existing DOM to determine which h-level to use. We expect an `h3` and `h4` in the demo, since this is the `Usage` section, which has a section heading of `h2`.

<section class="featured-demo">

```gjs live
import Component from "@glimmer/component";
import { element } from "ember-element-helper";
import { getSectionHeadingLevel } from "which-heading-do-i-need";

class Heading extends Component {
  markerNode = document.createTextNode("");

  get hLevel() {
    return `h${getSectionHeadingLevel(this.markerNode)}`;
  }

  <template>
    {{this.markerNode}}

    {{#let (element this.hLevel) as |El|}}
      <El ...attributes>
        {{yield}}
      </El>
    {{/let}}
  </template>
}

// Output for demo uses the above
<template>
  <Heading>hello there</Heading>

  <section>
    <Heading>hello there</Heading>

  </section>

  <style>
    h1, h2, h3, h4, h5, h6 { margin: 0; }

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

  </style>
</template>
```

</section>

<br>
<details><summary>using Ember</summary>

This version:
  - caller can pass attributes to the generated heading
  - only element generated is the heading
  - synchronous, so there are no extra renders

```gjs
import Component from "@glimmer/component";
import { getSectionHeadingLevel } from "which-heading-do-i-need";

class Heading extends Component {
  markerNode = document.createTextNode("");

  get hLevel() {
    return `h${getSectionHeadingLevel(this.markerNode)}`;
  }

  <template>
    {{this.markerNode}}

    {{#let (element this.hLevel) as |El|}}
      <El ...attributes>{{yield}}</El>
    {{/let}}
  </template>
}
```

</details>
<details><summary>using Svelte</summary>

  downside to this approach is that it requires two renders.
  first time is a span, second the span is replaced with the heading.

  See [Feature: Bind to text nodes with `svelte:text`](https://github.com/sveltejs/svelte/issues/7424) on svelte's GitHub.

```svelte
<script>
	import { getSectionHeadingLevel } from "which-heading-do-i-need";

	let { children } = $props();

	let ref = $state();
	const hLevel = $derived(ref ? `h${getSectionHeadingLevel(ref)}` : 'span');
</script>

<svelte:element this={hLevel} bind:this={ref}>
	{@render children?.()}
</svelte:element>
```

</details>

## API Reference

```gjs live no-shadow
import { APIDocs } from 'kolay';

<template>
  <APIDocs @package="which-heading-do-i-need" @module="declarations/index" @name="getSectionHeadingLevel" />
</template>
```
