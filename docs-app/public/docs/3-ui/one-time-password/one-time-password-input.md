# One-Time Password Input

This `<OTPInput>` is a low-level component used in the `<OTP>` component. It provides only the collective input field for embedding in broader forms.


<Callout>

Before reaching for this component, consider if the [`WebOTP` API](https://developer.mozilla.org/en-US/docs/Web/API/WebOTP_API) and/or the [native `<input>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input) with [`autocomplete="one-time-code"`](https://developer.mozilla.org/en-US/docs/Web/HTML/Attributes/autocomplete#browser_compatibility) is sufficient for your use case. 

</Callout>
<br>


<div class="featured-demo">

```gjs live preview
import { OTPInput } from 'ember-primitives';
import { cell } from 'ember-resources';
import { uniqueId } from '@ember/helper';

const currentCode = cell();
const update = ({ code }) => currentCode.current = code;

<template>
  <pre>code: {{currentCode}}</pre>

  Please enter the OTP<br>

  <OTPInput @onChange={{update}} />

  <style>
    fieldset {
      border: none;
      padding: 0;
    }
    input {
      border: 1px solid;
      font-size: 2rem;
      width: 2.5rem;
      height: 3rem;
      text-align: center;
    }
  </style>
</template>
```

</div>

## Features

* Auto-advance focus between inputs as characters are typed
* Pasting into the collective field will fill all inputs with the pasted value
* backspace / arrow key support
* number keyboard on [mobile](https://developer.mozilla.org/docs/Web/HTML/Global_attributes/inputmode)

## Anatomy

```js 
import { OTPInput } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { OTPInput } from 'ember-primitives/components/one-time-password';
```


```gjs 
import { OTPInput } from 'ember-primitives';

<template>

  <label>
    Enter OTP

    <OTPInput />
  </label>
</template>
```

There is also an alternate block-fork you can use if you want to place additional information
within the `fieldset`
```gjs 
import { OTPInput } from 'ember-primitives';

<template>
    <OTPInput as |Fields|>
        <Fields />
    </OTPInput>
</template>
```


## Accessibility

Every field making up the collective input already has a screen-reader friendly label.
Developers are encouraged to provide a visible label via `<legend>` or other means.

Keyboard interactions try to mimic select interactions from a single input (arrows, backspace, etc).


## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'docs-app/docs-support';

<template>
  <ComponentSignature @module="index" @name="OTPInput" />
</template>
```
### State Attributes

none

[^sms]: noting that SMS is not the *most secure* form of 2FA, and for applications that truly need secure logic, you'll want an authenticator app. See [this article for a high level overview of the reasoning](https://www.securemac.com/news/is-sms-for-2fa-insecure)
