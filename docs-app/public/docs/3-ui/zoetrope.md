# Zoetrope

A slider style element built using browser native scrolling to create netflix style carousels.

<div class="hidden">
```gjs live preview
<!-- demo styles -->
<template>
  <style>
    .featured-demo h2 { margin: 0; } .featured-demo .glimdown-render { padding-left: 0; padding-right: 0; }
    .card { background: red; color: #fff; height: 150px; padding: 24px; text-shadow: 1px 1px 1px rgba(0, 0, 0, 0.5); width: 200px; }
    .card:nth-child(1n) { background: blue; } .card:nth-child(2n) { background: green; }
    .card:nth-child(3n) { background: yellow; } .card:nth-child(4n) { background: purple; }
    .card:nth-child(5n) { background: orange; } .card:nth-child(6n) { background: pink; }
    .card:nth-child(7n) { background: brown; } .card:nth-child(8n) { background: black; }
    .card:nth-child(9n) { background: mediumaquamarine; } .card:nth-child(10n) { background: gray; }
  </style>
</template>
```
</div>

<div data-tabster='{"uncontrolled": {}}'>
<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Zoetrope } from "ember-primitives";

<template>
  <Zoetrope @gap={{8}} @offset={{40}}>
    <:header>
      <h2>Heading</h2>
    </:header>

    <:content>
      <a href="#" class="card">1</a>
      <a href="#" class="card">2</a>
      <a href="#" class="card">3</a>
      <a href="#" class="card">4</a>
      <a href="#" class="card">5</a>
      <a href="#" class="card">6</a>
      <a href="#" class="card">7</a>
      <a href="#" class="card">8</a>
      <a href="#" class="card">9</a>
      <a href="#" class="card">10</a>
      <a href="#" class="card">11</a>
      <a href="#" class="card">12</a>
      <a href="#" class="card">13</a>
      <a href="#" class="card">14</a>
      <a href="#" class="card">15</a>
      <a href="#" class="card">16</a>
      <a href="#" class="card">17</a>
      <a href="#" class="card">18</a>
      <a href="#" class="card">19</a>
      <a href="#" class="card">20</a>
      <a href="#" class="card">21</a>
      <a href="#" class="card">22</a>
      <a href="#" class="card">23</a>
      <a href="#" class="card">24</a>
      <a href="#" class="card">25</a>
      <a href="#" class="card">26</a>
      <a href="#" class="card">27</a>
      <a href="#" class="card">28</a>
      <a href="#" class="card">29</a>
      <a href="#" class="card">30</a>
      <a href="#" class="card">31</a>
      <a href="#" class="card">32</a>
      <a href="#" class="card">33</a>
      <a href="#" class="card">34</a>
      <a href="#" class="card">35</a>
      <a href="#" class="card">36</a>
      <a href="#" class="card">37</a>
      <a href="#" class="card">38</a>
      <a href="#" class="card">39</a>
      <a href="#" class="card">40</a>
      <a href="#" class="card">41</a>
      <a href="#" class="card">42</a>
      <a href="#" class="card">43</a>
      <a href="#" class="card">44</a>
      <a href="#" class="card">45</a>
      <a href="#" class="card">46</a>
      <a href="#" class="card">47</a>
      <a href="#" class="card">48</a>
      <a href="#" class="card">49</a>
      <a href="#" class="card">50</a>
      <a href="#" class="card">51</a>
      <a href="#" class="card">52</a>
      <a href="#" class="card">53</a>
      <a href="#" class="card">54</a>
      <a href="#" class="card">55</a>
      <a href="#" class="card">56</a>
      <a href="#" class="card">57</a>
      <a href="#" class="card">58</a>
      <a href="#" class="card">59</a>
      <a href="#" class="card">60</a>
    </:content>
  </Zoetrope>

  <style>
    /* some basic button styles */ .ember-primitives__zoetrope__controls button { background: #fff;
    padding: 0.5rem; border-radius: 0.25rem; color: #333; } .ember-primitives__zoetrope__controls
    button:disabled { opacity: 0.5; }
  </style>
</template>
```

</div>

## Features

- Automatic page size detection.
- Provide your own custom control buttons.
- CSS variables to control gap and offset.
- Keyboard navigation.

## Custom Controls

You can pass your own control buttons to the zoetrope component. Use the `.ember-primitives__zoetrope__controls` class to place them in the default position, or style them as you wish.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Zoetrope } from "ember-primitives";
import { on } from "@ember/modifier";

<template>
  <Zoetrope @gap={{8}} @offset={{40}}>
    <:header>
      <h2>Default Placement</h2>
    </:header>

    <:controls as |z|>
      <div class="ember-primitives__zoetrope__controls">
        <button
          type="button"
          {{on "click" z.scrollLeft}}
          disabled={{z.cannotScrollLeft}}
        >&lt;</button>

        <button
          type="button"
          {{on "click" z.scrollRight}}
          disabled={{z.cannotScrollRight}}
        >&gt;</button>
      </div>
    </:controls>

    <:content>
      <a href="#" class="card">1</a>
      <a href="#" class="card">2</a>
      <a href="#" class="card">3</a>
      <a href="#" class="card">4</a>
      <a href="#" class="card">5</a>
      <a href="#" class="card">6</a>
      <a href="#" class="card">7</a>
      <a href="#" class="card">8</a>
      <a href="#" class="card">9</a>
      <a href="#" class="card">10</a>
      <a href="#" class="card">11</a>
      <a href="#" class="card">12</a>
    </:content>
  </Zoetrope>
</template>
```

```gjs live preview no-shadow
import { Zoetrope } from "ember-primitives";
import { on } from "@ember/modifier";

<template>
  <Zoetrope @gap={{8}} @offset={{40}}>
    <:header>
      <h2>Custom Placement</h2>
    </:header>

    <:controls as |z|>
      <div class="my-controls">
        <button
          type="button"
          {{on "click" z.scrollLeft}}
          disabled={{z.cannotScrollLeft}}
        >&lt;</button>

        <button
          type="button"
          {{on "click" z.scrollRight}}
          disabled={{z.cannotScrollRight}}
        >&gt;</button>
      </div>
    </:controls>

    <:content>
      <a href="#" class="card">1</a>
      <a href="#" class="card">2</a>
      <a href="#" class="card">3</a>
      <a href="#" class="card">4</a>
      <a href="#" class="card">5</a>
      <a href="#" class="card">6</a>
      <a href="#" class="card">7</a>
      <a href="#" class="card">8</a>
      <a href="#" class="card">9</a>
      <a href="#" class="card">10</a>
      <a href="#" class="card">11</a>
      <a href="#" class="card">12</a>
    </:content>
  </Zoetrope>

  <style>
    .my-controls { display: flex; position: absolute; top: 50%; transform: translateY(-50%); height:
    40%; width: 100%; padding-top: 2rem; pointer-events: none; } .my-controls button { height: 100%;
    width: var(--zoetrope-offset); background: rgb(0 0 0 / 50%); pointer-events: auto; }
    .my-controls button:nth-child(2) { margin-left: auto; } .my-controls button:disabled {
    visibility: hidden; }

  </style>
</template>
```

</div>

## Scroll Behavior

The component takes a `@scrollBehavior` argument that can be used to control the scroll behavior. The default value is `smooth`.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Zoetrope } from "ember-primitives";

<template>
  <Zoetrope @gap={{8}} @offset={{40}} @scrollBehavior="instant">
    <:header>
      <h2>Instant Scroll</h2>
    </:header>

    <:content>
      <a href="#" class="card">1</a>
      <a href="#" class="card">2</a>
      <a href="#" class="card">3</a>
      <a href="#" class="card">4</a>
      <a href="#" class="card">5</a>
      <a href="#" class="card">6</a>
      <a href="#" class="card">7</a>
      <a href="#" class="card">8</a>
      <a href="#" class="card">9</a>
      <a href="#" class="card">10</a>
      <a href="#" class="card">11</a>
      <a href="#" class="card">12</a>
    </:content>

  </Zoetrope>
</template>
```

</div>

## Anatomy

```js
import { Zoetrope } from "ember-primitives";
```

or for non-tree-shaking environments:

```js
import { Zoetrope } from "ember-primitives/components/zoetrope";
```

```gjs
import { Zoetrope } from "ember-primitives";

<template>
  <Zoetrope @gap={{8}} @offset={{40}}>
    <:header>
      <h2>Heading</h2>
    </:header>

    <:content>
      <a href="#" class="card">1</a>
      <a href="#" class="card">2</a>
      <a href="#" class="card">3</a>
      <a href="#" class="card">4</a>
      <a href="#" class="card">5</a>
      <a href="#" class="card">6</a>
    </:content>
  </Zoetrope>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/zoetrope/types"
    @name="Signature"
  />
</template>
```

</div>

## Test Support

We provide a test support module that can be used to interact with the zoetrope component in your tests.

Use the `ZoetropeHelper` class to interact with the zoetrope component in your tests. It takes an optional `selector` argument that can be used to target a specific zoetrope component.

It has the following methods:

- `visibleItems()`: Returns the visible items as an array of DOM items.
- `visibleItemCount()`: Returns the count of visible items.
- `scrollLeft()`: Scrolls the zoetrope component to the left.
- `scrollRight()`: Scrolls the zoetrope component to the right.

```gjs no-shadow
import { render } from "@ember/test-helpers";
import { module, test } from "qunit";
import { setupRenderingTest } from "ember-qunit";

import { Zoetrope } from "ember-primitives";

import { ZoetropeHelper } from "ember-primitives/test-support";

// setup helper
const zoetrope = new ZoetropeHelper();

module("<Zoetrope />", function (hooks) {
  setupRenderingTest(hooks);

  test("basic usage renders", async function (assert) {
    await render(
      <template>
        <Zoetrope>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>,
    );

    const visibleItemsArray = zoetrope.visibleItems();

    assert.strictEqual(zoetrope.visibleItemCount(), 2);

    await zoetrope.scrollRight();

    await zoetrope.scrollLeft();
  });
});
```
