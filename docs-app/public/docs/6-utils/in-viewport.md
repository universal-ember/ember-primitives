# InViewport

A component that defers rendering its content until the element is visible or near the viewport.

This is useful for optimizing performance by not rendering expensive components until they're actually needed. Each demo on this site renders off-canvas, which can sometimes cause problems if the DOM is queried during render.

## Setup

```bash
pnpm add ember-primitives
```

## Usage

```gjs live preview
import { InViewport } from 'ember-primitives';

<template>
  <div style="height: 300px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 800px;">
      <p>Scroll down to see the InViewport component render</p>
      
      <InViewport class="placeholder" @mode="contain">
        <div style="background: lightblue; padding: 2rem; border: 2px solid blue; margin: 2rem 0;">
          This content is rendered only when near the viewport!
        </div>
      </InViewport>

      <div style="height: 400px;"></div>
    </div>
  </div>
</template>
```

## Modes

### Contain Mode (Default)

In `contain` mode, the placeholder element wraps the yielded content once rendered. The element remains in the DOM structure.

```gjs live preview
import { InViewport } from 'ember-primitives';

<template>
  <div style="height: 300px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 600px;">
      <p>Scroll down</p>

      <InViewport @mode="contain" class="my-container" style="background: lightgray;">
        <div style="background: lightblue; padding: 1rem;">
          Content in contain mode
        </div>
      </InViewport>
    </div>
  </div>
</template>
```

### Replace Mode

In `replace` mode, the placeholder element is replaced entirely by the yielded content once rendered.

```gjs live preview
import { InViewport } from 'ember-primitives';

<template>
  <div style="height: 300px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 600px;">
      <p>Scroll down</p>

      <InViewport @mode="replace" class="placeholder">
        <div style="background: lightblue; padding: 1rem;">
          This replaces the placeholder
        </div>
      </InViewport>
    </div>
  </div>
</template>
```

## Custom Tag Name

You can specify a custom tag name for the placeholder element:

```gjs live preview
import { InViewport } from 'ember-primitives';

<template>
  <InViewport @tagName="section" class="my-section">
    <div style="background: lightblue; padding: 1rem;">
      Content wrapped in a section element
    </div>
  </InViewport>
</template>
```

## Custom Intersection Options

Control when the component is considered "in viewport" using `@intersectionOptions`:

```gjs live preview
import { InViewport } from 'ember-primitives';

<template>
  <div style="height: 300px; overflow: auto; border: 1px solid gray; padding: 1rem;">
    <div style="height: 800px;">
      <p>Scroll down to trigger at different scroll position</p>

      {{! Renders when 200px away from viewport edge }}
      <InViewport @intersectionOptions={{hash rootMargin="200px"}}>
        <div style="background: lightblue; padding: 1rem; margin: 2rem 0;">
          Rendered 200px before entering viewport
        </div>
      </InViewport>

      <div style="height: 400px;"></div>
    </div>
  </div>
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
    @module="declarations/components/in-viewport" 
    @name="InViewportSignature" />
</template>
```
