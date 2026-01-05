# Slider

An input where the user selects a value from within a given range. Inspired by [Radix UI Slider](https://www.radix-ui.com/docs/primitives/components/slider).

<div class="featured-demo">

```gjs live preview
import { Slider, Shadowed } from 'ember-primitives';
import { cell } from 'ember-resources';

const value = cell(50);

<template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{fn (mut value.current)}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.values as |v index|}}
          <s.Thumb @value={{v}} @index={{index}} />
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
      
      [role="presentation"] {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
      }
      
      [role="presentation"] > span {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      [role="slider"] {
        display: block;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 50%;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        position: absolute;
        transform: translateX(-50%);
        cursor: pointer;
      }
      
      [role="slider"]:focus {
        outline: 2px solid #1a73e8;
        outline-offset: 2px;
      }
      
      [role="slider"][aria-disabled="true"] {
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

<template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{fn (mut value.current)}} as |s|>
      <s.Track>
        <s.Range />
        {{#each s.values as |v index|}}
          <s.Thumb @value={{v}} @index={{index}} />
        {{/each}}
      </s.Track>
    </Slider>
    
    <p>Range: {{get value.current 0}} - {{get value.current 1}}</p>

    <style>
      [data-slider] {
        position: relative;
        display: flex;
        align-items: center;
        width: 300px;
        height: 20px;
        margin: 2rem auto;
      }
      
      [role="presentation"] {
        position: relative;
        flex: 1;
        height: 4px;
        background: #ddd;
        border-radius: 2px;
      }
      
      [role="presentation"] > span {
        position: absolute;
        height: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      [role="slider"] {
        display: block;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 50%;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        position: absolute;
        transform: translateX(-50%);
        cursor: pointer;
        z-index: 1;
      }
      
      [role="slider"]:focus {
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
        @onValueChange={{fn (mut value.current)}}
        @orientation="vertical" 
        as |s|>
        <s.Track>
          <s.Range />
          {{#each s.values as |v index|}}
            <s.Thumb @value={{v}} @index={{index}} />
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
      
      [data-orientation="vertical"] [role="presentation"] {
        position: relative;
        flex: 1;
        width: 4px;
        background: #ddd;
        border-radius: 2px;
      }
      
      [data-orientation="vertical"] [role="presentation"] > span {
        position: absolute;
        width: 100%;
        background: #1a73e8;
        border-radius: 2px;
      }
      
      [data-orientation="vertical"] [role="slider"] {
        display: block;
        width: 20px;
        height: 20px;
        background: #1a73e8;
        border: 2px solid white;
        border-radius: 50%;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        position: absolute;
        transform: translateY(50%);
        cursor: pointer;
      }
      
      [data-orientation="vertical"] [role="slider"]:focus {
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

* Full keyboard navigation (Arrow keys, Home, End, Page Up/Down)
* Supports single or multiple values (range selection)
* Horizontal and vertical orientations
* Customizable min, max, and step values
* Disabled state
* Provides context for assistive technology

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
      {{#each s.values as |value index|}}
        <s.Thumb @value={{value}} @index={{index}} />
      {{/each}}
    </s.Track>
  </Slider>
</template>
```

## Accessibility

Adheres to the [`slider` role requirements](https://www.w3.org/WAI/ARIA/apg/patterns/slider).

### Keyboard Navigation

| Key | Description |
| :---: | :----------- |
| `ArrowLeft` / `ArrowDown` | Decreases the value by one step |
| `ArrowRight` / `ArrowUp` | Increases the value by one step |
| `Home` | Sets the value to its minimum |
| `End` | Sets the value to its maximum |
| `PageDown` | Decreases the value by 10 steps |
| `PageUp` | Increases the value by 10 steps |

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
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider

#### `<Range>`

| key | description |  
| :---: | :----------- |  
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider

#### `<Thumb>`

| key | description |  
| :---: | :----------- |  
| `data-orientation` | `'horizontal' \| 'vertical'` - The orientation of the slider
| `data-disabled` | Present when the thumb is disabled
