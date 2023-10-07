# Accordion

An accordion component is an element that organizes content into collapsible sections, enabling users to expand or collapse them for efficient information presentation and navigation.

`<Accordion::Accordion />` can be used in any design system.

## Examples

<details open>
<summary><h3>Simple Accordion</h3></summary>

```gjs live preview
import { Accordion } from 'ember-primitives';

<template>
  <Accordion @type="single" as |A|>
    <A.Item class="accordion-item" @value="what" as |I|>
      <I.Header as |H|>
        <H.Trigger class="accordion-trigger">What is Ember?</H.Trigger>
      </I.Header>
      <I.Content class="accordion-content">Ember.js is a productive, battle-tested JavaScript framework for building modern web applications. It includes everything you need to build rich UIs that work on any device.</I.Content>
    </A.Item>
    <A.Item class="accordion-item" @value="why" as |I|>
      <I.Header as |H|>
        <H.Trigger class="accordion-trigger">Why should I use Ember?</H.Trigger>
      </I.Header>
      <I.Content class="accordion-content">Use Ember.js for its opinionated structure and extensive ecosystem, which simplify development and ensure long-term stability for web applications.</I.Content>
    </A.Item>
  </Accordion>

  <style>
    /* Bootstrap 5 Accordion styles (more or less) */
    .accordion-item {
      color: #dee2e6;
      background-color: #212529;
      border: 1px solid #495057;
    }

    .accordion-item:not(:first-of-type) {
      border-top: 0px;
    }

    .accordion-item:first-of-type {
      border-top-left-radius: 0.375rem;
      border-top-right-radius: 0.375rem;
    }

    .accordion-item:first-of-type .accordion-trigger {
      border-top-left-radius: 0.375rem;
      border-top-right-radius: 0.375rem;
    }

    .accordion-item:last-of-type {
      border-bottom-left-radius: 0.375rem;
      border-bottom-right-radius: 0.375rem;
    }

    .accordion-item:last-of-type .accordion-trigger {
      border-bottom-left-radius: 0.375rem;
      border-bottom-right-radius: 0.375rem;
    }

    .accordion-content {
      padding: 1rem 1.25rem;
    }

    .accordion-trigger {
      position: relative;
      display: flex;
      align-items: center;
      width: 100%;
      font-size: 1rem;
      color: #dee2e6;
      text-align: left;
      background-color: #212529;
      overflow-anchor: none;
      padding: 1rem 1.25rem;
      border-width: 0px;
      border-style: initial;
      border-color: initial;
      border-image: initial;
      border-radius: 0px;
      transition: color 0.15s ease-in-out,background-color 0.15s ease-in-out,border-color 0.15s ease-in-out,box-shadow 0.15s ease-in-out,border-radius 0.15s ease;
    }

    .accordion-trigger:not(:disabled) {
      cursor: pointer;
    }

    .accordion-item[data-state="open"] .accordion-trigger {
      color: #6ea8fe;
      background-color: #031633;
    }
  </style>
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
        height: 40px;
      }
    }

    @keyframes slide-up {
      from {
        height: 40px;
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
</details>

<details>
<summary><h3>AccordionItem</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionItem" />
</template>
```
</details>

<details>
<summary><h3>AccordionHeader</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionHeader" />
</template>
```
</details>

<details>
<summary><h3>AccordionTrigger</h3></summary>

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="AccordionTrigger" />
</template>
```
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

...

## Keyboard Interactions
| key | description |
| :---: | :----------- |
| <kbd>Tab</kbd> | Moves focus to the next focusable element. |
| <kbd>Shift</kbd> + <kbd>Tab</kbd> | Moves focus to the previous focusable element. |
| <kbd>Space</kbd> | Toggles the accordion item. |
| <kbd>Enter</kbd> | Toggles the accordion item. |
