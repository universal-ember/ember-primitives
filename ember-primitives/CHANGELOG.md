# ember-primitives

## 0.10.0

### Minor Changes

- 3515f4d: Improvements to `ember-primitives/color-scheme`

  - fix a bug with `setColorScheme`
  - new method, `onUpdate`, which can be used to synchronize external systems,
    like graphics or charting systems that need to sync with the broader site theme.

## 0.9.0

### Minor Changes

- 155f0bc: New component: Accordion -- see docs for more information

### Patch Changes

- c8baa6e: Extract common utils to another library which will be reactive utility focused
- 3cfc238: Switch to reactive-primitives to reactiveweb (same library)

## 0.8.1

### Patch Changes

- 535b4be: Declare css imports as side-effects

## 0.8.0

### Minor Changes

- 4352415: Add new component, `<StickyFooter>`. see documentation for details.

## 0.7.0

### Minor Changes

- 73c231d: New component: Avatar -- see docs for details

## 0.6.0

### Minor Changes

- 4ba80e6: Two new components: `<OTP>` and `<OTPInput>`

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

### Patch Changes

- 9f4fc3e: Declare @glint/template as an optional peer dependency

## 0.5.0

### Minor Changes

- 996898d: Add a new component: `<Form>`!

  This is a very light form, in that it only wraps the `<form>` element, and binds to the input and change events to the form, thus allowing you to not need to wire up event listeners to any inputs.

## 0.4.0

### Minor Changes

- b7cccdc: For `<Popover>`, provide an escape hatch on `<Content>` so that folks can opt out of portaling, if their CSS or middleware is misbehaving. This should be a last resort, however, as portalling can help solve layering and z-index issues across the whole application -- see https://ember-primitives.pages.dev/5-floaty-bits/portal for a demo.
- b7cccdc: For portals, set style to display:contents; so that when rendered, they do not take up space or shift anything visually

## 0.3.0

### Minor Changes

- c043045: Add new component, <ProgressBar />. see docs for details

## 0.2.0

### Minor Changes

- ef7306f: Link now exposes an `isActive` property on the yielded data, as well as provides a data-active attribute on the generated `<a>` element
- 2c7696d: Add a loosemode template-registry for Glint users not yet using gjs/gts

## 0.1.0

### Minor Changes

- 5921fb4: Drop support for Ember 4.8. It could still be supported through @embroider/macros, but I don't have the energy for that right now. If someone wanted to submit a PR, that'd be ligit -- however, the gap between 4.8 and 4.12 is very small, and folks should just use latest 4.x if they can"

### Patch Changes

- 7267ccb: @properLinks
  - needs to support both QueryParams and the hash
  - supports custom rootURL
  - internally: adding tests for all of this as well

## 0.0.9

### Patch Changes

- 59c02c3: Fix peers so that this library is compatible with all the next majors

## 0.0.8

### Patch Changes

- 79b0e5f: Fix issue where <Link> did not fallback to browser-behavior like @properLinks does

## 0.0.7

### Patch Changes

- fec2dc4: Add dialog component

## 0.0.6

### Patch Changes

- 644c6ba: Add iframe utilities for checking if the current frame is in an iframe or not. Also added documentation, and fixed the docs-renderer for rendering the comment block next to functions

## 0.0.5

### Patch Changes

- d72fb6e: Update proper-links to be compat with TS 5.1

## 0.0.4

### Patch Changes

- 78406fc: Add Popover, PortalTargets, and Portal

## 0.0.3

### Patch Changes

- 5f505a7: Add Toggle component, see: https://ember-primitives.pages.dev/3-components/toggle

## 0.0.2

### Patch Changes

- 1430a90: Remove extraneous span from ExternalLink

## 0.0.1

### Patch Changes

- 23bfdb6: initial pre-alpha
