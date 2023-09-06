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
