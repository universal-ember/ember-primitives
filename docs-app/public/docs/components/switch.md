# Switch

The Switch component is a user interface element used for toggling between two states, such as on/off or true/false. It consists of a track and a handle that can be interacted with to change the state. The Switch is commonly used in forms, settings screens, and preference panels to control features or settings.

## Examples 

`<Switch />` can be used in any design system.

### Adobe Spectrum

```gjs live preview
import { Shadowed, Switch } from 'ember-primitives';

<template>
  <Shadowed @omitStyles={{true}}>
    <Switch class="spectrum-switch">
      Toggle on or off  
    </Switch>

    <style>
      .spectrum-switch {

      }
    </style>
  </Shadowed>
</template>
```

### Bootstrap

```gjs 
import { Shadowed, Switch } from 'ember-primitives';

<template>
  <Shadowed @omitStyles={{true}}>
    <Switch class="bootstrap-switch">
      Toggle on or off  
    </Switch>

    <style>
      .bootstrap-switch {

      }
    </style>
  </Shadowed>
</template>
```

### Elastic UI

```gjs 
import { Shadowed, Switch } from 'ember-primitives';

<template>
  <Shadowed @omitStyles={{true}}>
    <Switch class="elastic-switch">
      Toggle on or off  
    </Switch>

    <style>
      .elastic-switch {

      }
    </style>
  </Shadowed>
</template>
```

### Dark/Light Theme Toggle 

```gjs 
import { Shadowed, Switch } from 'ember-primitives';

<template>
  <Shadowed @omitStyles={{true}}>
    <Switch class="theme-switch">
      Toggle on or off  
    </Switch>

    <style>
      .theme-switch {

      }
    </style>
  </Shadowed>
</template>
```
