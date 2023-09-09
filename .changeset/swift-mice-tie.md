---
'ember-primitives': minor
---

Add new component, `<OTPInput>`

To use:

```gjs
import { OTPInput as OTP } from 'ember-primitives';
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
</template>
```

the reset button is optional.
the submit button is technically optional, but you need it to trigger the `@onSubmit` callback.
