# Switch

The Switch component is a user interface element used for toggling between two states, such as on/off or true/false. It consists of a track and a handle that can be interacted with to change the state. The Switch is commonly used in forms, settings screens, and preference panels to control features or settings.

## Examples

`<Switch />` can be used in any design system.

### Adobe Spectrum

```gjs live preview
import { Switch } from 'ember-primitives';

<template>
  <Switch class="spectrum-switch">
    Toggle on or off
  </Switch>

  <style>
    .spectrum-switch {

    }
  </style>
</template>
```

### Bootstrap

```gjs live preview
import { Switch } from 'ember-primitives';

<template>
  <Switch class="bootstrap-switch">
    Toggle on or off
  </Switch>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-KK94CHFLLe+nY2dmCWGMq91rCGa5gtU4mk92HdvYe+M/SXH301p5ILy+dN9+nJOZ" crossorigin="anonymous">
</template>
```

### Dark/Light Theme Toggle

```gjs
import { Switch } from 'ember-primitives';

<template>
  <Switch class="theme-switch">
    Toggle on or off
  </Switch>

  <style>
    .theme-switch {

    }
  </style>
</template>
```
