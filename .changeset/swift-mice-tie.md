---
'ember-primitives': minor
---

Two new components: `<OTP>` and `<OTPInput>`

To use:

```gjs
import { OTP } from 'ember-primitives';
import { cell } from 'ember-resources';

const submittedCode = cell();
const handleSubmit = ({ code }) => submittedCode.current = code;

<template>
  <pre>submitted: {{submittedCode}}</pre>

  <OTP @onSubmit={{handleSubmit}} as |x|>
    <x.Input class="fields" />
    <br>
    <x.Submit>Submit</x.Submit>
    <x.Reset>Reset</x.Reset>
  </OTP>
</template>
```

the reset button is optional.

For more information, see the docs for
- [OTP](https://ember-primitives.pages.dev/3-components/one-time-password)
- [OTPInput](https://ember-primitives.pages.dev/3-components/one-time-password-input)
