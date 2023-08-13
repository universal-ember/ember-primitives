# Progress

## Examples


<div class="featured-demo">

```gjs live preview
import { Progress } from 'ember-primitives';
import { cell, resource } from 'ember-resources';

function randomPercent() {
  return Math.random() * 100
}

const randomValue = resource(({on}) => {
  let value = cell(randomPercent());
  let interval = setInterval(() => value.current = randomPercent(), 3000);
  on.cleanup(() => clearInterval(interval));

  return value;
}); 

const translate = (v) => -(100 - v);

<template>
  <Progress @value={{(randomValue)}} as |x|>
    <span>{{Math.round x.value}}%</span>
    <x.Indicator style="transform: translateX({{translate x.percent}}%);">
    </x.Indicator>
  </Progress>

  <style>
    [role="progressbar"] {
      margin: 0 auto;
      width: 60%;
      height: 1.5rem;
      border-radius: 0.75rem;
      box-shadow: inset 0px 1px 1px 0px rgba(0,0,0,50%);
      position: relative;
      overflow: hidden;
      background: conic-gradient(at -20% 15%, white 0%, #aaccff 72%);

      /* Fix overflow clipping in Safari
         https://gist.github.com/domske/b66047671c780a238b51c51ffde8d3a0 */
      transform: translateZ(0);
    }
    [role="progressbar"] > div {
      background: conic-gradient(at -20% 15%, blue 0%, transparent 28%, #1e50aa 72%);
      width: 100%;
      height: 100%;
      line-height: 1.5rem;
      border-radius: 1rem;
      transition: transform 660ms cubic-bezier(0.65, 0, 0.35, 1);
    }
    [role="progressbar"] > span {
      line-height: 1.5rem;
      text-align: center;
      width: 100%;
      position: absolute;
      z-index: 1;
    }
  </style>
</template>
```

</div>
