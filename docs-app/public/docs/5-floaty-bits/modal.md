# Modal `<dialog>`

A modal in is a temporary overlay that appears on top of the main content of a webpage. 
It is used to present important information, prompt for input, or require the user to make a decision. 

Modals create a focused and isolated interaction, often with a darker background overlay, to draw attention and prevent interactions with the underlying page until the modal is dismissed. 

## Example

<div class="featured-demo">

```gjs live preview no-shadow
import { Modal } from 'ember-primitives';

import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { loremIpsum } from 'lorem-ipsum';

const returnValue = cell('');

<template>
  <Modal @onClose={{returnValue.set}} as |m|>
    <button {{on 'click' m.open}}>Open Modal</button>

    <br><br>
    isOpen: {{m.isOpen}}<br>
    return: {{returnValue.current}}

    <m.Dialog>
      <div>
        <header>
          <h2>Example Modal</h2>

          <button {{on 'click' m.close}}>Close</button>
        </header>

        <form method="dialog">
          <main>
            Modal content here
            <br>

           {{loremIpsum 1}}
          </main>

          <footer>
            <button type="submit" value="confirm">Confirm</button>
            <button type="submit" value="create">Create</button>
            <button type="reset" value="close" {{on 'click' m.close}}>Reset</button>
          </footer>
        </form>
      </div>
    </m.Dialog>
  </Modal>


  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <link rel="stylesheet" href="https://unpkg.com/open-props/animations.min.css"/>
  <style>
    dialog {
      border-radius: 0.25rem;
      animation: var(--animation-slide-in-up), var(--animation-fade-in);
      animation-timing-function: var(--ease-out-5);
      animation-duration: 0.2s;
    }
    dialog > div {
      display: grid;
      gap: 1rem;
    }
    dialog::backdrop {
      backdrop-filter: blur(1px);
    }
    dialog header { 
      display: flex;
      justify-content: space-between;
    }
    dialog h2 {
      margin: 0;
    }

    dialog main {
      max-width: 300px;
    }
    form {
      display: grid;
      gap: 1rem; 
    }
  </style>
</template>
```

</div>

Note that animations on `<dialog>` elements do not work within a [Shadow Dom](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM).

### Adding a focus-trap

`<Modal />` doesn't provide a focus-trap by default. 
The `<dialog>` element already traps focus for your webpage -- however, 
`<dialog>` does not trap focus from tabbing to the browser (address bar, tabs, etc). 
This is, in part, so that focus behavior is consistent in and out of a modal, 
and that keyboard users retain the ability to escape the webpage without being forced to close the modal -- though,
if keyboard users are also power-users, they may know about <kbd>ctrl</kbd> + <kbd>l</kbd> which escapes all focus traps, focusing the address bar, which would then allow them to tab to the back, forward, refresh, etc buttons in their browsers UI.

This browser defined, yet consistent across all browser behavior, conflicts with the [W3 ARIA Authoring Practices Guide](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/) recommendation:

> If focus is on the last tabbable element inside the dialog, moves focus to the first tabbable element inside the dialog.

_However_, the [example](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/dialog/) does not use the `<dialog>` element, and instead uses divs.

The behavior of trapping all focus is [proposed here](https://github.com/whatwg/html/issues/8339), and we are reminded that the ARIA patterns are _guidelines_.


If you wish to follow this guideline, it can be achieved via the `focusTrap` modifier.

```bash
pnpm add ember-focus-trap
```

<div class="featured-demo">

```gjs live preview no-shadow
import { Modal } from 'ember-primitives';

import { on } from '@ember/modifier';
import { focusTrap } from 'ember-focus-trap';
import { loremIpsum } from 'lorem-ipsum';


<template>
  <Modal as |m|>
    <button {{on 'click' m.open}}>Open Modal</button>

    <br><br>
    isOpen: {{m.isOpen}}<br>

    <m.Dialog {{focusTrap isActive=m.isOpen}}>
      <div>
        <header>
          <h2>Example Modal</h2>

          <button {{on 'click' m.close}}>Close</button>
        </header>

        <form method="dialog">
          <main>
            Modal content here
            <br>

           {{loremIpsum 1}}
          </main>

          <footer>
            <button type="submit" value="confirm">Confirm</button>
            <button type="reset" value="close" {{on 'click' m.close}}>Reset</button>
          </footer>
        </form>
      </div>
    </m.Dialog>
  </Modal>


  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <link rel="stylesheet" href="https://unpkg.com/open-props/animations.min.css"/>
  <style>
    dialog {
      border-radius: 0.25rem;
      animation: var(--animation-slide-in-up), var(--animation-fade-in);
      animation-timing-function: var(--ease-out-5);
      animation-duration: 0.2s;
    }
    dialog > div {
      display: grid;
      gap: 1rem;
      padding: 1rem;
    }
    dialog::backdrop {
      backdrop-filter: blur(1px);
    }
    dialog header { 
      display: flex;
      justify-content: space-between;
    }
    dialog h2 {
      margin: 0 !important;
    }

    dialog main {
      max-width: 300px;
    }
    form {
      display: grid;
      gap: 1rem; 
    }
    .glimdown-render {
      button { border: 1px solid; padding: 0.5rem; }
    }
  </style>
</template>
```

</div>

### Using as a Routeable Modal

To use the modal as a routeable modal, you can set the `@open` and `@onClose` keys, like so:
```gjs
import { Modal } from 'ember-primitives';
import Component from '@glimmer/component';
import { service } from '@ember/service';

export default class RouteableModal extends Component {
  <template>
    <Modal @open={{true}} @onClose={{this.handleClose}} as |m|>

      <m.Dialog>
        <form method="dialog">
          <button type="submit" value="confirm">Confirm</button>
          <button type="submit" value="create">Create</button>
          <button type="reset" value="close" {{on 'click' m.close}}>Reset</button>
        </form>
      </m.Dialog>
    </Modal>
  </template>

  @service router;

  handleClose = (reason) => {
    switch (reason) {
      case 'create': return this.router.transitionTo('place/when/created');
      case 'confirm': return this.router.transitionTo('place/when/confirmed');
      default:
        /**
          * there is no reason when ESC is pressed, 
          * or a type=reset button is clicked
          */
        return this.router.transitionTo('place/when/cancelled');
    }
  }

}
```

## Enabling automatic body-scroll lock

You'll need page-wide CSS similar to this:
```css
html {
  overflow: hidden;
}

body {
  overflow: auto;
  height: 100dvh;
}
```
This is also a common technique for controlling which element scrolls when doing custom layouts.
Constraining the height of an element to the dynamic vertical height works for desktop and mobile where some elements of the browser may not always be visible.

The scrollable element doesn't have to be the `body` either, it could be a `<div>`, as you'll see in layouts where scroll-content may be wholly underneath a header.

## Anatomy

```js 
import { Modal, Dialog /* alias */ } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Modal, Dialog /* alias */ } from 'ember-primitives/components/dialog';
```


```gjs 
import { Modal } from 'ember-primitives';

<template>
  <Modal as |m|>

    m.isOpen
    m.open
    m.close

    <m.Dialog ...attributes>
      this is just the HTMLDialogElement
    </m.Dialog>
  </Modal>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/dialog" 
    @name="Signature" />
</template>
```

### State Attributes

There is no root element for this component, so there are no state attributes to use.
Since the this component uses the `<dialog>` element, it will still use the `open` attribute.

## Accessibility

Once the dialog is open, the browser will focus on the first button (in this case, it's our close button on the dialog header) or any button with the autofocus attribute within the dialog. When you close the dialog, the browser restores the focus on the button we used to open it.

### Keyboard Interactions

The dialog element handles ESC (escape) key events automatically, hence reducing the burdens and efforts required to provide an effortless experience for users while working with dialogs.

However, if you want to add an animation effect on _closing_ and opening dialog programmatically, note that you will lose this built-in feature support and have to implement the tab navigation focus yourself.


## References

- [MDN HTMLDialogElement](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog)
- [web.dev : Building a dialog component](https://web.dev/building-a-dialog-component/)
- [Exploring the HTML Dialog element](https://mayashavin.com/articles/build-a-dialog-with-dialog-element)[^a11y]
- [Open Props](https://open-props.style)[^animations]

<hr>

[^a11y]: The Accessibility text was copied from this blog. 
[^animations]: Animations in the examples are provided by Open Props 
