# Tabs

A set of layered sections of content, known as tab panels, that are displayed one at a time.


<Callout>

  Tabs _can_ be implemented without JavaScript, using "[plain HTML][css-only-tabs]", however, in order to do so, you must render all tabpanels at once (even if hidden). A defining characteristic of JavaScript-enabled tabs is that the DOM has less content rendered at once, improving page load.

  This still requires that subsequent tab loads are fast so that there is no visible UI lag.

[css-only-tabs]: https://jsfiddle.net/eu81273/812ehkyf/ 

</Callout>


<div class="featured-demo">

<!-- tabster doesn't work across the shadow boundary -->
```gjs live preview no-shadow
import { Tabs } from 'ember-primitives/components/tabs';

<template>
  <Tabs @label="Install with your favorite package-manager" as |Tab|>
    <Tab @label="npm">npm add ember-primitives</Tab>
    <Tab @label="pnpm">pnpm add ember-primitives</Tab>

    <Tab as |Label Content|>
      <Label>yarn</Label>
      <Content>
        yarn add ember-primitives
      </Content>
    </Tab>
  </Tabs>

  <style>
    /* https://caniuse.com/css-cascade-scope */
    @scope {
    [role="tablist"] {
        min-width: 100%;
      }

      [role="tab"] {
        color: black;
        display: inline-block;
        padding: 0.25rem 0.5rem; 
        background: hsl(220deg 20% 94%);
        outline: none;
        font-weight: bold;
        cursor: pointer;
        box-shadow: inset 0 -1px 1px black;
      }

      [role="tab"][aria-selected="true"] {
        background: white;
        box-shadow: inset 0 -4px 0px orange;
      }

      [role="tab"]:first-of-type {
        border-top-left-radius: 0.25rem;
      }
      [role="tab"]:last-of-type {
        border-top-right-radius: 0.25rem;
      }

      [role="tabpanel"] {
        color: black;
        padding: 1rem;
        border-radius: 0 0.25rem 0.25rem;
        background: white; 
        width: 100%;
        overflow: auto;
        font-family: ui-monospace monospace;
      }
    }
  </style>
</template>
```

</div>

## Customizing Layout

Feel free to inspect element here to see how the styles are done.

<div class="not-prose featured-demo inline-tabs">

<!-- tabster doesn't work across the shadow boundary -->
```gjs live 
import { Demo } from '#public/3-ui/tabs/layout-demo';

<template>
  <Demo />
</template>
```

</div>


Because the  [tabs pattern](https://www.w3.org/WAI/ARIA/apg/patterns/tabs/examples/tabs-manual/) involves a fair bit of boilerplate HTML for satisfying aria structure, not every element created by `<Tabs>` is exposed for direct manipulation by the caller. However, all possible Tabs layouts are possible with both CSS and [tailwind](https://tailwindcss.com/docs/styling-with-utility-classes#complex-selectors) alike. Note though that it's recommended to use [scoped CSS](https://github.com/auditboard/ember-scoped-css/) as this will provide the best ergonomics for styling HTML in the component.


## Features

* Can be controlled or uncontrolled 
* Supports any layout (via CSS, horizontal, vertical, reversed, etc) 
* Full keyboard navigation 
* Tabs may be buttons or links[^tab-links]
* Configurable activation behavior
* Supports nesting

[^tab-links]: when tabs are links there is no customizable associated content with the tab, because a navigation would occur. Use the routing system to place content in the `{{outlet}}` provided for you in the implicit content area.

## Installation

```bash
npm install ember-primitives
```

Introduced in [0.41.0](https://github.com/universal-ember/ember-primitives/releases/tag/v0.41.0-ember-primitives)

## Anatomy

All content can either be a argument or block to better suit your invocation and styling needs.

```gjs
import { Tabs } from 'ember-primitives/components/tabs';

<template>
  {{! Label as argument (may be a component) }}
  <Tabs @label="text here" as TabList>...</Tabs>

  {{! Label as block }}
  <Tabs as |Tab|>
    <Tab.Label>text here</Tab.Label>
    ...
  </Tabs>

  {{! tab as arguments (each arg may also be a component) }}
  <Tabs as |Tab|>
    <Tab @label="Banana" @content="something about bananas" />
  </Tabs>

  {{! tab content as blocks }}
  <Tabs as |Tab|>
    <Tab @label="Banana">
      something about bananas
    </Tab>
  </Tabs>

  {{! tab content and label as components }}
  <Tabs as |Tab|>
    <Tab as |Label Content|>
      <Label>
        Banana
      </Label>

      <Content>
        something about bananas
      </Content>
    </Tab>
  </Tabs>
</template>
```

## Accessibility

- Follows the [WAI-ARIA](https://www.w3.org/WAI/ARIA/apg/patterns/tabs) pattern for Tabs.
- Keyboard interaction provided by [tabster](https://tabster.io/). 

### Keyboard Interactions 

| key | description |
| :---: | :----------- |  
| <kbd>Tab</kbd> | When focus moves on to the tabs, the first tab is focused |  
| <kbd>ArrowLeft</kbd> | Moves focus to the previous tab |  
| <kbd>ArrowRight</kbd> | Moves focus to the next tab |  
| <kbd>ArrowDown</kbd> | Moves focus to the next tab |  
| <kbd>ArrowUp</kbd> | Moves focus to the previous tab |  
| <kbd>Home</kbd> | Moves focus to the first tab |  
| <kbd>End</kbd> | Moves focus to the last tab |  



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

### Classes & Attributes

All these classes do nothing on their own, but offer a way for folks authoring CSS to set their styles (especially since `@scope` isn't available everywhere (yet?)).


- `ember-primitives__tabs`

  This is the class on the root-level element. This element has data attributes representing the overall state of the tabs component

  - `data-active` string. Will represent the id or (if provided), the value of the active tab.

- `ember-primitives__tabs__label`
  
  The element around the label text, whether passed as an argument or block content.

- `ember-primitives__tabs__tabpanel`

  The containing element of the active tab content. This element has `[role='tabpanel']`
  

- `ember-primitives__tabs__tablist`

  The containing element of each of the tabs. This element has `[role='tablist']`




