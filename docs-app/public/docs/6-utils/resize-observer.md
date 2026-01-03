# ResizeObserver

Utility for managing a singleton [`ResizeObserver`](https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver) for efficient CPU and Memory usage.

Using one `ResizeObserver` (instead of multiple) results in dramatically better performance of your application. [See discussion here](https://github.com/WICG/resize-observer/issues/59#issuecomment-408098151), and direct link to a discussion within the [Chromium Forums](https://groups.google.com/a/chromium.org/g/blink-dev/c/z6ienONUb5A/m/F5-VcUZtBAAJ).


This utility also handles the (uncatchable) ["ResizeObserver loop limit exceeded"](https://stackoverflow.com/questions/49384120/resizeobserver-loop-limit-exceeded) error that can happen when resize event happens too quickly for the _browser_ to handle.

## Install

```hbs live
<SetupInstructions @src="resize-observer.ts" />
```


Introduced in [0.42.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.42.0-ember-primitives)

## Usage


<div class="featured-demo">

```gjs live preview
import { resizeObserver } from 'ember-primitives/resize-observer';

import Component from '@glimmer/component';
import { registerDestructor } from '@ember/destroyable';

export default class Demo extends Component {
  #resizeObserver = resizeObserver(this);
  element = document.createElement('div');

  constructor(owner, args) {
    super(owner, args);

    this.#resizeObserver.observe(this.element, this.handleResize);
    registerDestructor(this, () => {
      this.#resizeObserver.unobserve(this.element, this.handleResize);
    });
  }

  handleResize = (entry) => {
    const { width, height } = entry.contentRect;
    this.element.textContent = `( ${width} x ${height} )`;
  }

  
  <template>
    {{this.element}}

    <style>
      @scope {
        div {
          border: 2px black dashed;
          resize: both;
          overflow: auto;
          padding: 0.5rem;
        }
      }
    </style>
  </template>
}
```

</div>



## API Reference

```gjs live no-shadow
import { APIDocs } from 'kolay';

<template>
  <APIDocs 
    @package="ember-primitives" 
    @module="declarations/resize-observer" 
    @name="resizeObserver" />
</template>
```


## Reference

- originally from [ember-resize-observer-service](https://github.com/PrecisionNutrition/ember-resize-kitchen-sink/tree/main/packages/ember-resize-observer-service)
