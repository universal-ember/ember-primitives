# InViewport

A component that defers rendering its content until the element is visible or near the viewport.

This is useful for optimizing performance by not rendering expensive components until they're actually needed. Each demo on this site renders off-canvas, which can sometimes cause problems if the DOM is queried during render.

## Setup

```bash
pnpm add ember-primitives
```

## Usage

You'll need to inspect-element to see that the component is not rendered when scrolled off screen.

<div class="featured-demo">

```gjs live preview
import { InViewport } from 'ember-primitives/viewport';

<template>
  <div style="height: 160px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 800px;">
      <p style="height: 180px">Scroll down to see the InViewport component render</p>
      
      <InViewport @mode="contain">
        <div style="background: black; padding: 2rem;">
          This content is rendered only when near the viewport!
        </div>
      </InViewport>

      <div style="height: 400px;"></div>
    </div>
  </div>
</template>
```

</div>

## Modes

### Contain Mode (Default)

In `contain` mode, the placeholder element wraps the yielded content once rendered. The element remains in the DOM structure.

<div class="featured-demo">

```gjs live preview
import { InViewport } from 'ember-primitives/viewport';

<template>
  <div style="height: 170px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 600px;">
      <p style="height:180px">Scroll down</p>

      <InViewport @mode="contain">
        <div style="background: black; padding: 1rem;">
          Content in contain mode
        </div>
      </InViewport>
    </div>
  </div>
</template>
```

</div>

### Replace Mode

In `replace` mode, the placeholder element is replaced entirely by the yielded content once rendered.

<div class="featured-demo">

```gjs live preview
import { InViewport } from 'ember-primitives/viewport';

<template>
  <div style="height: 170px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 600px;">
      <p style="height:180px">Scroll down</p>

      <InViewport @mode="replace">
        <div style="background: black; padding: 1rem;">
          This replaces the placeholder
        </div>
      </InViewport>
    </div>
  </div>
</template>
```

</div>

## Custom Tag Name

You can specify a custom tag name for the placeholder element:

```gjs live preview
import { InViewport } from 'ember-primitives/viewport';

<template>
  <InViewport @tagName="section">
    <div style="background: lightblue; padding: 1rem;">
      Content wrapped in a section element
    </div>
  </InViewport>
</template>
```

## How It Works

The `InViewport` component uses the [Intersection Observer API](https://developer.mozilla.org/en-US/docs/Web/API/Intersection_Observer_API) to detect when an element is near the viewport.

1. A placeholder element is rendered initially
2. An IntersectionObserver watches the element
3. When the element enters the viewport (or the configured rootMargin area), the content is rendered
4. The observer is destroyed - this is a one-time optimization
5. The content remains rendered even if scrolled out of view

This approach is ideal for:
- Pages with many heavy components
- Off-canvas renders that may query the DOM
- Implementing "virtual scrolling" patterns
- Progressive enhancement strategies

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/viewport" 
    @name="InViewportSignature" />
</template>
```
