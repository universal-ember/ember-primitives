# Link

```gjs live
import { Comment } from '#src/api-docs';

<template>
  <Comment @name="Link" @declaration="components/link" />
</template>
```

<Callout>

Most of the time, for in-app navigations especially, you'll want to use the [native `<a>`][mdn-a] element.

However, for consistent usage and behavior within a design system, it'll be beneficial to lint against `<a>`, and use a design-system-provided version of `<Link />`, which wraps _this_ `<Link />`.

</Callout>

The `<Link />` component provides additional behavior and utilities for styling and providing additional context, such as within `<nav>` or other UI patterns which persist across multiple page navigations.

`<Link />` will automatically externalize a `href` which specify different domains (add `target='_blank'` and `rel='noreferrer noopener'`)



[mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a

## Example


```gjs live preview
import { Link } from 'ember-primitives';

<template>
  <Link @href="/">Home</Link>  &nbsp;&nbsp;

  <Link @href="https://developer.mozilla.org" as |a|>
    MDN

    {{#if a.isExternal}}
      ➚
    {{/if}}
  </Link>
</template>
```

## Install

```hbs live
<SetupInstructions @src="components/link.gts" />
```

## Features

* Full keyboard navigation
* Active state
* "Just an `<a>`" 

## Anatomy

_requires usage of [`@properLinks`](/4-routing/proper-links)_


```js 
import { Link } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Link } from 'ember-primitives/components/link';
```


```gjs 
import { Link } from 'ember-primitives';

<template>
  <Link @href="..." as |a|>
    {{if a.isActive "active!"}}
    {{if a.isExternal "external!"}}
  </Link>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/link" 
    @name="Signature" />
</template>
```

### State Attributes


| key | description |  
| :---: | :----------- |  
| data-active | attribute will be "true" or "false", depending on if the `@href` matches the current URL |  

<br>

```gjs live preview
import { Link } from 'ember-primitives';

<template>
  <style>
    @scope {
      [data-active] {
        color: red;
      }
      a { padding: 0.25rem 0.5rem; }
    }
  </style>

  <Link @href="/4-routing/link" as |a|>
    This page
  </Link>
  |
  <Link @href="/4-routing/proper-links" as |a|>
    Related page
  </Link>
</template>
```


