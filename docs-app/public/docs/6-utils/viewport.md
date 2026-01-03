# Viewport

Utility for managing a singleton [`IntersectionObserver`](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver) for efficient CPU and Memory usage when detecting element visibility in the viewport.

Using one `IntersectionObserver` (instead of multiple) results in dramatically better performance of your application, especially when observing many elements.

## Install

```hbs live
<SetupInstructions @src="viewport/viewport.ts" />
```


Introduced in [0.49.0](https://github.com/universal-ember/ember-primitives/releases)

## Usage

You'll need to inspect-element to see that the text is changing when leaving view.


<div class="featured-demo">

```gjs live preview
import { viewport } from 'ember-primitives/viewport';

import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { modifier } from 'ember-modifier';

export default class Demo extends Component {
  @tracked isVisible = false;
  @tracked intersectionRatio = 0;

  get #viewport() {
    return viewport(this);
  }

  observeIntersection = modifier((element) => {
    this.#viewport.observe(element, this.handleIntersection);

    return () => this.#viewport.unobserve(element, this.handleIntersection);
  });

  handleIntersection = (entry) => {
    this.isVisible = entry.isIntersecting;
    this.intersectionRatio = entry.intersectionRatio;
  }

  <template>
    <div class="scroll-container" tabindex="0">
      <div class="spacer">Scroll down to see the element enter the viewport</div>
      
      <div {{this.observeIntersection}} class="observed-element">
        {{#if this.isVisible}}
          ✓ Element is visible in viewport ({{this.intersectionRatio}})
        {{else}}
          ✗ Element is not visible
        {{/if}}
      </div>
      
      <div class="spacer">Scroll up to see it leave</div>
    </div>

    <style>
      @scope {
        .scroll-container {
          height: 160px;
          overflow-y: scroll;
          border: 2px dashed black;
          padding: 2rem;
        }
        
        .spacer {
          height: 180px;
          display: flex;
          align-items: center;
          justify-content: center;
        }
        
        .observed-element {
          padding: 1rem;
          background: linear-gradient(135deg, #66aeea 0%, #862ba2 100%);
          color: white;
          border-radius: 8px;
          text-align: center;
          font-weight: bold;
          display: flex;
          align-items: center;
          justify-content: center;
        }
      }
    </style>
  </template>
}
```

</div>

## Advanced Usage

You can provide options to configure the intersection observer:

```gjs
import { viewport } from 'ember-primitives/viewport';
import Component from '@glimmer/component';
import { modifier } from 'ember-modifier';

export default class Demo extends Component {
  get #viewport() {
    return viewport(this);
  }

  observeIntersection = modifier((element) => {
    // Observe with custom options
    this.#viewport.observe(element, this.handleIntersection, {
      // Trigger 100px before entering viewport
      rootMargin: '100px',
      // Trigger at 0%, 50%, and 100% visibility
      threshold: [0, 0.5, 1.0]
    });

    return () => this.#viewport.unobserve(element, this.handleIntersection);
  });

  handleIntersection = (entry) => {
    console.log('Intersection ratio:', entry.intersectionRatio);
    console.log('Is intersecting:', entry.isIntersecting);
  }

  <template>
    <div {{this.observeIntersection}}>
      Observed content
    </div>
  </template>
}
```

## API Reference

```gjs live no-shadow
import { APIDocs } from 'kolay';

<template>
  <APIDocs 
    @package="ember-primitives" 
    @module="declarations/viewport/viewport" 
    @name="viewport" />
</template>
```

## See Also

- [`InViewport`](/6-utils/in-viewport) - A component built on top of this utility for declarative viewport-based rendering
- [ResizeObserver](/6-utils/resize-observer) - Similar pattern for observing element size changes
