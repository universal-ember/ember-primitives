# Forms

This type of form is a thin, almost invisible, wrapper around the [native `<form>`][mdn-form]. 

It requires an `@onChange` argument, which receives the results of [`FormData`][mdn-FormData]'s `entries()` method, in the form of an key-[`FormDataEntryValue`][mdn-FormDataEntryValue] object. 

You'll notice in this demo, there is no `on`, `fn`, or any event binding to the inputs -- only the initial value is set.

<Callout>

You don't need this component, as the boilerplate here is quite small. However, the abstractions in ember-primitives use enough forms that abstracting away the boilerplate is still useful.

  <br />
  <details><summary>For interacting with servers</summary>

  If you need to submit data to a server, this `<Form />` component is not needed. You can use the same (de)serialization of data <-> FormData techniques to directly POST to your server without the need to use JavaScript. This `<Form />` component is specifically for single-page-app forms that don't directly submit data to the server and require additional processing before a `fetch`-based (or similar) POST/PUT/PATCH/etc

  </details>

</Callout>
<br>

<details><summary>Two philosophies around forms</summary>

These topics are mostly out of scope for this documentation, but here is a quick overview.

There are two ways to create forms: **Controlled** and **Uncontrolled**. 

This `<Form />` component follows the _uncontrolled_ pattern, and is a light wrapper that has automatic two-way binding without wiring anything up. 

There are also _controlled_ forms which focuses on explicitly managing data, events, etc, and is generally good for _constraining_ what developers can do as they consume your abstraction -- which tend to be good for building design systems ([see here](https://github.com/universal-ember/dev/issues/2)).

It's totally feasible to build a _Controlled_ API from an _Uncontrolled_ implementation.

</details>
<br />

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
[mdn-FormData]:  https://developer.mozilla.org/en-US/docs/Web/API/FormData
[mdn-FormDataEntryValue]: https://udn.realityripple.com/docs/Web/API/FormDataEntryValue


## Fetaures 

* All types of inputs and controls are supported
* Best accessibility
* No need to add boilerplate to inputs
* Works with any shape of data

## Installation

```bash 
pnpm add ember-primitives
```

## Anatomy

```js 
import { Form } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Form } from 'ember-primitives/components/form';
```


```gjs 
import { Form } from 'ember-primitives';

<template>
  <Form>
      Controls here
  </Form>
</template>
```


## Accessibility

Because this is a light wrapper around [`<form>`][mdn-form], accessibility is the same as native behavior. Nothing custom was needed.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/form" @name="Signature" />
</template>
```

### State Attributes

None.
