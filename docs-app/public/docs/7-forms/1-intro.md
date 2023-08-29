# Forms

There are (at least) two ways to create forms. Here are:
- a light wrapper that has automatic two-way binding without wiring anything up 
- a controlled form which focuses on managing data, and is good for building design systems

## Light Forms

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

## Controlled Forms

This type of form is handled by and built with [this styleless Forms implementation][gh-headless-form]. The library provides provides a way to [build your fields][gh-custom-controls], which we will use with the unique, non-native fields provided by `ember-primitives` 


> [ember-headless-form] distills the common behavior and accessibility best practices of forms into reusable components, without any opinions on specific markup or styling. Use it to build your forms directly, or to build your opinionated forms component kit on top of it. 
> <cite>[from the docs][gh-form-intro]</cite>

The _Light Form_ does not provide any accessibility guidance between labels, inputs, errors, and other statuses (because the light form is just a `<form>` element). ember-headless-form solves all of this boilerplate for you.

[gh-headless-form]: https://github.com/CrowdStrike/ember-headless-form/
[gh-custom-controls]: https://ember-headless-form.pages.dev/docs/usage/custom-controls
[gh-form-intro]: https://ember-headless-form.pages.dev/docs
