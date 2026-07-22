# Key and KeyCombo

Provides the markup necessary to render keyboard shortcuts and hotkeys and other keyboard interactions. The primary behavior on top of the native [`<kbd>`][mdn-kbd] element is automatic adding of the `+` symbol for multiple keys, as well as handling of macOS vs non-macOS shortcut variances.

[mdn-kbd]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd

<div class="featured-demo">

```gjs live preview
import { Key, KeyCombo } from 'ember-primitives';

<template>
  <div class="keys-demo">
    <p>
      Single key:
      <Key>A</Key>
    </p>
    <p>
      Shortcut:
      <KeyCombo @keys="ctrl+a" @mac="cmd+a" />
    </p>
  </div>

  <style>
    .keys-demo {
      display: grid;
      gap: 0.85rem;
      font-family: var(--font-sans);
      font-size: 0.9375rem;
      color: var(--doc-text-2);
    }

    .keys-demo p {
      margin: 0;
      display: flex;
      align-items: center;
      gap: 0.55rem;
    }

    kbd {
      display: inline-flex;
      align-items: center;
      min-height: 1.5rem;
      padding: 0.15rem 0.45rem;
      border: 1px solid var(--doc-border);
      border-radius: 0.35rem;
      background: var(--doc-bg);
      box-shadow: 0 1px 0 var(--doc-border);
      color: var(--doc-text-1);
      font-family: var(--font-sans);
      font-size: 0.8125rem;
      font-weight: 500;
      line-height: 1;
    }
  </style>
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/keys.gts" @since="0.28.0" />
```

## Features

* Handling of auto-switching the display combination based on viewing operating system (macOS vs non-macOS)
* Accepts array of keys, or `+`-separated string

## Anatomy

```js 
import { Key, KeyCombo } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Key, KeyCombo } from 'ember-primitives/components/keys';
```


```gjs 
import { Key, KeyCombo } from 'ember-primitives';

<template>
    <Key>ctrl</Key>
    <Key>anything here</Key>

    <KeyCombo @key="ctrl+x" />
    <KeyCombo @key="ctrl+x" @mac="command+x" />
    <KeyCombo @key={{array "ctrl" "x"}} @mac={{array "command" "x"}} />
</template>
```

## Accessibilty

This is an extremely thin wrapper around [`kbd`][mdn-kbd], so accessibility is the same as native.

## API Reference

There are two components in this module

### `<KeyCombo>`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/keys" 
    @name="KeyComboSignature" />
</template>
```

#### KeyCombo Classes

For styling with a stylesheet

- `ember-primitives__key-combination`
- `ember-primitives__key-combination__separator`

<section>

### `<Key>`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/keys" 
    @name="KeySignature" />
</template>
```

#### Key Classes

For styling with a stylesheet

- `ember-primitives__key`


</section>
