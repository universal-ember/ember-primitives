# Scroller

```gjs live no-shadow
import { CommentQuery } from "kolay";

<template>
  <CommentQuery
    @package="ember-primitives"
    @module="declarations/components/scroller"
    @name="Scroller"
  />
</template>
```

<div class="featured-demo">

```gjs live preview no-shadow
import { Scroller } from "ember-primitives";
import { on } from "@ember/modifier";
import { hash, fn } from "@ember/helper";
import { loremIpsum } from "lorem-ipsum";

// set during render
let scrollers = {};
const setScrollers = (s) => (scrollers = s);
const click = (methodName) => scrollers[methodName]();

<template>
  <div class="demo">
    <Scroller class="container" as |s|>
      {{(setScrollers s)}}

      <div class="big-content">
        {{loremIpsum (hash count=10 units="paragraphs")}}
      </div>
    </Scroller>

    <div class="fixed-button-set">
      <button {{on "click" (fn click "scrollToLeft")}}>⬅️</button>
      <button {{on "click" (fn click "scrollToBottom")}}>⬇️</button>
      <button {{on "click" (fn click "scrollToTop")}}>⬆️</button>
      <button {{on "click" (fn click "scrollToRight")}}>➡️</button>
    </div>
  </div>

  <style>
    .demo {
      position: relative;
    }
    .container {
      overflow: auto;
      height: 200px;
      scroll-behavior: smooth;
    }
    .big-content {
      width: 200%;
    }
    .fixed-button-set {
      position: absolute;
      top: 0rem;
      right: 0rem;
      margin-top: -4rem;
      filter: drop-shadow(0 2px 3px #555);
    }
    button {
      padding: 0;
      font-size: 2rem;
      line-height: 2rem;
    }
  </style>
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/scroller.gts" />
```

## Anatomy

```js
import { Scroller } from "ember-primitives";
```

or for non-tree-shaking environments:

```js
import { Scroller } from "ember-primitives/components/scroller";
```

```gjs
import { Scroller } from "ember-primitives";

<template>
  <Scroller as |s|>

    {{(s.scrollToTop)}}
    {{(s.scrollToBottom)}}
    {{(s.scrollToLeft)}}
    {{(s.scrolltoRight)}}

  </Scroller>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/scroller"
    @name="Scroller"
  />
</template>
```

## Accessibility

The wrapping `<div>` is scrollable, and is required to have keyboard access, via [AXE: Scrollable Region Must have Keyboard Access](https://dequeuniversity.com/rules/axe/4.8/scrollable-region-focusable?application=axeAPI).
