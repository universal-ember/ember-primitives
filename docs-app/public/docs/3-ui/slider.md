# Slider

An input where the user selects a value from within a given range. Inspired by [Radix UI Slider](https://www.radix-ui.com/docs/primitives/components/slider).

<Callout>

Before reaching for this component, consider if the [range `<input>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/range) is sufficient for your use case.

```gjs live
import { Shadowed } from 'ember-primitives';

// Native HTML range <input>
<template>
  <Shadowed>
    <label class="native-range">
      <span>Volume</span>
      <input type="range" name="volume" min="0" max="11" />
    </label>

    <style>
      .native-range {
        display: flex;
        align-items: center;
        gap: 1rem;
      }
    </style>
  </Shadowed>
</template>
```

</Callout>


<div class="not-prose">

```gjs live
import { Gallery } from '#public/3-ui/slider/gallery';

<template>
  <Gallery />
</template>
```

</div>

## Range Slider

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell([25, 75]);
const first = () => value.current[0];
const second = () => value.current[1];

<template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <div class="thumb-layer {{if thumb.active 'is-active'}}">
            <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label="Value" />
            <div class="thumb" style="left: {{thumb.percent}}%;" aria-hidden="true" />
          </div>
        {{/each}}
      </s.Track>
    </Slider>
    
    <p>Range: {{ (first) }} - {{ (second) }}</p>

    <style>
      .ember-primitives__slider {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 2rem auto;
      }
      
      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }
      
      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      .thumb-layer {
        position: absolute;
        inset: 0;
        z-index: 1;
      }

      .thumb-layer.is-active {
        z-index: 3;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 20px;
        margin: 0;
        opacity: 0;
        background: transparent;
        cursor: pointer;
        appearance: none;
        /* Multiple full-width range inputs overlap.
           The active layer is raised via z-index.
        */
        pointer-events: none;
      }

      .thumb-layer input[type="range"]::-webkit-slider-thumb {
        pointer-events: auto;
        cursor: pointer;
      }

      .thumb-layer input[type="range"]::-moz-range-thumb {
        pointer-events: auto;
        cursor: pointer;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer:hover input[type="range"] + .thumb,
      .thumb-layer input[type="range"]:focus + .thumb,
      .thumb-layer input[type="range"]:focus-within + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb,
      .thumb-layer input[type="range"]:active + .thumb {
        --thumb-scale: 1.45;
      }

      .thumb-layer input[type="range"]:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }
      
      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 2rem;
      }
    </style>
  </Shadowed>
</template>
```

## Discrete Values

When you want “ticks”, you typically want the slider to snap to a discrete set of values.

Pass an array to `@step`.

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const tickValues = [0, 10, 20, 30, 40, 50];
const value = cell(20);
const percentAt = (index) => (index / (tickValues.length - 1)) * 100;

<template>
  <Shadowed>
    <Slider @value={{value.current}} @step={{tickValues}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <div class="thumb-layer">
            <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label="Value" />
            <div class="thumb" style="left: {{thumb.percent}}%;" aria-hidden="true" />
          </div>
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
      .ember-primitives__slider {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 2rem auto 0.5rem;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-layer {
        position: absolute;
        inset: 0;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 20px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
        pointer-events: none;
      }

      .thumb-layer input[type="range"]::-webkit-slider-thumb {
        pointer-events: auto;
        cursor: pointer;
      }

      .thumb-layer input[type="range"]::-moz-range-thumb {
        pointer-events: auto;
        cursor: pointer;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer input[type="range"]:focus + .thumb,
      .thumb-layer input[type="range"]:focus-within + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb,
      .thumb-layer input[type="range"]:active + .thumb {
        --thumb-scale: 1.45;
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
    </style>
  </Shadowed>
</template>
```

## Slider With Tooltip (Composed)

The primitive yields `thumb.percent`, which is useful for positioning a tooltip/label.

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell([25, 75]);

<template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb
            @value={{thumb.inputValue}}
            @index={{thumb.index}}
            class="thumb-input {{if thumb.active 'is-active'}}"
            aria-label="Value"
          />
          <div class="thumb {{if thumb.active 'is-active'}}" style="left: {{thumb.percent}}%;" aria-hidden="true" />
          <output class="tooltip" style="left: {{thumb.percent}}%;">
            {{thumb.value}}
          </output>
        {{/each}}
      </s.Track>
    </Slider>

    <p>Range: {{value.current}}</p>

    <style>
      .ember-primitives__slider {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 32px;
        margin: 2rem auto;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-input {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 32px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
        z-index: 1;
        pointer-events: none;
      }

      .thumb-input::-webkit-slider-thumb {
        pointer-events: auto;
        cursor: pointer;
      }

      .thumb-input::-moz-range-thumb {
        pointer-events: auto;
        cursor: pointer;
      }

      .thumb-input.is-active {
        z-index: 10;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        z-index: 2;
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb.is-active {
        z-index: 11;
      }

      .thumb-input:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }

      .thumb-input:hover + .thumb,
      .thumb-input:focus + .thumb,
      .thumb-input:focus-within + .thumb,
      .thumb-input:focus-visible + .thumb,
      .thumb-input:active + .thumb {
        --thumb-scale: 1.45;
      }

      .tooltip {
        position: absolute;
        top: 50%;
        transform: translate(-50%, calc(-100% - 16px));
        background: #111;
        color: white;
        font-size: 0.75rem;
        line-height: 1;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        white-space: nowrap;
        user-select: none;
        pointer-events: none;
        z-index: 20;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 2rem;
      }
    </style>
  </Shadowed>
</template>
```

## Slider With Labels

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell(50);

<template>
  <Shadowed>
    <div class="labels" aria-hidden="true">
      <span>Low</span>
      <span>High</span>
    </div>

    <Slider @value={{value.current}} @onValueChange={{value.set}} @step={{10}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <div class="thumb-layer">
            <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label="Value" />
            <div class="thumb" style="left: {{thumb.percent}}%;" aria-hidden="true" />
          </div>
        {{/each}}
      </s.Track>
    </Slider>

    <p>Value: {{value.current}}</p>

    <style>
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
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 0 auto;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-layer {
        position: absolute;
        inset: 0;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 20px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer input[type="range"]:focus + .thumb,
      .thumb-layer input[type="range"]:focus-within + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb,
      .thumb-layer input[type="range"]:active + .thumb {
        --thumb-scale: 1.45;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 0.75rem;
      }
    </style>
  </Shadowed>
</template>
```

## Slider With Input

This pattern keeps an `<input>` in sync with the slider, while letting users type and “commit” on blur / Enter.

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
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
  <Shadowed>
    <div class="row">
      <Slider @value={{value.current}} @onValueChange={{onSliderChange}} @min={{min}} @max={{max}} as |s|>
        <s.Track>
          <s.Range />
          {{#each s.thumbs as |thumb|}}
            <div class="thumb-layer">
              <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label="Value" />
              <div class="thumb" style="left: {{thumb.percent}}%;" aria-hidden="true" />
            </div>
          {{/each}}
        </s.Track>
      </Slider>

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
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 0;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-layer {
        position: absolute;
        inset: 0;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 20px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb {
        --thumb-scale: 1.45;
      }

      .thumb-layer input[type="range"]:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }
    </style>
  </Shadowed>
</template>
```

## Dual Range Slider With Input

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
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
  <Shadowed>
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
            <div class="thumb-layer {{if thumb.active 'is-active'}}">
              <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label="Value" />
              <div class="thumb" style="left: {{thumb.percent}}%;" aria-hidden="true" />
            </div>
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
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 0;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-layer {
        position: absolute;
        inset: 0;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 20px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
        pointer-events: auto;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer:hover input[type="range"] + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb {
        --thumb-scale: 1.45;
      }

      .thumb-layer input[type="range"]:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 0;
      }
    </style>
  </Shadowed>
</template>
```

## Slider With Multiple Thumbs

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell([25, 50, 75]);

<template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <s.Thumb
            @value={{thumb.inputValue}}
            @index={{thumb.index}}
            class="thumb-input {{if thumb.active 'is-active'}}"
            aria-label="Value"
          />
          <div class="thumb {{if thumb.active 'is-active'}}" style="left: {{thumb.percent}}%;" aria-hidden="true" />
          <output class="tooltip" style="left: {{thumb.percent}}%;">{{thumb.value}}%</output>
        {{/each}}
      </s.Track>
    </Slider>

    <p>Values: {{value.current}}</p>

    <style>
      .ember-primitives__slider {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 32px;
        margin: 2rem auto;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-input {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 32px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
        z-index: 1;
        pointer-events: auto;
      }

      .thumb-input.is-active {
        z-index: 10;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 6px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        z-index: 2;
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb.is-active {
        z-index: 11;
      }

      .thumb-input:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }

      .thumb-input:hover + .thumb,
      .thumb-input:focus-visible + .thumb {
        --thumb-scale: 1.45;
      }

      .tooltip {
        position: absolute;
        top: 50%;
        transform: translate(-50%, calc(-100% - 16px));
        background: #111;
        color: white;
        font-size: 0.75rem;
        line-height: 1;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        white-space: nowrap;
        user-select: none;
        pointer-events: none;
        z-index: 20;
      }

      p {
        text-align: center;
        font-size: 1.2rem;
        margin-top: 2rem;
      }
    </style>
  </Shadowed>
</template>
```

## Equalizer

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
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
  <Shadowed>
    <div class="equalizer" role="group" aria-label="Equalizer">
      {{#each bands as |band|}}
        <div class="band">
          <div class="slider-wrap">
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
                  <div class="thumb-layer">
                    <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label={{band.label}} />
                    <div class="thumb" style="bottom: {{thumb.percent}}%;" aria-hidden="true" />
                  </div>
                  <output class="tooltip" style="bottom: {{thumb.percent}}%;">{{thumb.value}}</output>
                {{/each}}
              </s.Track>
            </Slider>
          </div>
          <div class="band-label" aria-hidden="true">{{band.label}}</div>
        </div>
      {{/each}}
    </div>

    <style>
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

      .slider-wrap {
        position: relative;
        height: 200px;
        width: 24px;
      }

      .ember-primitives__slider--vertical {
        position: absolute;
        inset: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 24px;
        height: 200px;
        margin: 0;
      }

      .ember-primitives__slider--vertical .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        width: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider--vertical .ember-primitives__slider__range {
        position: absolute;
        width: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-layer {
        position: absolute;
        inset: 0;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        inset: 0;
        width: 200px;
        height: 24px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        transform-origin: left top;
        transform: rotate(-90deg) translateX(-200px);
        cursor: pointer;
      }

      .thumb {
        position: absolute;
        left: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, 50%) scale(var(--thumb-scale));
        width: 16px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 6px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb  {
        --thumb-scale: 1.45;
      }

      .tooltip {
        position: absolute;
        left: 50%;
        transform: translate(-50%, 50%);
        background: #111;
        color: white;
        font-size: 0.75rem;
        padding: 0.15rem 0.35rem;
        border-radius: 0.25rem;
        pointer-events: none;
        z-index: 1;
        white-space: nowrap;
        font-variant-numeric: tabular-nums;
        min-width: 2ch;
        text-align: center;
      }
    </style>
  </Shadowed>
</template>
```

## Price Slider (Histogram + Range)

This demonstrates composing a “price slider” UI (histogram + dual-range selection + inputs) on top of the primitive.

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
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
  <Shadowed>
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
            <div class="thumb-layer {{if thumb.active 'is-active'}}">
              <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} aria-label="Price" />
              <div class="thumb" style="left: {{thumb.percent}}%;" aria-hidden="true" />
            </div>
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
        position: relative;
        display: flex;
        align-items: center;
        width: 100%;
        height: 20px;
        margin: 1rem 0;
      }

      .ember-primitives__slider__track {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
        overflow: visible;
      }

      .ember-primitives__slider__range {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }

      .thumb-layer {
        position: absolute;
        inset: 0;
        z-index: 1;
      }

      .thumb-layer.is-active {
        z-index: 3;
      }

      .thumb-layer input[type="range"] {
        position: absolute;
        left: 0;
        right: 0;
        top: 50%;
        transform: translateY(-50%);
        width: 100%;
        height: 20px;
        margin: 0;
        opacity: 0;
        appearance: none;
        background: transparent;
        cursor: pointer;
        pointer-events: auto;
      }

      .thumb {
        position: absolute;
        top: 50%;
        --thumb-scale: 1;
        transform-origin: 50% 50%;
        transform: translate(-50%, -50%) scale(var(--thumb-scale));
        width: 18px;
        height: 18px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        pointer-events: none;
        transition: transform 120ms ease;
      }

      .thumb-layer input[type="range"]:focus-visible + .thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }

      .thumb-layer input[type="range"]:hover + .thumb,
      .thumb-layer:hover input[type="range"] + .thumb,
      .thumb-layer input[type="range"]:focus-visible + .thumb {
        --thumb-scale: 1.45;
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
    </style>
  </Shadowed>
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
* Styleless primitives (you provide CSS)

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
  <Slider as |s|>
    <s.Track>
      <s.Range />
      {{#each s.thumbs as |thumb|}}
        <s.Thumb @value={{thumb.inputValue}} @index={{thumb.index}} />
      {{/each}}
    </s.Track>
  </Slider>
</template>
```

## Accessibility

Each thumb is a native `<input type="range">`, so it gets browser keyboard interaction “for free”.

For accessibility, make sure each thumb has an accessible name. For example, pass `aria-label` / `aria-labelledby` via `...attributes` to `<s.Thumb>`.

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
| `ember-primitives__slider--horizontal` | Present when `@orientation="horizontal"` (default)
| `ember-primitives__slider--vertical` | Present when `@orientation="vertical"`
| `ember-primitives__slider--disabled` | Present when `@disabled={{true}}`

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
| `ember-primitives__slider__thumb` | Present on each thumb `<input type="range">`
| `disabled` | Standard HTML attribute when the thumb is disabled

## References

- W3 - [Slider Multithumb](https://www.w3.org/WAI/ARIA/apg/patterns/slider-multithumb/)
- CSS Tricks - [Multi Thumb Sliders](https://css-tricks.com/multi-thumb-sliders-particular-two-thumb-case/)
- MDN - [range input](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/range)
- utilitybend Proposal - [rangegroup](https://utilitybend.com/blog/a-native-way-of-having-more-than-one-thumb-on-a-range-slider-in-html)
  - open-ui [enhanced range input](https://open-ui.org/components/enhanced-range-input.explainer/)
