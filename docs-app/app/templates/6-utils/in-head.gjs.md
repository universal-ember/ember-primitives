# In Head

Utility component to place elements in the document `<head>`

The component will appropriate clean up the `<head>` when unrendered.

## Example

```gjs live preview no-shadow
import { InHead } from 'ember-primitives/head';
import { tracked } from '@glimmer/tracking';

// This changes the styles of the whole site
const useBootstrap = tracked(false);
const toggleBootstrap = () => useBootstrap.update((use) => !use);

<template>
  <button 
    onclick={{toggleBootstrap}}
    type="button" class="btn btn-primary">Toggle Bootstrap</button>
  &nbsp;
  <button 
    onclick={{toggleBootstrap}}
    type="button" class="btn btn-success">Toogle Bootstrap</button>

  {{#if useBootstrap.value}}
    <InHead>
      <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/js/bootstrap.bundle.min.js"></script>
      <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css">
    </InHead>
  {{/if}}
</template>
```



## Install

```hbs live
<SetupInstructions @src="head.gts" @since="0.35.0" />
```

