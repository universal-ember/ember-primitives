# Key and KeyCombo

Provides the markup necessary to render keyboard shortcuts and hotkeys and other keyboard interactions. The primary behavior on top of the native [`<kbd>`][mdn-kbd] element is automatic adding of the `+` symbol for multiple keys, as well as handling of macOS vs non-macOS shortcut variances.

[mdn-kbd]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd

<div class="featured-demo">

```gjs live preview
import { Key, KeyCombo } from 'ember-primitives';

<template>
  A single key:
  <Key>a</Key>
  <br><br>
  A combination of keys: 
  <KeyCombo @keys="ctrl+a" @mac="cmd+a" />

  <style>
    kbd {
      background-color: #eee;
      border-radius: 3px;
      border: 1px solid #b4b4b4;
      box-shadow:
        0 1px 1px rgba(0, 0, 0, 0.2),
        0 2px 0 0 rgba(255, 255, 255, 0.7) inset;
      color: #333;
      display: inline-block;
      font-size: 0.85em;
      font-weight: 700;
      line-height: 1;
      padding: 2px 4px;
      white-space: nowrap;
      /* CSS from https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd */
    } 
  </style>
</template>
```

</div>

## Features

* Handling of auto-switching the display combination based on viewing operating system (macOS vs non-macOS)
* Accepts array of keys, or `+`-separated string

## Anatomy

```js 
import { Key, KeyCombo } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Key, KeyCombo } from 'ember-primitives/components/progress';
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

### Classes
