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

const randomValue = resource(({on}) => {
  let value = cell(randomPercent());
  let interval = setInterval(() => value.current = randomPercent(), 3000);
  on.cleanup(() => clearInterval(interval));

  return value;
}); 

const randomPercent = () => Math.random() * 100;
const translate = (v) => -(100 - v);

<template>
  <Progress @value={{(randomValue)}} aria-label="demo" as |x|>
    <span>{{Math.round x.value}}%</span>
    <x.Indicator style="transform: translateX({{translate x.percent}}%);" />
  </Progress>

  <style>
    [role="progressbar"] {
      margin: 0 auto;
      width: 60%;
      height: 1.5rem;
      border-radius: 0.75rem;
      position: relative;
      overflow: hidden;
      background: conic-gradient(at -20% 15%, white 0%, #aaccff 72%);
    }
    [role="progressbar"] > div {
      background: linear-gradient(45deg, #5E0091FF 0%, #004976FF 100%);
      width: 100%;
      height: 100%;
      border-radius: 1rem;
      transition: transform 700ms cubic-bezier(0.65, 0, 0.35, 1);
    }
    [role="progressbar"] > span {
      line-height: 1.5rem;
      text-align: center;
      width: 100%;
      color: white;
      mix-blend-mode: difference;
      position: absolute;
      z-index: 1;
    }
  </style>
</template>
```

</div>

<div class="featured-demo">

```gjs live preview
import { Progress } from 'ember-primitives';
import { cell, resource } from 'ember-resources';

const randomValue = resource(({on}) => {
  let value = cell(randomPercent());
  let interval = setInterval(() => value.current = randomPercent(), 3000);
  on.cleanup(() => clearInterval(interval));

  return value;
}); 

const randomPercent = () => Math.random() * 100;
const r = 60;
const size = Math.PI * 2 * r;
const toOffset = (x) => ((100 - x) / 100) * size;

const RandomProgress = 
<template>
  <Progress @value={{(randomValue)}} ...attributes as |x|>
    <x.Indicator class="progress" />
    <svg width="200" height="200" viewPort="0 0 100 100">
      <circle 
        r={{r}} cx="100" cy="100" 
        fill="transparent" 
        stroke-dasharray={{size}} stroke-dashoffset="0"></circle>
      <circle
        r={{r}} cx="100" cy="100" 
        fill="transparent" 
        style="stroke: {{@color}}"
        stroke-linecap="round"
        stroke-dasharray={{size}} stroke-dashoffset="{{toOffset x.percent}}"></circle>
    </svg>
  </Progress>

  <style>
    [role="progressbar"] { position: relative; }
    svg circle {
      transition: stroke-dashoffset 0.5s linear;
      stroke: #555;
      stroke-width: 1rem;
    }
    .progress {
      height: 200px;
      width: 200px;
      position: absolute;
      text-align: center;
    }
    .progress:after {
      content: attr(data-percent)"%";
      line-height: 200px;
      font-size: 1.5rem;
    }
  </style>
</template>;

<template>
  <div style="display: flex; gap: 1.5rem">
    <RandomProgress @color="#FF1E7D" aria-label="demo-pink" />
    <RandomProgress @color="#1EFF7D" aria-label="demo-green" />
  </div>
</template>
```

</div>

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
  </Switch>
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
