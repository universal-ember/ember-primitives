# Avatar

An image element with a fallback for representing the user.


<div class="featured-demo">

```gjs live preview no-shadow
import { Avatar } from 'ember-primitives';

<template>
  <div class="demo">
    <Avatar class="avatar" @src="https://avatars.githubusercontent.com/u/199018?v=4" as |a|>
      <a.Image alt="NullVoxPopuli" />
      <a.Fallback>NV</a.Fallback>
    </Avatar>

    <Avatar class="avatar" @src="broken-url" as |a|>
      <a.Image alt="Broken image" />
      <a.Fallback @delayMs={{400}}>FB</a.Fallback>
    </Avatar>

    <Avatar class="avatar" @src="https://avatars.githubusercontent.com/u/810438?v=4" as |a|>
      <a.Image alt="Example user" />
      <a.Fallback>EX</a.Fallback>
    </Avatar>
  </div>

  <style>
    .demo {
      display: flex;
      gap: 0.85rem;
      align-items: center;
    }

    .avatar {
      display: grid;
      place-items: center;
      width: 3rem;
      height: 3rem;
      overflow: hidden;
      border-radius: 999px;
      border: 1px solid var(--doc-border);
      background: var(--doc-bg);
      color: var(--doc-text-2);
      font-family: var(--font-sans);
      font-size: 0.75rem;
      font-weight: 600;
    }

    .avatar img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }
  </style>
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/avatar.gts" @since="0.7.0" />
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

