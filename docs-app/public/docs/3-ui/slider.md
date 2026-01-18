# Slider

An input where the user selects a value from within a given range. Inspired by [Radix UI Slider](https://www.radix-ui.com/docs/primitives/components/slider).

<Callout>

Before reaching for this component, consider if the [range `<input>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/range) is sufficient for your use case.

```gjs live preview
// Native HTML range <input>
<template>
  <label>
    Volume
    <input type="range" name="volume" min="0" max="11" />
  </label>

  <style> 
    @scope {
      label { display: flex; gap: 1rem; }
  </style>
</template>
```

  However, if we need a multi-thumb range, _The Platform_ does not have a built in solution for us.

</Callout>

The general recommendation for multi-thumb sliders is to coordinate multiple range inputs. This `<Slider>` component gives you the markup primitives to do that without forcing any styling.

Prefer iterating `s.thumbs` rather than `s.values` so the thumb elements stay stable while the value changes.

<div class="featured-demo">

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell(50);

<template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.thumbs as |thumb|}}
          <s.Thumb @value={{thumb.value}} @index={{thumb.index}} />
        {{/each}}
      </s.Track>
    </Slider>
    
    <p>Value: {{value.current}}</p>

    <style>
      [data-slider] {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 2rem auto;
      }
      
      [data-slider-track] {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
      }
      
      [data-slider-range] {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      [data-slider-thumb] {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 20px;
        margin: 0;
        background: transparent;
        appearance: none;
        -webkit-appearance: none;
        pointer-events: none;
      }

      [data-slider-thumb]::-webkit-slider-runnable-track {
        background: transparent;
        border: 0;
      }

      [data-slider-thumb]::-moz-range-track {
        background: transparent;
        border: 0;
      }

      [data-slider-thumb]::-webkit-slider-thumb {
        pointer-events: auto;
        appearance: none;
        -webkit-appearance: none;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        cursor: pointer;
      }

      [data-slider-thumb]::-moz-range-thumb {
        pointer-events: auto;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        cursor: pointer;
      }
      
      [data-slider-thumb]:focus-visible::-webkit-slider-thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }
      
      [data-slider-thumb][disabled] {
        opacity: 0.5;
        cursor: not-allowed;
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
          <s.Thumb @value={{thumb.value}} @index={{thumb.index}} />
        {{/each}}
      </s.Track>
    </Slider>
    
    <p>Range: {{ (first) }} - {{ (second) }}</p>

    <style>
      [data-slider] {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 2rem auto;
      }
      
      [data-slider-track] {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
      }
      
      [data-slider-range] {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      [data-slider-thumb] {
        position: absolute;
        inset: 0;
        width: 100%;
        height: 20px;
        margin: 0;
        background: transparent;
        appearance: none;
        -webkit-appearance: none;
        z-index: 1;
        pointer-events: none;
      }

      [data-slider-thumb]::-webkit-slider-runnable-track {
        background: transparent;
        border: 0;
      }

      [data-slider-thumb]::-moz-range-track {
        background: transparent;
        border: 0;
      }

      [data-slider-thumb]::-webkit-slider-thumb {
        pointer-events: auto;
        appearance: none;
        -webkit-appearance: none;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        cursor: pointer;
      }

      [data-slider-thumb]::-moz-range-thumb {
        pointer-events: auto;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        cursor: pointer;
      }
      
      [data-slider-thumb]:focus-visible::-webkit-slider-thumb {
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

## Vertical Slider

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell(50);

<template>
  <Shadowed>
    <div style="display: flex; justify-content: center; align-items: center; gap: 2rem;">
      <Slider 
        @value={{value.current}} 
        @onValueChange={{value.set}}
        @orientation="vertical" 
        as |s|>
        <s.Track>
          <s.Range />
          {{#each s.thumbs as |thumb|}}
            <s.Thumb @value={{thumb.value}} @index={{thumb.index}} />
          {{/each}}
        </s.Track>
      </Slider>
      
      <p>Value: {{value.current}}</p>
    </div>

    <style>
      [data-slider][data-orientation="vertical"] {
        position: relative;
        display: flex;
        flex-direction: column;
        align-items: center;
        width: 20px;
        height: 200px;
        margin: 2rem auto;
      }
      
      [data-orientation="vertical"] [data-slider-track] {
        position: relative;
        flex: 1;
        width: 4px;
        background: #ddd;
        border-radius: 2px;
      }
      
      [data-orientation="vertical"] [data-slider-range] {
        position: absolute;
        width: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      [data-orientation="vertical"] [data-slider-thumb] {
        position: absolute;
        inset: 0;
        width: 200px;
        height: 20px;
        margin: 0;
        background: transparent;
        appearance: none;
        -webkit-appearance: none;
        transform-origin: left top;
        transform: rotate(-90deg) translateX(-200px);
        pointer-events: none;
      }

      [data-orientation="vertical"] [data-slider-thumb]::-webkit-slider-runnable-track {
        background: transparent;
        border: 0;
      }

      [data-orientation="vertical"] [data-slider-thumb]::-moz-range-track {
        background: transparent;
        border: 0;
      }

      [data-orientation="vertical"] [data-slider-thumb]::-webkit-slider-thumb {
        pointer-events: auto;
        appearance: none;
        -webkit-appearance: none;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        cursor: pointer;
      }

      [data-orientation="vertical"] [data-slider-thumb]::-moz-range-thumb {
        pointer-events: auto;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 999px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        cursor: pointer;
      }
      
      [data-orientation="vertical"] [data-slider-thumb]:focus-visible::-webkit-slider-thumb {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
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
* Customizable min, max, and step values
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
        <s.Thumb @value={{thumb.value}} @index={{thumb.index}} />
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

### State Attributes

<br>

#### `<Slider>`

| key | description |  
| :---: | :----------- |  
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider
| `data-disabled` | Present when the slider is disabled

#### `<Track>`

| key | description |  
| :---: | :----------- |  
| `data-slider-track` | Present on the track element
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider

#### `<Range>`

| key | description |  
| :---: | :----------- |  
| `data-slider-range` | Present on the range element
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider

#### `<Thumb>`

| key | description |  
| :---: | :----------- |  
| `data-slider-thumb` | Present on the thumb element
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider
| `data-disabled` | Present when the thumb is disabled

## References

- W3 - [Slider Multithumb](https://www.w3.org/WAI/ARIA/apg/patterns/slider-multithumb/)
- CSS Tricks - [Multi Thumb Sliders](https://css-tricks.com/multi-thumb-sliders-particular-two-thumb-case/)
- MDN - [range input](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/input/range)
- utilitybend Proposal - [rangegroup](https://utilitybend.com/blog/a-native-way-of-having-more-than-one-thumb-on-a-range-slider-in-html)
  - open-ui [enhanced range input](https://open-ui.org/components/enhanced-range-input.explainer/)
