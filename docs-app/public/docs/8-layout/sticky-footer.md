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

## Example: perma sticky / revealing footer

In this example, there is an extra footer at the bottom, and we want the sticky footer to always show above that, but then reveal more information when we scroll to the bottom

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
  <div class="fake-window2">
    <StickyFooter class="container">
      <:content>
        <button {{on 'click' addContent}}>Add Content</button>
        <button {{on 'click' removeContent}}>Remove Content</button>
        <br>

        {{#each content as |paragraph|}}
          {{paragraph}}
        {{/each}}
      </:content>
      <:footer>
        <footer class="sticky-footer">
          This is the footer
          <br><br>
          some information can be hidden until scrolled to.
        </footer>
      </:footer>
    </StickyFooter>

    <footer class="site-footer">
      site-wide footer
    </footer>
  </div>
  <style>
    /* styles that demonstrate the UX */
    .container {
      max-height: 200px;
      overflow: auto;
      position: relative;
      padding-bottom: 60px;
    }
    .ember-primitives__sticky-footer__footer {
      position: sticky;
      bottom: -38px;
    }
    footer.sticky-footer, footer.site-footer { border: 1px solid; background: white; }
    footer.site-footer { height: 38px; position: absolute; bottom: 0; left: 0; right: 0; }
    .fake-window2 {
      padding-bottom: 38px;
      min-height: 150px;
      max-height: 200px;
      position: relative;
      border: 1px solid;
      padding: 1rem;
      overflow: hidden;
    }
  </style>
</template>
```

</div>

## Features

* Footer sticks to the bottom of the window when there is less than a screen's worth of content
* Footer sits below the content when there is enough content to overflow the containing element / body

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

There are 3 BEM-style classes on the elements to enable further customization or styling.
```css
/* 
  the containing element of both <:content> and <:footer> 
  this is not the same element that `...attributes` is on.
*/ 
.ember-primitives__sticky-footer__container
  /* for the <:content> block's containing element */ 
  .ember-primitives__sticky-footer__content
  /* for the <:footer> block's containing element */ 
  .ember-primitives__sticky-footer__footer
```

## Accessibility

This component provides no accessibility patterns and using `<main>` / `<footer>` or not is up to the use case of the `<StickyFooter />` component.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/layout/sticky-footer" 
    @name="StickyFooter" 
  />
</template>
```

### State Attributes

This component has no state.
