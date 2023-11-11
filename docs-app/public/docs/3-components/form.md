# Forms

There are (at least) two ways to create forms. Here are:
- a light wrapper that has automatic two-way binding without wiring anything up (what is implemented here)
- a controlled form which focuses on managing data, and is good for building design systems ([see here](https://github.com/universal-ember/dev/issues/2))

This type of form is a thin, almost invisible, wrapper around the [native `<form>`][mdn-form]. 

It requires an `@onChange` argument, which receives the results of [`FormData`][mdn-FormData]'s `entries()` method, in the form of an key-[`FormDataEntryValue`][mdn-FormDataEntryValue] object. 

You'll notice in this demo, there is no `on`, `fn`, or any event binding to the inputs -- only the initial value is set.

<div class="featured-demo">

```gjs live preview
import { Form } from 'ember-primitives';
import { TrackedObject } from 'tracked-built-ins';

const data = new TrackedObject({ firstName: 'Gwen' });

function update(newValues) {
  for (let [key, value] of Object.entries(newValues)) {
    if (data[key] !== value) {
      data[key] = value; // only update changed values
    }
  }
}

<template>
  <div class="layout">
    <Form @onChange={{update}}>
      <label>
        First Name
        <input name="firstName" value={{data.firstName}}>
      </label>

      <fieldset>
        <legend>Travel to a universe</legend>
        <label>65   <input name="universe" type="radio" value="65"></label>
        <label>616  <input name="universe" type="radio" value="616"></label>
      </fieldset>
    </Form>

    <pre>{{JSON.stringify data null 3}}</pre>
  </div>

  <style>
    .layout { 
      display: grid; 
      gap: 1rem;
      grid-auto-flow: column;
    }
    form, fieldset {
      display: flex;
      gap: 1rem;
      flex-wrap: wrap;
      flex-direction: column;
    }
    input { max-width: 100%; }
    pre { 
      overflow: hidden; 
      white-space: pre-wrap;
    } 
  </style>
</template>
```

</div>

Something to note when using native `<form>` is that _all values_ are strings (per [`FormDataEntryValue`][mdn-FormDataEntryValue]). 
If you wish to use booleans, numbers, or complex objects, you'll need to manage the conversion to and from those values to strings (for the form) yourself. 

The light abstraction is this pattern, and almost exactly the implementation used:
```gjs
const handleInput = (onChange, event) => {
  let formData = new FormData(event.currentTarget);
  let data = Object.fromEntries(formData.entries());

  onChange(data);
}

const handleSubmit = (onChange, event) => {
  event.preventDefault();
  handleInput(onChange, event);
};

<template>
  <form
    {{on 'input' (fn handleInput @onChange)}}
    {{on 'submit' (fn handleSubmit @onChange)}}
    ...attributes
  >
    {{yield}}
  </form>
</template>
```

[mdn-form]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/form
[mdn-FormData]: https://udn.realityripple.com/docs/Web/API/FormData
[mdn-FormDataEntryValue]: https://udn.realityripple.com/docs/Web/API/FormDataEntryValue

