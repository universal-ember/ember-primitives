# DOM Context

DOM Context provides a way to share data between components through the DOM hierarchy using `<Provide>` and `<Consume>` components. This enables React-style context patterns in Ember applications with full fine-grained reactivity support, built on top of public APIs for maximum stability.

Unlike event-based context systems, DOM Context follows the DOM tree synchronously, allowing for proper fine-grained reactivity where consumers automatically update when the provided data changes.

## Install

```hbs live
<SetupInstructions @src="dom-context.gts" />
```


Introduced in [0.40.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.40.0-ember-primitives)

## Usage

A `<Consume>` component must be a child of `<Provide>`.

`<Provide>` will instatiate and link up the class with an owner and destroyable linkage so that the class may use services and have proper lifetime.
`<Consume>`'s `@key` should match the constructing object passed to `<Provide>` for free type inference (for typescript users). The `@key` can be a string, but then you have to type the yielded content another way.

<div class="featured-demo">

```gjs live preview
import { Provide, Consume } from 'ember-primitives/dom-context';

class State {
  greeting = 'hello';
  name = 'world';
}

<template>
  <Provide @data={{State}}>
    <Consume @key={{State}} as |context|>
      <p>{{context.data.greeting}}, {{context.data.name}}!</p>
    </Consume>
  </Provide>
</template>
```

</div>


### Reactive Data with Classes

DOM Context correctly interops with reactive data:

<div class="featured-demo">

```gjs live preview
import { Provide, Consume } from 'ember-primitives/dom-context';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

class Counter {
  @tracked count = 0;
  
  increment = () => {
    this.count++;
  }
  
  decrement = () => {
    this.count--;
  }
}

<template>
  <Provide @data={{Counter}}>  
    <Consume @key={{Counter}} as |context|>
      <div class="counter">
        <button {{on "click" context.data.decrement}} class="btn">-</button>
        <span class="count">{{context.data.count}}</span>
        <button {{on "click" context.data.increment}} class="btn">+</button>
      </div>
    </Consume>
    
    <p>Multiple consumers see the same state:</p>
    <Consume @key={{Counter}} as |context|>
      Count is: {{context.data.count}}
    </Consume>
  </Provide>

  <style>
    .counter {
      display: flex;
      align-items: center;
      gap: 1rem;
      margin: 1rem 0;
    }
    .btn {
      background: #3b82f6;
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
      font-size: 1.2rem;
      min-width: 2.5rem;
    }
    .btn:hover {
      background: #2563eb;
    }
    .count {
      font-size: 1.5rem;
      font-weight: bold;
      min-width: 3rem;
      text-align: center;
    }
  </style>
</template>
```

</div>

### Multiple Independent Providers

Different providers with the same key remain completely independent:

```gjs live preview
import { Provide, Consume } from 'ember-primitives/dom-context';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';

class Incrementer {
  @tracked count = 2;
  doit = () => this.count++;
}

class Doubler {
  @tracked count = 2;
  doit = () => this.count *= 2;
}

const StoreConsumer = <template>
  <Consume @key="store" as |context|>
    {{yield context.data}}
  </Consume>
</template>;

<template>
  <div class="demo">
    <div class="provider-group">
      <h4>Incrementer Store</h4>
      <Provide @data={{Incrementer}} @key="store">
        <div class="store-container">
          <StoreConsumer as |store|>
            <div class="store-display">
              Count: {{store.count}}
              <button {{on "click" store.doit}} class="btn">Increment</button>
            </div>
          </StoreConsumer>
        </div>
      </Provide>
    </div>

    <div class="provider-group">
      <h4>Doubler Store</h4>
      <Provide @data={{Doubler}} @key="store">
        <div class="store-container">
          <StoreConsumer as |store|>
            <div class="store-display">
              Count: {{store.count}}
              <button {{on "click" store.doit}} class="btn">Double</button>
            </div>
          </StoreConsumer>
        </div>
      </Provide>
    </div>
  </div>

  <style>
    .demo {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 1rem;
      padding: 1rem;
    }
    .provider-group h4 {
      margin-top: 0;
      color: #374151;
    }
    .store-container {
      padding: 1rem;
      border: 2px solid #10b981;
      border-radius: 8px;
      background: #ecfdf5;
    }
    .store-display {
      display: flex;
      align-items: center;
      justify-content: space-between;
      gap: 1rem;
    }
    .btn {
      background: #10b981;
      color: white;
      border: none;
      padding: 0.5rem 1rem;
      border-radius: 4px;
      cursor: pointer;
    }
    .btn:hover {
      background: #059669;
    }
  </style>
</template>
```

### Functions as Data

You can also provide functions that return data. Functions are called once and cached:

```gjs live preview
import { Provide, Consume } from 'ember-primitives/dom-context';
import { registerDestructor } from '@ember/destroyable';
import { tracked } from '@glimmer/tracking';

function createTimer() {
  return new class Timer {
    @tracked seconds = 0;
    
    constructor() {
      let interval = setInterval(() => {
        this.seconds++;
      }, 1000);

      registerDestructor(this, () => clearInterval(interval));
    }
  }();
}

<template>
  <div class="demo">
    <Provide @data={{createTimer}}>
      <div class="container">
        <h3>Timer Example</h3>
        
        <Consume @key={{createTimer}} as |context|>
          <div class="timer">
            Seconds elapsed: {{context.data.seconds}}
          </div>
        </Consume>
        
        <Consume @key={{createTimer}} as |context|>
          <div class="timer-alt">
            Also showing: {{context.data.seconds}}s
          </div>
        </Consume>
      </div>
    </Provide>
  </div>

  <style>
    .demo { padding: 1rem; }
    .container {
      padding: 1.5rem;
      border: 2px solid #ef4444;
      border-radius: 8px;
      background: #fef2f2;
    }
    .container h3 {
      margin-top: 0;
      color: #dc2626;
    }
    .timer, .timer-alt {
      padding: 0.5rem;
      margin: 0.5rem 0;
      border-radius: 4px;
      font-weight: 500;
    }
    .timer {
      background: #fecaca;
    }
    .timer-alt {
      background: #fed7d7;
    }
  </style>
</template>
```

## API Reference

### `<Provide />`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/dom-context" 
    @name="Provide" />
</template>
```

### `<Consume />`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/dom-context" 
    @name="Consume" />
</template>
```
