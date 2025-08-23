# PortalTargets

The portal targets are stable element references that can be nested over and over again to get around layering issues. 

For example, given a z-index order like 
 - `1` popover
 - `2` tooltip
 - `3` modal

 What happens if you want to display a tooltip within a modal?
 Normally this would end up rendering behind the modal, but since `<PortalTargets />` can be used multiple times, anything that is targeting a particular portal will render in to the nearest portal target within the render tree, thus eliminating all layering issues.


The following example proposes a potential series of features that would benefit from this behavior.

```gjs 
import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { PortalTargets, /* Portal, PORTALS */ } from 'ember-primitives';

const isOpen = cell(false);

<template>
  {{! Application-level targets }}
  <PortalTargets />

  <button {{on 'click' isOpen.toggle}}>
    Toggle
    <Tooltip> {{! uses <Portal @to={{PORTALS.tooltip}}> }}
      Toggles the modal state
    </Tooltip>
  </button>

  {{#if isOpen.current}}
    <Modal> {{! uses <Portal @to={{PORTALS.modal}}> }}
      <:body>
        <PortalTargets />

        <p>
          this is some text
          <Tooltip> {{! uses <Portal @to={{PORTALS.tooltip}}> }}
            This is still positioned above the Modal
            because the nearest portal targets are within the modal.
          </Tooltip>
        </p>
      </:body>
    </Modal>
  {{/if}}
</template>
 ```


## Anatomy

```js 
import { PortalTargets } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { PortalTargets } from 'ember-primitives/components/portal-targets';
```

```gjs 
import { PortalTargets } from 'ember-primitives/components/portal-targets';

<template>
  <PortalTargets />
</template>
```

## API Reference

### `PortalTargets`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/portal-targets" 
    @name="Signature" 
  />
</template>
```

### `PortalTarget`

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/portal-targets" 
    @name="PortalTarget" 
  />
</template>
```
