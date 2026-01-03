# Avatar

An image element with a fallback for representing the user.


<div class="featured-demo">

```gjs live preview no-shadow
import { Avatar } from 'ember-primitives';

<template>
  <div class="demo">
    <Avatar class="container" @src="https://avatars.githubusercontent.com/u/199018?v=4" as |a|>
      <a.Image alt="GitHub profile picture of NullVoxPopuli" />
      <a.Fallback>NVP</a.Fallback>
    </Avatar>

    <Avatar class="container" @src="broken URL" as |a|>
      <a.Image alt="GitHub profile picture of NullVoxPopuli" />
      <a.Fallback @delayMs={{600}}>NVP</a.Fallback>
    </Avatar>

    <Avatar class="container" @src="https://static.wikia.nocookie.net/starcraft/images/2/21/CarbotZerglingLevel_SC2_Portrait1.jpg" as |a|>
      <a.Image alt="Zergling" />
      <a.Fallback>Z</a.Fallback>
    </Avatar>

    <Avatar class="container" @src="https://static.wikia.nocookie.net/starcraft/images/b/bc/Vorazun_SC2_Portrait1.jpg" as |a|>
      <a.Image alt="Vorazun's profile picture" />
      <a.Fallback>V</a.Fallback>
    </Avatar>

    <Avatar class="container" @src="https://static.wikia.nocookie.net/starcraft/images/3/34/GhostKerrigan_SC2_Portrait1.jpg" as |a|>
      <a.Image alt="Sarah Kerrigan's profile picture" />
      <a.Fallback>SK</a.Fallback>
    </Avatar>
  </div>

  <style>
    .demo {
      display: flex;
      gap: 1rem;
    }
    .container {
      display: flex;
      height: 4rem;
      width: 4rem;
      border-radius: 1rem;
      overflow: hidden;
      align-items: center;
      place-content: center;
      border: 2px solid #A300DE;

      > img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
  </style>
</template>
```

</div>

## Setup

```hbs live
<SetupInstructions @src="components/avatar.gts" />
```

## Features

* Automatic and manual control over when the image renders.
* Fallback accepts any content.
* Optionally delay fallback rendering to avoid content flashing.

## Anatomy

```js 
import { Avatar } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Avatar } from 'ember-primitives/components/avatar';
```


```gjs 
import { Avatar } from 'ember-primitives';

<template>
  <Avatar @src="..." as |a|>
    <a.Image />
    <a.Fallback>
      any content here
    </a.Fallback>
  </Avatar>
</template>
```

## Accessibility

An `alt` attribute is required, and in development, the UI will show an indication of a missing `alt` value if one is not provided.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/avatar" 
    @name="Avatar" />
</template>
```

### State Attributes

There are state attributes available on the the root element of this component.
These may allow for stateful CSS-only stylings of the Avatar component.

| key | description |  
| :---: | :----------- |  
| `data-loading` | the loading state of the image | 
| `data-error` | will be "true" if the image failed to load | 

