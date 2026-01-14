# Switch

The Switch component is a user interface element used for toggling between two states. It consists of a track and a handle that can be interacted with to change the state. The Switch is commonly used in forms, settings screens, and preference panels to control features or settings.

`<Switch />` can be used in any design system.

## Examples

<details><summary><h3>Draggable</h3></summary>
<br>

```gjs live preview
import { Switch } from 'ember-primitives/components/switch';
import { Shadowed } from 'ember-primitives/components/shadowed';
import { modifier } from 'ember-modifier';

const draggableSwitch = modifier((element) => {
  const control = element.querySelector('[role="switch"]');

  let pointerId = null;
  let rect = null;

  const getIsOn = () => {
    const ariaChecked = control.getAttribute('aria-checked');
    if (ariaChecked !== null) {
      return ariaChecked === 'true';
    }

    if ('checked' in control && typeof control.checked === 'boolean') {
      return control.checked;
    }

    return control.getAttribute('data-state') === 'on';
  };

  const updateThumb = (clientX) => {
    if (!rect) return 0;

    let fraction = (clientX - rect.left) / rect.width;
    if (!Number.isFinite(fraction)) fraction = 0;

    const clamped = Math.min(Math.max(fraction, 0), 1);
    const percent = clamped * 100;

    element.style.setProperty('--thumb-translate', `${percent}%`);

    return clamped;
  };

  const handlePointerMove = (event) => {
    if (event.pointerId !== pointerId) return;
    updateThumb(event.clientX);
  };

  const handlePointerUpOrCancel = (event) => {
    if (event.pointerId !== pointerId) return;

    updateThumb(event.clientX); // 0..1

    element.style.removeProperty('--thumb-translate');
    element.classList.remove('is-dragging');

    element.releasePointerCapture?.(pointerId);
    element.removeEventListener('pointermove', handlePointerMove);
    element.removeEventListener('pointerup', handlePointerUpOrCancel);
    element.removeEventListener('pointercancel', handlePointerUpOrCancel);

    pointerId = null;
    rect = null;
  };

  const handlePointerDown = (event) => {
    if (event.button !== 0) return; 

    pointerId = event.pointerId;
    rect = element.getBoundingClientRect();

    element.classList.add('is-dragging');
    element.setPointerCapture?.(pointerId);

    element.addEventListener('pointermove', handlePointerMove);
    element.addEventListener('pointerup', handlePointerUpOrCancel);
    element.addEventListener('pointercancel', handlePointerUpOrCancel);

    updateThumb(event.clientX);
  };

  element.addEventListener('pointerdown', handlePointerDown);

  return () => {
    element.removeEventListener('pointerdown', handlePointerDown);
    element.removeEventListener('pointermove', handlePointerMove);
    element.removeEventListener('pointerup', handlePointerUpOrCancel);
    element.removeEventListener('pointercancel', handlePointerUpOrCancel);
  };
});

<template>
  <Shadowed>
    <Switch as |s|>
      <s.Label
        class="switch"
        data-state={{if s.isChecked "on" "off"}}
        {{draggableSwitch}}
      >
        Off
        <s.Control />
        On
      </s.Label>
      <br><br>
      Result: {{s.isChecked}}
    </Switch>

    <style>

.switch {
  --switch-width: 90px;
  --switch-height: 32px;
  --switch-border: 2px;
  --thumb-translate: 0%; /* 0% = off, 100% = on */

  position: relative;
  display: inline-flex;
  align-items: center;
  justify-content: space-between;
  box-sizing: border-box;

  width: var(--switch-width);
  height: var(--switch-height);

  padding: 0 10px; /* space for "Off" / "On" text */

  border-radius: 999px;
  border: var(--switch-border) solid #4b5563;

  background: transparent;
  color: #e5e7eb;
  font-size: 0.75rem;
  font-weight: 500;

  cursor: pointer;
  user-select: none;
  touch-action: pan-x;
}

/* When the switch is on, resting thumb position is 100% */
.switch[data-state="on"] {
  --thumb-translate: 100%;
}

/* Track behind everything, perfectly centered between borders */
.switch::before {
  content: "";
  position: absolute;
  inset: var(--switch-border); /* respects border thickness */
  border-radius: inherit;
  background: #4b5563;
  opacity: 0.6;
  z-index: 0;
}

/* Sliding thumb, sized so it aligns perfectly in both positions */
.switch::after {
  content: "";
  position: absolute;

  /* start right inside the border */
  top: var(--switch-border);
  left: var(--switch-border);

  /* half of the *inner* width:
     inner width = 100% - 2*border
     thumb width = (inner / 2) = 50% - border
   */
  width: calc(50% - var(--switch-border));
  height: calc(100% - 2 * var(--switch-border));

  border-radius: inherit;
  background: #f9fafb;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);

  transform: translateX(var(--thumb-translate));
  transition:
    transform 120ms ease-out,
    background 120ms ease-out;
  z-index: 0;
}

/* While dragging, JS adds this to remove easing so it follows the pointer 1:1 */
.switch.is-dragging::after {
  transition: none;
}

/* Make sure Off / On text is visible above track + thumb */
.switch > * {
  position: relative;
  z-index: 1;
}

/* If you wrap the labels in spans:
   <span>Off</span> <s.Control /> <span>On</span>
   this centers them nicely in each half.
*/
.switch span {
  flex: 1;
  text-align: center;
}

/* Hide the real control visually but keep it focusable + clickable */
.switch input,
.switch [role="switch"] {
  position: absolute;
  inset: 0;
  margin: 0;
  opacity: 0;
  cursor: inherit;
}

/* Focus outline for keyboard users */
.switch:focus-within {
  outline: 2px solid #e5e7eb;
  outline-offset: 2px;
}
    </style>
  </Shadowed>
</template>
```

</details>
<details open><summary><h3>Dark/Light Theme Switch</h3></summary>

CSS inspired/taken from [this Codepen](https://codepen.io/Umer_Farooq/pen/eYJgKGN?editors=1100)

```gjs live preview
import { Switch, Shadowed } from 'ember-primitives';
import { on } from '@ember/modifier';

const toggleTheme = (e) =>
  e.target.closest('div').classList.toggle("dark");

<template>
  <Shadowed>
    <Switch as |s|>
      <s.Control {{on 'change' toggleTheme}} />
      <s.Label>
        <span class="sr-only">Toggle between light and dark mode</span>
        <span class="ball" data-state={{if s.isChecked "on" "off"}}>
          {{#if s.isChecked}}
            <Moon />
          {{else}}
            <Sun />
          {{/if}}
      </span>
      </s.Label>
    </Switch>

    <style>
      * {box-sizing: border-box;}

      @scope {
        div {
          padding: 1rem;
          background-color: #eee;
          display: flex;
          justify-content: center;
          align-items: center;
          flex-direction: column;
          text-align: center;
          margin: 0;
          transition: background 0.2s linear;
          width: 100%;
        }

        div.dark {background-color: #292c35;}
        div.dark label { background-color: #9b59b6; }


        input[type='checkbox'][role='switch'] {
          touch-action: pan-y;
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
          background-color: #aaaaff;
          border: 1px solid;
          width: 60px;
          height: 32px;
          border-radius: 50px;
          position: relative;
          padding: 5px;
          cursor: pointer;
          display: flex;
          justify-content: space-between;
          align-items: center;
          gap: 0.5rem;
        }

        svg { fill: currentColor; position: absolute; top: 3px; left: 3px; }
        .moon { color: #f1c4ff; }
        .sun { color: #f39c12; }

        label .ball {
          background-color: #111;
          width: 26px;
          height: 26px;
          position: absolute;
          left: 2px;
          top: 2px;
          border-radius: 50%;
          transition-property: transform filter;
          transition-duration: 0.2s;
          transition-timing-function: linear(0, 0.1, 0.25, 0.5, 0.68, 0.8, 0.88, 0.94, 0.98, 0.995, 1);;
          border: 2px solid #f1c40f;

          &[data-state="on"] {
            border: 2px solid #f1c4ff;
          }
        }

        label:hover .ball {
          filter: drop-shadow(0 0 3px #f1c40f);
        }
        label:active .ball {
          filter: drop-shadow(0 0 10px #f1c40f);
        }
        input[type='checkbox'][role='switch']:checked + label .ball {
          transform: translateX(28px);
        }
        input[type='checkbox'][role='switch']:checked:hover + label .ball {
          filter: drop-shadow(0 0 3px #f1c4ff);
        }
        input[type='checkbox'][role='switch']:checked:active + label .ball {
          filter: drop-shadow(0 0 10px #f1c4ff);
        }
      }
    </style>
  </Shadowed>
</template>

// 🎵 It's raining, it's pouring, ... 🎵
// https://www.youtube.com/watch?v=ll5ykbAumD4
const Sun = <template>
  <svg
    class="sun"
    xmlns="http://www.w3.org/2000/svg"
    width="16"
    height="16"
    viewBox="0 0 16 16"
    fill="none"
    stroke="currentColor"
    stroke-width="1.5"
    stroke-linecap="round"
    stroke-linejoin="round"
    aria-hidden="true"
  >
    <circle cx="8" cy="8" r="3.25" />
    <line x1="8" y1="1" x2="8" y2="3" />
    <line x1="8" y1="13" x2="8" y2="15" />
    <line x1="1" y1="8" x2="3" y2="8" />
    <line x1="13" y1="8" x2="15" y2="8" />
    <line x1="3.05" y1="3.05" x2="4.47" y2="4.47" />
    <line x1="11.53" y1="11.53" x2="12.95" y2="12.95" />
    <line x1="11.53" y1="4.47" x2="12.95" y2="3.05" />
    <line x1="3.05" y1="12.95" x2="4.47" y2="11.53" />
  </svg>
</template>;

const Moon = <template>
<svg
  xmlns="http://www.w3.org/2000/svg"
  class="moon"
  width="16"
  height="16"
  viewBox="0 0 16 16"
  fill="none"
  stroke="currentColor"
  stroke-width="1.5"
  stroke-linecap="round"
  stroke-linejoin="round"
  aria-hidden="true"
>
  <path
    transform="translate(-1 0)"
    d="M11.5 2a5.5 5.5 0 1 0 2 9.5 4.5 4.5 0 0 1 -2 -9.5z"
  />
</svg>
</template>;
```

</details>
<details><summary><h3>Bootstrap</h3></summary>

See [Bootstrap Switch](https://getbootstrap.com/docs/5.3/forms/checks-radios/#switches) docs.

```gjs live preview
import { Switch } from 'ember-primitives/components/switch';
import { Shadowed } from 'ember-primitives/components/shadowed';

<template>
  <Shadowed>
    <div class="p-4">
      <Switch class="form-check form-switch" as |s|>
        <s.Control class="form-check-input" />
        <s.Label class="form-check-label">
          Toggle on or off
        </s.Label>
      </Switch>
    </div>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet" crossorigin="anonymous">
  </Shadowed>
</template>
```

</details>

## Install

```hbs live
<SetupInstructions @src="components/switch.gts" />
```

## Features 

* Full keyboard navigation 
* Can be controlled or uncontrolled

## Anatomy


```js 
import { Switch } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Switch } from 'ember-primitives/components/switch';
```


```gjs 
import { Switch } from 'ember-primitives';

<template>
  <Switch as |s|>
    <s.Control class="form-check-input" />
    <s.Label class="form-check-label">
      Toggle on or off
    </s.Label>
  </Switch>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/switch" 
    @name="Signature" />
</template>
```

### State Attributes

| key | description |  
| :---: | :----------- |  
| checked | attribute will be present when the underlying input is checked |  
| data-state | attribute will be "on" or "off", depending on the state of the toggle button |  

No custom data attributes are needed. From the root element, you may use the `:has` selector, to change the state of the container.

```gjs live preview
import { Switch } from 'ember-primitives';

<template>
  <style>
    /* styles for the root element when checked */
    .my-switch:has(:checked) {
      font-style: italic;
    }
    .my-switch:has([data-state=on]) {
      font-weight: bold;
    }
  </style>

  <Switch class="my-switch" as |s|>
    <s.Control class="form-check-input" />
    <s.Label class="form-check-label">
      Toggle on or off
    </s.Label>
  </Switch>
</template>
```


## Accessibility 

Adheres to the `switch` [role requirements](https://www.w3.org/WAI/ARIA/apg/patterns/switch)

### Keyboard Interactions 

| key | description |  
| :---: | :----------- |  
| <kbd>Space</kbd> | Toggles the component's state |  
| <kbd>Enter</kbd> | Toggles the component's state |  

In addition, a label is required so that users know what the switch is for.

## References

- https://web.dev/articles/building/a-switch-component
- https://getbootstrap.com/docs/5.3/forms/checks-radios/#switches
- https://web.dev/articles/building/a-switch-component
