# Sticky Footer

A common UI pattern is to have a footer area at the bottom of the page that always sticks to the bottom of the window, regardless of how little content there is on the page, yet allows scrolling and being pushed out of frame when there is a lot of content, as the footer is not "main" content on the page, but typically more "reference" material, or serving a navigation purpose.

This component implements a CSS/markup-only pattern for the above-described layout-pattern.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { StickyFooter } from 'ember-primitives';
import { on } from '@ember/modifier';
import { TrackedArray } from 'tracked-built-ins';
import { loremIpsum } from 'lorem-ipsum';

const content = new TrackedArray();
const addContent = () => content.push(loremIpsum({ count: 1, units: 'paragraph' }));
const removeContent = () => content.splice(-1);

<template>
  <div class="fake-window">
    <StickyFooter>
      <:content>
        <button {{on 'click' addContent}}>Add Content</button>
        <button {{on 'click' removeContent}}>Remove Content</button>
        <br>

        {{#each content as |paragraph|}}
          {{paragraph}}
        {{/each}}
      </:content>
      <:footer>
        <footer>
          This is the footer
        </footer>
      </:footer>
    </StickyFooter>
  </div>
  <style>
    /* styles for demo, not required */
    footer { border: 1px solid; }
    .fake-window {
      height: 200px;
      border: 1px solid;
      overflow: auto;
      padding: 1rem;
    }
  </style>
</template>
```

</div>

## Features

* Footer sticks to the bottom of the window when there is less than a screen's worth of content
* Footer sits below the content when there is enough content to overflow the containing element / body

## Installation

```bash
pnpm add ember-primitives
```

## Anatomy

```js 
import { StickyFooter } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { StickyFooter } from 'ember-primitives/layout/sticky-footer';
```

```gjs 
import { StickyFooter } from 'ember-primitives';

<template>
  <StickyFooter>
    <:content>
      content here
    </:content>
    <:footer>
      footer content here
    </:footer>
  </StickyFooter>
</template>
```

## Accessibility

This component provides no accessibility patterns and using `<main>` / `<footer>` or not is up to the use case of the `<StickyFooter />` component.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="StickyFooter" />
</template>
```

### State Attributes

This component has no state.
