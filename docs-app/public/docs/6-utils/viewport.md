# Viewport

Utility for managing a singleton [`IntersectionObserver`](https://developer.mozilla.org/en-US/docs/Web/API/IntersectionObserver) for efficient CPU and Memory usage when detecting element visibility in the viewport.

Using one `IntersectionObserver` (instead of multiple) results in dramatically better performance of your application, especially when observing many elements.

## Setup

```bash 
pnpm add ember-primitives
```

Introduced in [0.49.0](https://github.com/universal-ember/ember-primitives/releases)

## Usage


<div class="featured-demo">

```gjs live preview
import { viewport } from 'ember-primitives/viewport';

import Component from '@glimmer/component';
import { registerDestructor } from '@ember/destroyable';
import { tracked } from '@glimmer/tracking';

export default class Demo extends Component {
  @tracked isVisible = false;
  @tracked intersectionRatio = 0;

  #viewport = viewport(this);
  element = null;

  constructor(owner, args) {
    super(owner, args);

    registerDestructor(this, () => {
      if (this.element) {
        this.#viewport.unobserve(this.element, this.handleIntersection);
      }
    });
  }

  setupElement = (element) => {
    this.element = element;
    this.#viewport.observe(element, this.handleIntersection);
  };

  handleIntersection = (entry) => {
    this.isVisible = entry.isIntersecting;
    this.intersectionRatio = entry.intersectionRatio;
  }

  <template>
    <div class="scroll-container">
      <div class="spacer">Scroll down to see the element enter the viewport</div>
      
      <div {{this.setupElement}} class="observed-element">
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
          height: 300px;
          overflow-y: scroll;
          border: 2px dashed #666;
          padding: 1rem;
        }
        
        .spacer {
          height: 400px;
          display: flex;
          align-items: center;
          justify-content: center;
          color: #666;
        }
        
        .observed-element {
          padding: 2rem;
          background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
          color: white;
          border-radius: 8px;
          text-align: center;
          font-weight: bold;
          min-height: 100px;
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
import { registerDestructor } from '@ember/destroyable';

export default class Demo extends Component {
  #viewport = viewport(this);

  constructor(owner, args) {
    super(owner, args);

    registerDestructor(this, () => {
      if (this.element) {
        this.#viewport.unobserve(this.element, this.handleIntersection);
      }
    });
  }

  setupElement = (element) => {
    this.element = element;
    
    // Observe with custom options
    this.#viewport.observe(element, this.handleIntersection, {
      // Trigger 100px before entering viewport
      rootMargin: '100px',
      // Trigger at 0%, 50%, and 100% visibility
      threshold: [0, 0.5, 1.0]
    });
  };

  handleIntersection = (entry) => {
    console.log('Intersection ratio:', entry.intersectionRatio);
    console.log('Is intersecting:', entry.isIntersecting);
  }

  <template>
    <div {{this.setupElement}}>
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
    @module="declarations/viewport" 
    @name="viewport" />
</template>
```

## See Also

- [`InViewport`](/in-viewport) - A component built on top of this utility for declarative viewport-based rendering
- [ResizeObserver](/resize-observer) - Similar pattern for observing element size changes
