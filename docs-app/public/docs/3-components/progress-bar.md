# ProgressBar

## Examples


<div class="featured-demo">

```gjs live preview
import { ProgressBar } from 'ember-primitives';
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
  <ProgressBar @value={{(randomValue)}} as |x|>
    <span>{{Math.round x.value}}%</span>
    <x.Indicator style="transform: translateX({{translate x.percent}}%);">
    </x.Indicator>
  </ProgressBar>

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
      transition: transform 660ms cubic-bezier(0.65, 0, 0.35, 1);
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
