# Switch

The Switch component is a user interface element used for toggling between two states, such as on/off or true/false. It consists of a track and a handle that can be interacted with to change the state. The Switch is commonly used in forms, settings screens, and preference panels to control features or settings.

## Examples

`<Switch />` can be used in any design system.

<details open><summary><h3>Bootstrap</h3></summary>

See [Bootstrap Switch](https://getbootstrap.com/docs/5.3/forms/checks-radios/#switches) docs.

```gjs live preview
import { Switch } from 'ember-primitives';

<template>
  <div class="p-4">
    <Switch class="form-check form-switch" as |s|>
      <s.Control class="form-check-input" />
      <s.Label class="form-check-label">
        Toggle on or off
      </s.Label>
    </Switch>
  </div>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
</template>
```

</details>

<details open><summary><h3>Dark/Light Theme Toggle</h3></summary>

CSS inspired/taken from [this Codepen](https://codepen.io/Umer_Farooq/pen/eYJgKGN?editors=1100)

```gjs live preview
import { Switch } from 'ember-primitives';
import { on } from '@ember/modifier';

const toggleTheme = (e) =>
  e.target.closest('div').classList.toggle("dark");

<template>
  <Switch as |s|>
    <s.Control {{on 'change' toggleTheme}} />
    <s.Label>
      <span class="sr-only">Toggle between light and dark mode</span>
      <Moon />
      <Sun />
      <span class="ball"></span>
    </s.Label>
  </Switch>

  <style>
    @import url("https://fonts.googleapis.com/css2?family=Montserrat&display=swap");

    * {box-sizing: border-box;}

    div {
      padding: 1rem;
      font-family: "Montserrat", sans-serif;
      background-color: #eee;
      display: flex;
      justify-content: center;
      align-items: center;
      flex-direction: column;
      text-align: center;
      margin: 0;
      transition: background 0.2s linear;
    }

    div.dark {background-color: #292c35;}
    div.dark label { background-color: #9b59b6; }


    input[type='checkbox'][role='switch'] {
      opacity: 0;
      position: absolute;
    }

    .sr-only {
      width: 0px;
      max-width: 0px;
      height: 0px;
      max-height: 0px;
      overflow: hidden;
      margin-left: -0.5rem;
    }

    label {
      background-color: #111;
      width: 50px;
      height: 26px;
      border-radius: 50px;
      position: relative;
      padding: 5px;
      cursor: pointer;
      display: flex;
      justify-content: space-between;
      align-items: center;
      gap: 0.5rem;
    }

    svg { fill: currentColor; }
    .fa-moon { color: #f1c40f; }
    .fa-sun { color: #f39c12; }

    label .ball {
      background-color: #fff;
      width: 22px;
      height: 22px;
      position: absolute;
      left: 2px;
      top: 2px;
      border-radius: 50%;
      transition: transform 0.2s linear;
    }

    input[type='checkbox'][role='switch']:checked + label .ball {
      transform: translateX(24px);
    }

  </style>
</template>

// 🎵 It's raining, it's pouring, ... 🎵
// https://www.youtube.com/watch?v=ll5ykbAumD4
const Sun = <template>
  <svg class="fa-sun" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">{{!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --}}<path d="M361.5 1.2c5 2.1 8.6 6.6 9.6 11.9L391 121l107.9 19.8c5.3 1 9.8 4.6 11.9 9.6s1.5 10.7-1.6 15.2L446.9 256l62.3 90.3c3.1 4.5 3.7 10.2 1.6 15.2s-6.6 8.6-11.9 9.6L391 391 371.1 498.9c-1 5.3-4.6 9.8-9.6 11.9s-10.7 1.5-15.2-1.6L256 446.9l-90.3 62.3c-4.5 3.1-10.2 3.7-15.2 1.6s-8.6-6.6-9.6-11.9L121 391 13.1 371.1c-5.3-1-9.8-4.6-11.9-9.6s-1.5-10.7 1.6-15.2L65.1 256 2.8 165.7c-3.1-4.5-3.7-10.2-1.6-15.2s6.6-8.6 11.9-9.6L121 121 140.9 13.1c1-5.3 4.6-9.8 9.6-11.9s10.7-1.5 15.2 1.6L256 65.1 346.3 2.8c4.5-3.1 10.2-3.7 15.2-1.6zM160 256a96 96 0 1 1 192 0 96 96 0 1 1 -192 0zm224 0a128 128 0 1 0 -256 0 128 128 0 1 0 256 0z"/></svg>
</template>;

const Moon = <template>
  <svg class="fa-moon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 384 512">{{!--! Font Awesome Pro 6.4.0 by @fontawesome - https://fontawesome.com License - https://fontawesome.com/license (Commercial License) Copyright 2023 Fonticons, Inc. --}}<path d="M223.5 32C100 32 0 132.3 0 256S100 480 223.5 480c60.6 0 115.5-24.2 155.8-63.4c5-4.9 6.3-12.5 3.1-18.7s-10.1-9.7-17-8.5c-9.8 1.7-19.8 2.6-30.1 2.6c-96.9 0-175.5-78.8-175.5-176c0-65.8 36-123.1 89.3-153.3c6.1-3.5 9.2-10.5 7.7-17.3s-7.3-11.9-14.3-12.5c-6.3-.5-12.6-.8-19-.8z"/></svg>
</template>;
```

</details>

## Configuration
