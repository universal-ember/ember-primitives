# Data from `<form>`

A utility function for extracting the FormData as an object from the native `<form>` 
element, allowing more ergonomic of usage of _The Platform_'s default form/fields usage.

Each input within your `<form>` should have a `name` attribute.
(or else the `<form>` element doesn't know what inputs are relevant)

This will provide values for all types of controls/fields,
- input: text, checkbox, radio, etc
- select
  - behavior is fixed from browser default behavior, where
    only the most recently selected value comes through in
    the FormData. This fix only affects `<select multiple>`

## Example

Try filling out some data in the form below, and click submit.

<div class="featured-demo">

```gjs live preview no-shadow 
import { cell } from 'ember-resources';
import { dataFromEvent } from 'ember-primitives/components/form';

const { JSON } = globalThis;
const dataPreview = cell({});

function handleSubmit(event) {
  event.preventDefault();
  dataPreview.set(dataFromEvent(event));
}

<template>
  <div id="formData-demo">
    <form onsubmit={{handleSubmit}}>
      <label>
        First Name
        <input type="text" name="firstName" value="NVP" />
      </label>
      <label> 
        Are you a human?
        <input type="checkbox" name="isHuman" value="nah" />
      </label>
      <fieldset>
        <legend>Favorite Race</legend>
        <label>Zerg<input type="radio" name="bestRace" value="zerg" checked /></label>
        <label>Protoss<input type="radio" name="bestRace" value="protoss" /></label>
        <label>Terran<input type="radio" name="bestRace" value="terran" /></label>
      </fieldset>

      <label>
        Worst Race
        <select multiple name="worstRace">
          <option value="zerg" disabled>Zerg</option>
          <option value="protoss" selected>Protoss</option>
          <option value="terran" selected>Terran</option>
        </select>
      </label>
      <button type="submit">Submit</button>
    </form>

    <pre>{{JSON.stringify dataPreview.current null 3}}</pre>
  </div>

  <style>
    #formData-demo {
      display: flex;
      gap: 1rem;
      justify-content: space-between;
      align-items: start;

      form {
        display: flex;
        flex-direction: column;
        gap: 0.5rem;

        button {
          border: 1px solid;
        }
      }

      pre {
        margin: 0;
      }
    }
    .featured-demo .glimdown-render {
      max-height: unset;
    }
  </style>
</template>
```

</div>

## API Reference

```gjs live no-shadow
import { APIDocs } from 'kolay';

<template>
  <APIDocs @package="ember-primitives" @module="declarations/components/form" @name="dataFromEvent" />
</template>
```
