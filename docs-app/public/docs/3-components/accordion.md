# Accordion

An accordion component is an element that organizes content into collapsible sections, enabling users to expand or collapse them for efficient information presentation and navigation.

`<Accordion::Accordion />` can be used in any design system.

## Examples

<details open>
<summary><h3>Basic Accordion</h3></summary>

```gjs live preview
import { Accordion } from 'ember-primitives';

<template>
  <Accordion @type="single" as |A|>
    <A.Item @value="what" as |I|>
      <I.Header as |H|>
        <H.Trigger>What is Ember?</H.Trigger>
      </I.Header>
      <I.Content>Ember.js is a productive, battle-tested JavaScript framework for building modern web applications. It includes everything you need to build rich UIs that work on any device.</I.Content>
    </A.Item>
    <A.Item @value="why" as |I|>
      <I.Header as |H|>
        <H.Trigger>Why should I use Ember?</H.Trigger>
      </I.Header>
      <I.Content>Use Ember.js for its opinionated structure and extensive ecosystem, which simplify development and ensure long-term stability for web applications.</I.Content>
    </A.Item>
  </Accordion>

  <style>

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

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/accordion/accordion" @name="Signature" />
</template>
```

## Accessibility

...

## Keyboard Interactions
| key | description |
| :---: | :----------- |
| <kbd>Tab</kbd> | Moves focus to the next focusable element. |
| <kbd>Shift</kbd> + <kbd>Tab</kbd> | Moves focus to the previous focusable element. |
| <kbd>Space</kbd> | Toggles the accordion item. |
| <kbd>Enter</kbd> | Toggles the accordion item. |
| TODO: <kbd>Home</kbd> | Moves focus to the first accordion item. |
| TODO: <kbd>End</kbd> | Moves focus to the last accordion item. |
| TODO: <kbd>ArrowUp</kbd> | Moves focus to the previous accordion item. |
| TODO: <kbd>ArrowDown</kbd> | Moves focus to the next accordion item. |
