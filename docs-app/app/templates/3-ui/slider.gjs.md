# Slider

An input where the user selects a value from within a given range. 

<Callout>

Before reaching for this component, consider if the [range `<input>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/range) is sufficient for your use case.

A custom slider -- as in this component -- is (currently) needed when you want a specific UX or you want to customize the look of the slider.

</Callout>


<div class="not-prose">

```gjs live
import { Gallery } from '#docs/3-ui/slider/gallery';

<template>
  <Gallery />
</template>
```

</div>

Each thumb is an invisible native `<input type="range">` stretched over the styled UI -- this maintains `<form>` semantics and accessibility, without re-implementing keyboard or pointer behavior.

All of the structural CSS needed for this technique (positioning, hiding the native inputs, routing pointer events for multi-thumb sliders, vertical orientation) ships with the component. You only style the appearance: colors, sizes, borders, etc. By default the track, range, and thumb derive their colors from `currentColor`, and every appearance rule has zero specificity -- any selector of yours overrides it.

## Range Slider

Pass an array to `@value` to get one thumb per value.

```gjs live preview
import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell([25, 75]);
const first = () => value.current[0];
const second = () => value.current[1];

<template>
  <div class="demo">
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value" />
        {{/each}}
      </s.Track>
    </Slider>

    <p>Range: {{ (first) }} - {{ (second) }}</p>

    <style>
      @scope {
      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
        margin: 2rem auto;
      }

      .ember-primitives__slider__thumb {
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 2rem;
      }
      }
    </style>
  </div>
</template>
```

## Discrete Values

When you want “ticks”, you typically want the slider to snap to a discrete set of values.

Pass an array to `@step`.

```gjs live preview
import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

const tickValues = [0, 10, 20, 30, 40, 50];
const value = cell(20);
const percentAt = (index) => (index / (tickValues.length - 1)) * 100;

<template>
  <div class="demo">
    <Slider @value={{value.current}} @step={{tickValues}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value" />
        {{/each}}
      </s.Track>
    </Slider>

    <div class="ticks" aria-hidden="true">
      {{#each tickValues as |tick idx|}}
        <span class="tick" style="left: {{percentAt idx}}%;">
          {{tick}}
        </span>
      {{/each}}
    </div>

    <p>Value: {{value.current}}</p>

    <style>
      @scope {
      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
        margin: 2rem auto 0.5rem;
      }

      .ticks {
        position: relative;
        width: 300px;
        margin: 0 auto;
        height: 18px;
      }

      .tick {
        position: absolute;
        transform: translateX(-50%);
        font-size: 0.75rem;
        color: #444;
        user-select: none;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 0.75rem;
      }
      }
    </style>
  </div>
</template>
```

## Slider With Tooltip (Composed)

`<s.Thumb>` accepts a block, rendered inside the visual thumb -- anything absolutely-positioned in that block moves with the thumb for free.

(For positioning elements *outside* the thumb, each yielded `thumb` also provides `percent` and a ready-made `positionStyle`.)

```gjs live preview
import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell([25, 75]);

<template>
  <div class="demo">
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value">
            <output class="tooltip">{{thumb.value}}</output>
          </s.Thumb>
        {{/each}}
      </s.Track>
    </Slider>

    <p>Range: {{value.current}}</p>

    <style>
      @scope {
      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
        margin: 2rem auto;
      }

      .ember-primitives__slider__thumb {
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      .tooltip {
        position: absolute;
        bottom: calc(100% + 10px);
        left: 50%;
        translate: -50% 0;
        background: #111;
        color: white;
        font-size: 0.75rem;
        line-height: 1;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        white-space: nowrap;
        user-select: none;
        font-variant-numeric: tabular-nums;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 2rem;
      }
      }
    </style>
  </div>
</template>
```

## Slider With Labels

```gjs live preview
import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell(50);

<template>
  <div class="demo">
    <div class="labels" aria-hidden="true">
      <span>Low</span>
      <span>High</span>
    </div>

    <Slider @value={{value.current}} @onValueChange={{value.set}} @step={{10}} />

    <p>Value: {{value.current}}</p>

    <style>
      @scope {
      .labels {
        display: flex;
        width: 300px;
        margin: 0 auto 0.5rem;
        justify-content: space-between;
        font-size: 0.75rem;
        color: #444;
        user-select: none;
      }

      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
        margin: 0 auto;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 0.75rem;
      }
      }
    </style>
  </div>
</template>
```

## Slider With Input

This pattern keeps an `<input>` in sync with the slider, while letting users type and “commit” on blur / Enter.

```gjs live preview
import { Slider } from 'ember-primitives';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';

const min = 0;
const max = 100;

const value = cell(40);
const inputText = cell('40');

const clamp = (n) => Math.min(max, Math.max(min, n));

const onSliderChange = (next) => {
  value.set(next);
  inputText.set(String(next));
};

const onInput = (event) => inputText.set(event.target.value);

const commit = () => {
  let parsed = Number(inputText.current);

  if (Number.isNaN(parsed)) parsed = value.current;

  parsed = clamp(parsed);
  value.set(parsed);
  inputText.set(String(parsed));
};

const onKeydown = (event) => {
  if (event.key !== 'Enter') return;
  event.preventDefault();
  commit();
  event.target.blur();
};

<template>
  <div class="demo">
    <div class="row">
      <Slider @value={{value.current}} @onValueChange={{onSliderChange}} @min={{min}} @max={{max}} />

      <label class="input">
        <span class="sr-only">Value</span>
        <input
          type="number"
          min={{min}}
          max={{max}}
          value={{inputText.current}}
          {{on "input" onInput}}
          {{on "blur" commit}}
          {{on "keydown" onKeydown}}
        />
      </label>
    </div>

    <style>
      @scope {
      .row {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 1rem;
        margin: 2rem auto;
        width: 360px;
      }

      .input input {
        width: 5rem;
      }

      .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        white-space: nowrap;
        border: 0;
      }

      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
      }
      }
    </style>
  </div>
</template>
```

## Dual Range Slider With Input

```gjs live preview
import { Slider } from 'ember-primitives';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';

const min = 0;
const max = 100;

const range = cell([25, 75]);
const minText = cell('25');
const maxText = cell('75');

const clamp = (n, lo, hi) => Math.min(hi, Math.max(lo, n));

const onSliderChange = (next) => {
  range.set(next);
  minText.set(String(next[0]));
  maxText.set(String(next[1]));
};

const onMinInput = (event) => minText.set(event.target.value);
const onMaxInput = (event) => maxText.set(event.target.value);

const commitMin = () => {
  let parsed = Number(minText.current);
  if (Number.isNaN(parsed)) parsed = range.current[0];

  parsed = clamp(parsed, min, range.current[1]);
  range.set([parsed, range.current[1]]);
  minText.set(String(parsed));
};

const commitMax = () => {
  let parsed = Number(maxText.current);
  if (Number.isNaN(parsed)) parsed = range.current[1];

  parsed = clamp(parsed, range.current[0], max);
  range.set([range.current[0], parsed]);
  maxText.set(String(parsed));
};

const onKeydown = (commitFn) => (event) => {
  if (event.key !== 'Enter') return;
  event.preventDefault();
  commitFn();
  event.target.blur();
};

<template>
  <div class="demo">
    <div class="row">
      <label class="input">
        <span class="sr-only">Minimum</span>
        <input
          type="number"
          min={{min}}
          max={{max}}
          value={{minText.current}}
          {{on "input" onMinInput}}
          {{on "blur" commitMin}}
          {{on "keydown" (onKeydown commitMin)}}
        />
      </label>

      <Slider @value={{range.current}} @onValueChange={{onSliderChange}} @min={{min}} @max={{max}} as |s|>
        <s.Track>
          <s.Range />
          {{#each s.thumbs as |thumb|}}
            <s.Thumb @thumb={{thumb}} aria-label="Value" />
          {{/each}}
        </s.Track>
      </Slider>

      <label class="input">
        <span class="sr-only">Maximum</span>
        <input
          type="number"
          min={{min}}
          max={{max}}
          value={{maxText.current}}
          {{on "input" onMaxInput}}
          {{on "blur" commitMax}}
          {{on "keydown" (onKeydown commitMax)}}
        />
      </label>
    </div>

    <p>Range: {{range.current}}</p>

    <style>
      @scope {
      .row {
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 1rem;
        margin: 2rem auto;
        width: 420px;
      }

      .input input {
        width: 5rem;
      }

      .sr-only {
        position: absolute;
        width: 1px;
        height: 1px;
        padding: 0;
        margin: -1px;
        overflow: hidden;
        clip: rect(0, 0, 0, 0);
        white-space: nowrap;
        border: 0;
      }

      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
      }

      .ember-primitives__slider__thumb {
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 0;
      }
      }
    </style>
  </div>
</template>
```

## Slider With Multiple Thumbs

Any number of values is supported -- each gets a thumb, and thumbs cannot cross each other.

```gjs live preview
import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell([25, 50, 75]);

<template>
  <div class="demo">
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value">
            <output class="tooltip">{{thumb.value}}%</output>
          </s.Thumb>
        {{/each}}
      </s.Track>
    </Slider>

    <p>Values: {{value.current}}</p>

    <style>
      @scope {
      .ember-primitives__slider {
        color: #1a73e8;
        width: 300px;
        margin: 2rem auto;
      }

      .ember-primitives__slider__thumb {
        border: 2px solid white;
        border-radius: 6px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      .tooltip {
        position: absolute;
        bottom: calc(100% + 10px);
        left: 50%;
        translate: -50% 0;
        background: #111;
        color: white;
        font-size: 0.75rem;
        line-height: 1;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        white-space: nowrap;
        user-select: none;
        font-variant-numeric: tabular-nums;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 2rem;
      }
      }
    </style>
  </div>
</template>
```

## Equalizer

Vertical orientation is handled by the component (via `writing-mode` on the native inputs) -- set the length with `--ember-primitives__slider__vertical-size`.

```gjs live preview
import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

const hz60 = cell(2);
const hz250 = cell(1);
const hz1k = cell(-1);
const hz4k = cell(-3);
const hz16k = cell(2);

const bands = [
  { label: '60', value: hz60 },
  { label: '250', value: hz250 },
  { label: '1k', value: hz1k },
  { label: '4k', value: hz4k },
  { label: '16k', value: hz16k },
];

<template>
  <div class="demo">
    <div class="equalizer" role="group" aria-label="Equalizer">
      {{#each bands as |band|}}
        <div class="band">
          <Slider
            @value={{band.value.current}}
            @onValueChange={{band.value.set}}
            @min={{-5}}
            @max={{5}}
            @orientation="vertical"
            as |s|>
            <s.Track>
              <s.Range />
              {{#each s.thumbs as |thumb|}}
                <s.Thumb @thumb={{thumb}} aria-label={{band.label}}>
                  <output class="tooltip">{{thumb.value}}</output>
                </s.Thumb>
              {{/each}}
            </s.Track>
          </Slider>
          <div class="band-label" aria-hidden="true">{{band.label}}</div>
        </div>
      {{/each}}
    </div>

    <style>
      @scope {
      .equalizer {
        display: flex;
        justify-content: center;
        gap: 1.5rem;
        align-items: flex-end;
        padding: 1rem 0;
      }

      .band {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 0.5rem;
      }

      .band-label {
        font-size: 0.75rem;
        color: #444;
        user-select: none;
      }

      .ember-primitives__slider {
        color: #1a73e8;
        --ember-primitives__slider__vertical-size: 200px;
      }

      .ember-primitives__slider__thumb {
        width: 16px;
        height: 20px;
        border: 2px solid white;
        border-radius: 6px;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      .tooltip {
        position: absolute;
        bottom: 50%;
        left: calc(100% + 10px);
        translate: 0 50%;
        background: #111;
        color: white;
        font-size: 0.75rem;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        pointer-events: none;
        white-space: nowrap;
        font-variant-numeric: tabular-nums;
        min-width: 2ch;
        text-align: center;
      }
      }
    </style>
  </div>
</template>
```

## Price Slider (Histogram + Range)

This demonstrates composing a “price slider” UI (histogram + dual-range selection + inputs) on top of the primitive.

```gjs live preview
import { Slider } from 'ember-primitives';
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';

const min = 0;
const max = 1000;

// Fake histogram data (percent heights 10..100)
const bins = [
  { value: 0, height: 20 },
  { value: 50, height: 35 },
  { value: 100, height: 30 },
  { value: 150, height: 55 },
  { value: 200, height: 70 },
  { value: 250, height: 62 },
  { value: 300, height: 80 },
  { value: 350, height: 60 },
  { value: 400, height: 45 },
  { value: 450, height: 50 },
  { value: 500, height: 75 },
  { value: 550, height: 68 },
  { value: 600, height: 58 },
  { value: 650, height: 48 },
  { value: 700, height: 40 },
  { value: 750, height: 52 },
  { value: 800, height: 65 },
  { value: 850, height: 42 },
  { value: 900, height: 28 },
  { value: 950, height: 18 },
  { value: 1000, height: 12 },
];

const range = cell([250, 750]);
const minText = cell('250');
const maxText = cell('750');

const clamp = (n, lo, hi) => Math.min(hi, Math.max(lo, n));

const isInRange = (bin) => {
  const lo = range.current[0];
  const hi = range.current[1];

  return bin.value >= lo && bin.value <= hi;
};

const onSliderChange = (next) => {
  range.set(next);
  minText.set(String(next[0]));
  maxText.set(String(next[1]));
};

const onMinInput = (event) => minText.set(event.target.value);
const onMaxInput = (event) => maxText.set(event.target.value);

const commitMin = () => {
  let parsed = Number(minText.current);
  if (Number.isNaN(parsed)) parsed = range.current[0];

  parsed = clamp(parsed, min, range.current[1]);
  range.set([parsed, range.current[1]]);
  minText.set(String(parsed));
};

const commitMax = () => {
  let parsed = Number(maxText.current);
  if (Number.isNaN(parsed)) parsed = range.current[1];

  parsed = clamp(parsed, range.current[0], max);
  range.set([range.current[0], parsed]);
  maxText.set(String(parsed));
};

const onKeydown = (commitFn) => (event) => {
  if (event.key !== 'Enter') return;
  event.preventDefault();
  commitFn();
  event.target.blur();
};

<template>
  <div class="demo">
    <div class="price">
      <div class="hist" aria-hidden="true">
        {{#each bins as |bin|}}
          <div class="bar-wrap">
            <div
              class="bar {{if (isInRange bin) 'active'}}"
              style="height: {{bin.height}}%;"
              title="{{bin.value}}"
            />
          </div>
        {{/each}}
      </div>

      <Slider @value={{range.current}} @onValueChange={{onSliderChange}} @min={{min}} @max={{max}} @step={{10}} as |s|>
        <s.Track>
          <s.Range />
          {{#each s.thumbs as |thumb|}}
            <s.Thumb @thumb={{thumb}} aria-label="Price" />
          {{/each}}
        </s.Track>
      </Slider>

      <div class="inputs">
        <label>
          Min
          <input
            type="number"
            min={{min}}
            max={{max}}
            value={{minText.current}}
            {{on "input" onMinInput}}
            {{on "blur" commitMin}}
            {{on "keydown" (onKeydown commitMin)}}
          />
        </label>

        <label>
          Max
          <input
            type="number"
            min={{min}}
            max={{max}}
            value={{maxText.current}}
            {{on "input" onMaxInput}}
            {{on "blur" commitMax}}
            {{on "keydown" (onKeydown commitMax)}}
          />
        </label>
      </div>

      <p>Selected: {{range.current}}</p>
    </div>

    <style>
      @scope {
      .price {
        width: 420px;
        margin: 2rem auto;
      }

      .hist {
        display: flex;
        align-items: flex-end;
        gap: 2px;
        height: 84px;
        padding: 0.5rem;
        border: 1px solid #eee;
        border-radius: 8px;
        background: #fafafa;
      }

      .bar-wrap {
        flex: 1;
        display: flex;
        align-items: flex-end;
        height: 100%;
      }

      .bar {
        width: 100%;
        background: #d8d8d8;
        border-radius: 4px 4px 0 0;
      }

      .bar.active {
        background: #1a73e8;
      }

      .ember-primitives__slider {
        color: #1a73e8;
        margin: 1rem 0;
      }

      .ember-primitives__slider__thumb {
        border: 2px solid white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
      }

      .inputs {
        display: flex;
        gap: 1rem;
        justify-content: space-between;
      }

      .inputs label {
        display: grid;
        gap: 0.25rem;
        font-size: 0.85rem;
        color: #333;
      }

      .inputs input {
        width: 10rem;
      }

      p {
        text-align: center;
        font-size: 1.1rem;
        margin-top: 1rem;
      }
      }
    </style>
  </div>
</template>
```

## Install

```hbs live
<SetupInstructions @src="components/slider.gts" />
```

## Features

* Uses native `<input type="range">` behavior for keyboard/pointer interactions
* Supports single or multiple values (range selection)
* Horizontal and vertical orientations
* Customizable min, max, step, and discrete tick values (array `@step`)
* Disabled state
* Structural CSS is included -- you only style the appearance (colors, sizes)
* Default appearance derives from `currentColor` and has zero specificity, so any of your rules override it

## Anatomy

```js 
import { Slider } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Slider } from 'ember-primitives/components/slider';
```

```gjs 
import { Slider } from 'ember-primitives';

<template>
  {{! renders the track, range, and thumb(s) for you }}
  <Slider />

  {{! or compose the pieces yourself }}
  <Slider as |s|>
    <s.Track>
      <s.Range />
      {{#each s.thumbs as |thumb|}}
        <s.Thumb @thumb={{thumb}} aria-label="Value">
          {{! optional: rendered inside the visual thumb (tooltips, etc) }}
        </s.Thumb>
      {{/each}}
    </s.Track>
  </Slider>
</template>
```

Each `<s.Thumb>` renders two elements: an invisible native `<input type="range">` (which receives `...attributes`) and a visual thumb element, positioned along the track for you.

## Styling

Structural CSS ships with the component. It is attached via [`adoptedStyleSheets`](https://developer.mozilla.org/en-US/docs/Web/API/Document/adoptedStyleSheets) on the root the slider renders into, so it also works inside shadow roots. Everything lives in `@layer ember-primitives`, and appearance defaults additionally use `:where()` (zero specificity) and derive from `currentColor` -- any rule you write overrides them, so styling can be as simple as:

```css
.ember-primitives__slider {
  color: rebeccapurple;
  width: 300px;
}
```

The demos on this page each scope their appearance CSS with a prelude-less [`@scope`](https://developer.mozilla.org/en-US/docs/Web/CSS/@scope) block, which scopes rules to the `<style>` tag's parent element -- style isolation without shadow DOM (and without shadow DOM's focus-navigation quirks).

The visual thumb is centered using the CSS `translate` property, so hover/active effects using `scale` or `transform` compose with it instead of clobbering the positioning:

```css
.ember-primitives__slider__thumb-input:hover + .ember-primitives__slider__thumb {
  scale: 1.4;
}
```

### CSS Custom Properties

| property | description |
| :---: | :----------- |
| `--ember-primitives__slider__hit-area` | Size of the pointer target (default `24px`)
| `--ember-primitives__slider__thumb-size` | Size of the visual thumb (default `16px`)
| `--ember-primitives__slider__track-thickness` | Thickness of the rail (default `4px`)
| `--ember-primitives__slider__vertical-size` | Length of a vertical slider (default `10rem`)

## Accessibility

Each thumb is a native `<input type="range">`, so it gets browser keyboard interaction “for free”.

For accessibility, make sure each thumb has an accessible name. For example, pass `aria-label` / `aria-labelledby` via `...attributes` to `<s.Thumb>`. When no block is given to `<Slider>`, default labels are provided (`Value`, or `Minimum` / `Maximum` for a two-thumb range).

### Keyboard Navigation

Keyboard support is provided by the platform (and can vary slightly by browser/OS).

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/slider" 
    @name="Signature" />
</template>
```

### Classes

<br>

#### `<Slider>`

| key | description |  
| :---: | :----------- |  
| `ember-primitives__slider` | Base class for the slider root

#### Data Attributes

| key | description |
| :---: | :----------- |
| `data-orientation` | Set to `"horizontal"` (default) or `"vertical"`
| `data-disabled` | Present when `@disabled={{true}}`
| `data-multi` | Present when the slider has more than one thumb

#### `<Track>`

| key | description |  
| :---: | :----------- |  
| `ember-primitives__slider__track` | Present on the track element

#### `<Range>`

| key | description |  
| :---: | :----------- |  
| `ember-primitives__slider__range` | Present on the range element

#### `<Thumb>`

| key | description |  
| :---: | :----------- |  
| `ember-primitives__slider__thumb-input` | Present on the invisible `<input type="range">` (receives `...attributes`)
| `ember-primitives__slider__thumb` | Present on the visual thumb element (positioned for you; renders the block)
| `data-active` | Present on both elements while the thumb is the most-recently-interacted-with
| `data-disabled` | Present on the visual thumb when the slider is disabled
| `disabled` | Standard HTML attribute on the input when the slider is disabled

## References

- W3 - [Slider Multithumb](https://www.w3.org/WAI/ARIA/apg/patterns/slider-multithumb/)
- CSS Tricks - [Multi Thumb Sliders](https://css-tricks.com/multi-thumb-sliders-particular-two-thumb-case/)
- MDN - [range input](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/range)
- MDN - [Creating vertical form controls](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_writing_modes/Vertical_controls)
- utilitybend Proposal - [rangegroup](https://utilitybend.com/blog/a-native-way-of-having-more-than-one-thumb-on-a-range-slider-in-html)
  - open-ui [enhanced range input](https://open-ui.org/components/enhanced-range-input.explainer/)
