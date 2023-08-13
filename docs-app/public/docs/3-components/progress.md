# Progress

## Examples

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

<template>
  <Progress @value={{(randomValue)}} as |x|>
    <x.Indicator style="transform: translateX({{x.negativePercent}}%);">
      {{x.percent}}%
    </x.Indicator>
  </Progress>

  <style>
    [role="progressbar"] {
      margin: 0 auto;
      width: 60%;
      height: 1rem;
      border: 1px solid;
      border-radius: 0.5rem;
      position: relative;
      background: conic-gradient(at -20% 15%, red 0%, transparent 28%, #1e90ff 72%);

      /* Fix overflow clipping in Safari
         https://gist.github.com/domske/b66047671c780a238b51c51ffde8d3a0 */
      transform: translateZ(0);
    }
    [role="progressbar"] > div {
      background: white;
      width: 100%;
      height: 100%;
      text-align: center;
      transition: transform 660ms cubic-bezier(0.65, 0, 0.35, 1);
    }
  </style>
</template>
```
