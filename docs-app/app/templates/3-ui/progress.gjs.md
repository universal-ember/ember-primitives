# Progress

Displays an indicator showing the completion progress of a task, typically displayed as a progress bar.

<Callout>

Before reaching for this component, consider if the [native `<progress>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/progress) is sufficient for your use case. 

</Callout>
<br>


<div class="featured-demo">

```gjs live preview
import { Progress } from 'ember-primitives';
import { cell, resource } from 'ember-resources';

const progress = resource(({ on }) => {
  let value = cell(12);
  let interval = setInterval(() => {
    value.current = value.current >= 100 ? 8 : value.current + 14;
  }, 900);
  on.cleanup(() => clearInterval(interval));
  return value;
});

<template>
  <Progress @value={{(progress)}} aria-label="Upload progress" class="bar" as |x|>
    <span class="label">{{Math.round x.value}}%</span>
    <x.Indicator class="fill" style="width: {{x.percent}}%" />
  </Progress>

  <style>
    .bar {
      position: relative;
      display: block;
      width: min(100%, 22rem);
      height: 0.65rem;
      overflow: hidden;
      border-radius: 999px;
      background: var(--doc-bg);
      border: 1px solid var(--doc-border);
    }

    .fill {
      display: block;
      height: 100%;
      border-radius: inherit;
      background: var(--doc-brand-1);
      transition: width 500ms ease;
    }

    .label {
      position: absolute;
      inset: auto 0 100% 0;
      margin-bottom: 0.45rem;
      font-size: 0.8125rem;
      font-weight: 500;
      color: var(--doc-text-2);
      font-family: var(--font-sans);
    }
  </style>
</template>
```

</div>

<div class="featured-demo">

```gjs live preview
import { Progress } from 'ember-primitives';
import { cell, resource } from 'ember-resources';

const progress = resource(({ on }) => {
  let value = cell(35);
  let interval = setInterval(() => {
    value.current = value.current >= 100 ? 10 : value.current + 12;
  }, 1100);
  on.cleanup(() => clearInterval(interval));
  return value;
});

const r = 54;
const size = Math.PI * 2 * r;
const toOffset = (percent) => ((100 - percent) / 100) * size;

<template>
  <Progress @value={{(progress)}} aria-label="Circular progress" class="circle" as |x|>
    <svg width="140" height="140" viewBox="0 0 140 140" aria-hidden="true">
      <circle class="track" r={{r}} cx="70" cy="70" />
      <circle
        class="value"
        r={{r}}
        cx="70"
        cy="70"
        stroke-dasharray={{size}}
        stroke-dashoffset={{toOffset x.percent}}
      />
    </svg>
    <span class="pct">{{Math.round x.percent}}%</span>
  </Progress>

  <style>
    .circle {
      position: relative;
      display: inline-grid;
      place-items: center;
      width: 140px;
      height: 140px;
    }

    .circle svg {
      transform: rotate(-90deg);
    }

    .circle circle {
      fill: transparent;
      stroke-width: 8;
    }

    .track {
      stroke: var(--doc-border);
    }

    .value {
      stroke: var(--doc-brand-1);
      stroke-linecap: round;
      transition: stroke-dashoffset 500ms ease;
    }

    .pct {
      position: absolute;
      font-family: var(--font-sans);
      font-size: 1.125rem;
      font-weight: 600;
      color: var(--doc-text-1);
    }
  </style>
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/progress.gts" @since="0.3.0" />
```

## Features

* Provides context for assistive technology to read the progress of a task.


## Anatomy

```js 
import { Progress } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Progress } from 'ember-primitives/components/progress';
```


```gjs 
import { Progress } from 'ember-primitives';

<template>
  <Progress aria-label="example" as |x|>
    <x.Indicator />
    <x.Indicator>
      with text
    </x.Indicator>

    text can go out here, too
  </Progress>
</template>
```

## Accessibility

Adheres to the [`progressbar` role requirements](https://www.w3.org/WAI/ARIA/apg/patterns/meter).

Note that a progressbar is [required to have a name](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/progressbar_role#associated_wai-aria_roles_states_and_properties).

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/progress" 
    @name="Signature" />
</template>
```

### State Attributes

<br>

#### `<Progress>`

| key | description |  
| :---: | :----------- |  
| `data-state` | `'complete' \| 'indeterminate' \| 'loading'` | 
| `data-value` | The current value. Will never be less than 0, and never more than `@max` 
| `data-max` | The max value 
| `data-min` | Always 0 
| `data-percent` | The current value, rounded to two decimal places


#### `<Indicator>`

| key | description |  
| :---: | :----------- |  
| `data-state` | `'complete' \| 'indeterminate' \| 'loading'` | 
| `data-value` | The current value. Will never be less than 0, and never more than `@max` 
| `data-max` | The max value 
| `data-percent` | The current value, rounded to two decimal places
