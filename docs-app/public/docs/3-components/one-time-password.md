# One-Time Password

<div class="featured-demo">

```gjs live preview
import { OTP } from 'ember-primitives';
import { cell } from 'ember-resources';

const submittedCode = cell();
const handleSubmit = ({ code }) => submittedCode.current = code;

<template>
  <pre>submitted: {{submittedCode}}</pre>

  <OTP @onSubmit={{handleSubmit}} as |x|>
    <div class="fields">
      <x.Input />
    </div>
    <br>
    <x.Submit>Submit</x.Submit>
    <x.Reset>Reset</x.Reset>
  </OTP>

  <style>
    .fields { 
      display: grid;
      grid-auto-flow: column;
      gap: 0.5rem;
      width: min-content;

      input {
        border: 1px solid;
        font-size: 2rem;
        width: 2.5rem;
        height: 3rem;
        text-align: center;
        appearance: textfield;
      }
    }
  </style>
</template>
```

</div>

## Features

* Auto-advance focus between inputs as characters are typed
* Pasting into the collective field will fill all inputs with the pasted value
* Standalone form, allowing for easily creating OTP-entry screens
* Optional reset button

## Anatomy

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="components/one-time-password/otp" @name="OTP" />
</template>
```

