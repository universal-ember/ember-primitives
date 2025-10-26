# Tabs

A set of layered sections of content—known as tab panels—that are displayed one at a time.


<div class="featured-demo">

```gjs live preview no-shadow
import { Tabs } from 'ember-primitives/components/tabs';

<template>
  <Tabs class="tabs" @label="A list of foods" as |Tab|>
    <Tab @label="apple"> 
      content about apples
    </Tab>
    <Tab @label="banana"> 
      content about bananas
    </Tab>
    <Tab as |trigger content|>
      <trigger class="blue">durian</trigger>
      <content>
        content about durian
      </content>
    </Tab>
  </Tabs>
  <style>
    [role="tablist"] {
      min-width: 100%;
    }

    [role="tab"],
    [role="tab"]:focus,
    [role="tab"]:hover {
      color: black;
      display: inline-block;
      position: relative;
      z-index: 2;
      top: 2px;
      margin: 0;
      margin-top: 4px;
      padding: 3px 3px 4px;
      border: 1px solid hsl(219deg 1% 72%);
      border-bottom: 2px solid hsl(219deg 1% 72%);
      border-radius: 5px 5px 0 0;
      background: hsl(220deg 20% 94%);
      outline: none;
      font-weight: bold;
      max-width: 22%;
      overflow: hidden;
      text-align: left;
      cursor: pointer;
    }

    [role="tab"][aria-selected="true"] {
      padding: 2px 2px 4px;
      margin-top: 0;
      border-width: 2px;
      border-top-width: 6px;
      border-top-color: rgb(36 116 214);
      border-bottom-color: hsl(220deg 43% 99%);
      background: hsl(220deg 43% 99%);
    }

    [role="tab"][aria-selected="false"] {
      border-bottom: 1px solid hsl(219deg 1% 72%);
    }

    [role="tab"] span.focus {
      display: inline-block;
      margin: 2px;
      padding: 4px 6px;
    }

    [role="tab"]:hover span.focus,
    [role="tab"]:focus span.focus,
    [role="tab"]:active span.focus {
      padding: 2px 4px;
      border: 2px solid rgb(36 116 214);
      border-radius: 3px;
    }

    [role="tabpanel"] {
      padding: 5px;
      border: 2px solid hsl(219deg 1% 72%);
      border-radius: 0 5px 5px;
      background: hsl(220deg 43% 99%);
      min-height: 10em;
      width: 100%;
      overflow: auto;
    }

    [role="tabpanel"].is-hidden {
      display: none;
    }

    [role="tabpanel"] p {
      margin: 0;
    }
  </style>
</template>
```

</div>


Because the  [tabs pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/examples/tabs-manual/) involves a fair bit of boilerplate HTML for satisfying aria structure, not every element created by `<Tabs>` is exposed for direct manipulation by the caller. However, all possible Tabs layouts are possible with both CSS and [tailwind](https://tailwindcss.com/docs/styling-with-utility-classes#complex-selectors) alike. However, it's recommended to use [scoped CSS](https://github.com/auditboard/ember-scoped-css/) as this will provide the best ergonomics for styling HTML in the component.


## Features

* Can be controlled or uncontrolled 
* Supports any layout (via CSS, horizontal, vertical, reversed, etc) 
* Full keyboard navigation 
* Tabs may be buttons or links[^tab-links]

[^tab-links]: when tabs are links there is no customizable associated content with the tab, because a navigation would occur. Use the routing system to place content in the `{{outlet}}` provided for you in the implicit content area.

## Installation

```bash
npm install ember-primitives
```

## Anatomy

todo

## Accessibility

todo

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/tabs" 
    @name="Signature" />
</template>
```

### Classes

For styling with a stylesheet:

- `ember-primitives__tabs`
- `ember-primitives__tabs__label`
- `ember-primitives__tabs__tabpanel`
- `ember-primitives__tabs__tablist`


### State Attributes

todo
