# Link

```gjs live no-shadow
import { CommentQuery } from 'docs-app/docs-support';

<template>
  <CommentQuery @module="components/link" @name="Link" />
</template>
```

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


```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/link" @name="Signature" />
</template>
```
