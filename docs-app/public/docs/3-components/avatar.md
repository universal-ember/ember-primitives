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

      img {
        width: 100%;
        height: 100%;
        object-fit: contain;
      }
    }
  </style>
</template>
```

</div>

## Examples

* Automatic and manual control over when the image renders.
* Fallback accepts any content.
* Optionally delay fallback rendering to avoid content flashing.

### Clickable Avatar with tooltip

```gjs

```

## Features

## Installation

```bash
pnpm add ember-primitives
```

## Anatomy

## Accessibility

An `alt` attribute is required, and in development, the UI will show an indication of a missing `alt` value if one is not provided.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/avatar" @name="Avatar" />
</template>
```

### State Attributes

TODO
