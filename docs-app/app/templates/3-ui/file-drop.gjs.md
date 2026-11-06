# File Drop

A zone to drop files on, or to click to pick files, and a way to take files dropped anywhere on the page.

`<FileDrop />` and `<DocumentFileDrop />` can be used in any design system.

## Examples

<details open><summary><h3>Drop zone</h3></summary>

```gjs live preview
import { FileDrop } from 'ember-primitives';
import { cell } from 'ember-resources';

const picked = cell('nothing yet');
const show = (files) => (picked.current = files.map((file) => file.name).join(', '));

<template>
  <FileDrop class="drop-zone" @accept="image/*" @multiple={{true}} @onFiles={{show}} as |zone|>
    {{if zone.isDragging "Let go to add the images" "Drop images here, or click to choose"}}
  </FileDrop>

  <p>Picked: {{picked.current}}</p>

  <style>
    .drop-zone {
      display: block;
      padding: 2rem;
      border: 2px dashed;
      border-radius: 0.5rem;
      text-align: center;
      cursor: pointer;
    }
    .drop-zone:focus-within {
      outline: 2px solid;
      outline-offset: 2px;
    }
    .drop-zone[data-dragging] {
      border-style: solid;
      background: color-mix(in srgb, currentColor 10%, transparent);
    }
  </style>
</template>
```

</details>

<details open><summary><h3>Drop anywhere on the page</h3></summary>

Drag a file over any part of this page, then drop it anywhere.

```gjs live preview
import { DocumentFileDrop } from 'ember-primitives';
import { cell } from 'ember-resources';

const dropped = cell('nothing yet');
const show = (files) => (dropped.current = files[0].name);

<template>
  <DocumentFileDrop @onFiles={{show}} as |page|>
    <p class="page-drop" data-dragging={{page.isDragging}}>
      {{if page.isDragging "Drop the file anywhere on the page" "Dropped: "}}
      {{unless page.isDragging dropped.current}}
    </p>
  </DocumentFileDrop>

  <style>
    .page-drop {
      padding: 1rem;
      border: 2px dashed transparent;
      border-radius: 0.5rem;
    }
    .page-drop[data-dragging] {
      border-color: currentColor;
      background: color-mix(in srgb, currentColor 10%, transparent);
    }
  </style>
</template>
```

</details>

## Install

```hbs live
<SetupInstructions @src="components/file-drop.gts" @since="0.64.0" />
```

## Features

* A click or a key press on the zone opens the native file picker
* `@accept` filters drops the same way the file picker does: extensions (`.mkv`), wildcards (`video/*`), and exact types
* `isDragging` does not flicker when the pointer crosses child elements
* A drag of text or links is not a file drag
* The same file can be picked twice in a row
* `<DocumentFileDrop>` keeps the browser from opening a dropped file in the tab
* A drop on a `<FileDrop>` goes only to that `<FileDrop>`, not also to a `<DocumentFileDrop>`

## Anatomy

```js
import { FileDrop, DocumentFileDrop } from 'ember-primitives';
```

or for non-tree-shaking environments:

```js
import { FileDrop, DocumentFileDrop } from 'ember-primitives/components/file-drop';
```

```gjs
import { FileDrop, DocumentFileDrop } from 'ember-primitives';

<template>
  <FileDrop @accept="video/*" @onFiles={{this.load}} as |zone|>
    {{zone.isDragging}}
  </FileDrop>

  <DocumentFileDrop @accept="video/*" @onFiles={{this.load}} as |page|>
    {{page.isDragging}}
  </DocumentFileDrop>
</template>
```

## Accessibility

`<FileDrop>` is a `<label>` for a visually hidden `<input type="file">`.
The input stays in the tab order, and <kbd>Enter</kbd> or <kbd>Space</kbd> opens the file picker.
The text in the zone is the accessible name of the input.

Show focus on the zone with `:focus-within`, because the focused input is hidden.

Drag and drop has no keyboard equivalent, so the file picker is always there as the way to pick files.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/file-drop"
    @name="Signature" />
</template>
```

### `<DocumentFileDrop>`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/file-drop"
    @name="DocumentSignature" />
</template>
```

### Data Attributes

| key | description |
| :---: | :----------- |
| `data-dragging` | On `<FileDrop>`, while files are dragged over it |
