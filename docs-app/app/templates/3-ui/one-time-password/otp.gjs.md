# One-Time Password

The `<OTP>` component provides a way to manage one-time-password entry using the common pattern where each character entry for the one-time-password is its own field, while also managing accessibility requirements of a multi-field input. 

For more information on OTP patterns, see [web.dev's SMS OTP Form](https://web.dev/sms-otp-form/)[^sms]

<Callout>

Before reaching for this component, consider if the [`WebOTP` API](https://developer.mozilla.org/en-US/docs/Web/API/WebOTP_API) and/or the [native `<input>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) with [`autocomplete="one-time-code"`](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete#browser_compatibility) is sufficient for your use case. 

</Callout>
<br>

<div class="featured-demo">

```gjs live preview
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

  <style>
    .fields { 
      display: grid;
      grid-auto-flow: column;
      gap: 0.5rem;
      width: min-content;
      border: none;
      padding: 0;

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

## Install

```hbs live
<SetupInstructions @src="components/one-time-password.gts" />
```

## Features

* Auto-advance focus between inputs as characters are typed
* Pasting into the collective field will fill all inputs with the pasted value
* Standalone form, allowing for easily creating OTP-entry screens
* Optional reset button
* Pressing enter submits the code
* backspace / arrow key support
* number keyboard on [mobile](https://developer.mozilla.org/docs/Web/HTML/Global_attributes/inputmode)


## Anatomy

```js 
import { OTP } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { OTP } from 'ember-primitives/components/one-time-password';
```


```gjs 
import { OTP } from 'ember-primitives';

<template>
  <OTP as |x|>
    text can go here, or in between the below components

    <x.Input />
    <x.Submit> submit text </x.Submit>
    <x.Reset> reset text </x.Reset>

    text can go here as well
  </OTP>
</template>
```

Additionally, the customization from `<OTPInput>` is available as well

```gjs 
import { OTP } from 'ember-primitives';

<template>
  <OTP as |x|>
    <x.Input as |Fields|>
        <Fields />
    </x.Input>

    <x.Submit> submit text </x.Submit>
  </OTP>
</template>
```


## Accessibility

This component complies with all `<form>` and `<input>` accessibility guidelines.
It is rendered within a fieldset to convey that all of the character inputs are related.


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/one-time-password/otp" 
    @name="OTP" 
  />
</template>
```
### State Attributes

none

[^sms]: noting that SMS is not the *most secure* form of 2FA, and for applications that truly need secure logic, you'll want an authenticator app. See [this article for a high level overview of the reasoning](https://www.securemac.com/news/is-sms-for-2fa-insecure)
