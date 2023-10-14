# Accordion

An accordion component is an element that organizes content into collapsible sections, enabling users to expand or collapse them for efficient information presentation and navigation.

`<Accordion::Accordion />` can be used in any design system.

## Examples

<details open>
<summary><h3>Bootstrap</h3></summary>

```gjs live preview
import { Accordion } from 'ember-primitives';

<template>
  <Accordion class="accordion" @type="single" as |A|>
    <A.Item class="accordion-item" @value="what" as |I|>
      <I.Header class="accordion-header" as |H|>
        <H.Trigger aria-expanded="{{I.isExpanded}}" class="accordion-button {{unless I.isExpanded 'collapsed'}}">What is Ember?</H.Trigger>
      </I.Header>
      <I.Content class="accordion-collapse collapse {{if I.isExpanded 'show'}}">
        <div class="accordion-body">
          Ember.js is a productive, battle-tested JavaScript framework for building modern web applications. It includes everything you need to build rich UIs that work on any device.
        </div>
      </I.Content>
    </A.Item>
    <A.Item class="accordion-item" @value="why" as |I|>
      <I.Header class="accordion-header" as |H|>
        <H.Trigger aria-expanded="{{I.isExpanded}}" class="accordion-button {{unless I.isExpanded 'collapsed'}}">Why should I use Ember?</H.Trigger>
      </I.Header>
      <I.Content class="accordion-collapse collapse {{if I.isExpanded 'show'}}">
        <div class="accordion-body">
          Use Ember.js for its opinionated structure and extensive ecosystem, which simplify development and ensure long-term stability for web applications.
        </div>    
      </I.Content>
    </A.Item>
  </Accordion>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
</template>
```
</details>

<details>
<summary><h3>Animated</h3></summary>

```gjs live preview
import { Accordion } from 'ember-primitives';

<template>
  <Accordion @type="single" as |A|>
    <A.Item @value="what" as |I|>
      <I.Header as |H|>
        <H.Trigger>What is Ember?</H.Trigger>
      </I.Header>
      <I.Content class="accordion-content">Ember.js is a productive, battle-tested JavaScript framework for building modern web applications. It includes everything you need to build rich UIs that work on any device.</I.Content>
    </A.Item>
    <A.Item @value="why" as |I|>
      <I.Header as |H|>
        <H.Trigger>Why should I use Ember?</H.Trigger>
      </I.Header>
      <I.Content class="accordion-content">Use Ember.js for its opinionated structure and extensive ecosystem, which simplify development and ensure long-term stability for web applications.</I.Content>
    </A.Item>
  </Accordion>

  <style>
    .accordion-content {
      overflow: hidden;
    }

    .accordion-content[data-state="open"] {
      animation: slide-down 0.3s ease-in-out;
    }

    .accordion-content[data-state="closed"] {
      animation: slide-up 0.3s ease-in-out;
    }

    @keyframes slide-down {
      from {
        height: 0;
      }

      to {
        height: var(--accordion-content-height);
      }
    }

    @keyframes slide-up {
      from {
        height: var(--accordion-content-height);
      }

      to {
        height: 0;
      }
    }
  </style>
</template>
```
</details>

## Features

* Full keyboard navigation
* Can be controlled or uncontrolled

## Installation

```bash
pnpm add ember-primitives
```

## Anatomy

```js
import { Accordion } from 'ember-primitives';
```

or for non tree-shaking environments:
```js
import { Accordion } from 'ember-primitives/components/accordion';
```

```gjs
import { Accordion } from 'ember-primitives';

<template>
  <Accordion as |A|>
    <A.Item as |I|>
      <I.Header as |H|>
        <H.Trigger>Trigger</H.Trigger>
      </I.Header>
      <I.Content>Content</I.Content>
  </Accordion>
</template>
```

## API Reference

<details open>
<summary><h3>Accordion</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="Accordion" />
</template>
```

### State Attributes
| key | description |
| :---: | :----------- |
| `data-disabled` | Indicates whether the accordion is disabled. |
</details>

<details>
<summary><h3>AccordionItem</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionItem" />
</template>
```

### State Attributes
| key | description |
| :---: | :----------- |
| `data-state` | "open" or "closed", depending on whether the accordion item is expanded or collapsed. |
| `data-disabled` | Indicates whether the accordion item is disabled. |
</details>

<details>
<summary><h3>AccordionHeader</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionHeader" />
</template>
```

### State Attributes
| key | description |
| :---: | :----------- |
| `data-state` | "open" or "closed", depending on whether the accordion item is expanded or collapsed. |
| `data-disabled` | Indicates whether the accordion item is disabled. |
</details>

<details>
<summary><h3>AccordionTrigger</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionTrigger" />
</template>
```

### State Attributes
| key | description |
| :---: | :----------- |
| `data-state` | "open" or "closed", depending on whether the accordion item is expanded or collapsed. |
| `data-disabled` | Indicates whether the accordion item is disabled. |
</details>

<details>
<summary><h3>AccordionContent</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionContent" />
</template>
```
</details>

## Accessibility

* Sets `aria-expanded` on the accordion trigger to indicate whether the accordion item is expanded or collapsed.
* Uses `aria-controls` and `id` to associate the accordion trigger with the accordion content.
* Sets `hidden` on the accordion content when it is collapsed.

## Keyboard Interactions
| key | description |
| :---: | :----------- |
| <kbd>Tab</kbd> | Moves focus to the next focusable element. |
| <kbd>Shift</kbd> + <kbd>Tab</kbd> | Moves focus to the previous focusable element. |
| <kbd>Space</kbd> | Toggles the accordion item. |
| <kbd>Enter</kbd> | Toggles the accordion item. |