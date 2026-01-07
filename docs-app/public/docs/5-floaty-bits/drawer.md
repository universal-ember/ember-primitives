# Drawer

A drawer is a sliding panel that appears from the side of the screen, typically used for navigation, filters, or additional content.
It is built on top of the native `<dialog>` element, similar to modals, but designed to slide in from a specific side of the viewport.

Drawers are commonly used for:
- Side navigation menus
- Filter panels
- Settings panels
- Additional contextual information

## Example

<div class="featured-demo">

```gjs live preview no-shadow
import { Drawer } from 'ember-primitives';

import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { loremIpsum } from 'lorem-ipsum';

const returnValue = cell('');

<template>
  <Drawer @onClose={{returnValue.set}} as |d|>
    <button {{on 'click' d.open}} {{d.focusOnClose}}>Open Drawer</button>

    <br><br>
    isOpen: {{d.isOpen}}<br>
    return: {{returnValue.current}}

    <d.Drawer>
      <header>
        <h2>Example Drawer</h2>

        <button {{on 'click' d.close}}>Close</button>
      </header>

      <form method="dialog">
        <main>
          Drawer content here
          <br>

         {{loremIpsum 1}}
        </main>

        <footer>
          <button type="submit" value="confirm">Confirm</button>
          <button type="submit" value="create">Create</button>
          <button type="reset" value="close" {{on 'click' d.close}}>Reset</button>
        </footer>
      </form>
    </d.Drawer>
  </Drawer>


  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <link rel="stylesheet" href="https://unpkg.com/open-props/animations.min.css"/>
  <style>
  @scope {
    dialog {
      padding: 0;
      margin: 0;
      max-height: 400px;
      width: 100dvw;
      height: 400px;
      position: fixed;
      bottom: 0;
      top: unset;
      animation: var(--animation-slide-in-up), var(--animation-fade-in);
      animation-timing-function: var(--ease-out-5);
      animation-duration: 0.3s;

      display: grid;
      gap: 1rem;
      padding: 1rem;

        button {
          border: 1px solid;
          padding: 1rem;
        }
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
      flex: 1;
      overflow-y: auto;
    }
    form {
      display: grid;
      gap: 1rem; 
      height: 100%;
    }
  }
  </style>
</template>
```

</div>

Note that animations on `<dialog>` elements do not work within a [Shadow Dom](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM).

## Different Positions

While the above example shows a drawer from the right, you can position drawers from any side by adjusting the CSS:

### Left Drawer

```css
dialog {
  left: 0;
  right: auto;
  animation: var(--animation-slide-in-left), var(--animation-fade-in);
}
```

### Top Drawer

```css
dialog {
  top: 0;
  bottom: auto;
  left: 0;
  right: 0;
  width: 100%;
  height: auto;
  max-height: 50vh;
  animation: var(--animation-slide-in-down), var(--animation-fade-in);
}
```

### Bottom Drawer

```css
dialog {
  top: auto;
  bottom: 0;
  left: 0;
  right: 0;
  width: 100%;
  height: auto;
  max-height: 50vh;
  animation: var(--animation-slide-in-up), var(--animation-fade-in);
}
```

### Adding a focus-trap

`<Drawer />` doesn't provide a focus-trap by default. 
The `<dialog>` element already traps focus for your webpage -- however, 
`<dialog>` does not trap focus from tabbing to the browser (address bar, tabs, etc). 

If you wish to trap all focus within the drawer, you can use the `focusTrap` modifier from `ember-focus-trap`.

```bash
pnpm add ember-focus-trap
```

<div class="featured-demo">

```gjs live preview no-shadow
import { Drawer } from 'ember-primitives';

import { on } from '@ember/modifier';
import { focusTrap } from 'ember-focus-trap';
import { loremIpsum } from 'lorem-ipsum';


<template>
  <Drawer as |d|>
    <button {{on 'click' d.open}}>Open Drawer</button>

    <br><br>
    isOpen: {{d.isOpen}}<br>

    <d.Drawer {{focusTrap isActive=d.isOpen}}>
      <header>
        <h2>Example Drawer</h2>

        <button {{on 'click' d.close}}>Close</button>
      </header>

      <form method="dialog">
        <main>
          Drawer content here
          <br>

         {{loremIpsum 1}}
        </main>

        <footer>
          <button type="submit" value="confirm">Confirm</button>
          <button type="reset" value="close" {{on 'click' d.close}}>Reset</button>
        </footer>
      </form>
    </d.Drawer>
  </Drawer>


  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <link rel="stylesheet" href="https://unpkg.com/open-props/animations.min.css"/>
  <style>
  @scope {
    dialog {
      border: none;
      border-left: 1px solid #ccc;
      padding: 0;
      margin: 0;
      max-width: 400px;
      width: 400px;
      height: 100dvh;
      position: fixed;
      right: 0;
      animation: var(--animation-slide-in-right), var(--animation-fade-in);
      animation-timing-function: var(--ease-out-5);
      animation-duration: 0.3s;

      display: flex;
      gap: 1rem;
      height: 100%;
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
      flex: 1;
      overflow-y: auto;
    }
    form {
      display: grid;
      gap: 1rem;
      height: 100%;
    }
    .glimdown-render {
      button { border: 1px solid; padding: 0.5rem; }
    }
  }
  </style>
</template>
```

</div>

### Using as a Routeable Drawer

To use the drawer in a routable context, you can set the `@open` and `@onClose` args, similar to the Modal component:

```gjs
import { Drawer } from 'ember-primitives';
import Component from '@glimmer/component';
import { service } from '@ember/service';

export default class RouteableDrawer extends Component {
  <template>
    <Drawer @open={{true}} @onClose={{this.handleClose}} as |d|>

      <d.Drawer>
        <form method="dialog">
          <button type="submit" value="confirm">Confirm</button>
          <button type="submit" value="create">Create</button>
          <button type="reset" value="close" {{on 'click' d.close}}>Reset</button>
        </form>
      </d.Drawer>
    </Drawer>
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

### Using an external trigger

To use an external trigger, you have to use a side-effect to do it, like so: 

<div class="featured-demo">

```gjs live preview no-shadow
import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { Drawer } from "ember-primitives";
import { waitForPromise } from "@ember/test-waiters";

import { loremIpsum } from "lorem-ipsum";

export default class ExternalTrigger extends Component {
  @tracked _isOpen = false;

  openDrawer = () => {
    this._isOpen = true;
  };

  closeDrawer = () => {
    this._isOpen = false;
  };

  <template>
    <button onclick={{this.openDrawer}}>Open Drawer</button>

    <br /><br />
    isOpen :
    {{this._isOpen}}

    <DrawerWrapper @isOpen={{this._isOpen}} @onClose={{this.closeDrawer}} as |d|>

      {{loremIpsum 1}}

      <button onclick={{d.close}}>Close</button>
    </DrawerWrapper>
  </template>
}

const DrawerWrapper = <template>
  <Drawer @onClose={{@onClose}} as |d|>
    {{(sideEffect toggle @isOpen d)}}

    <d.Drawer>
      {{yield d}}
    </d.Drawer>
  </Drawer>
</template>;

function toggle(wantsOpen, { open, close, isOpen }) {
  if (wantsOpen) {
    if (isOpen) return;
    open();
    return;
  }

  if (!isOpen) return;

  close();
}

function sideEffect(func, ...args) {
  waitForPromise(
    (async () => {
      // auto tracking is synchronous.
      // This detaches from tracking frames.
      await Promise.resolve();
      func(...args);
    })(),
  );
}
```

</div>

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

## Install

```hbs live
<SetupInstructions @src="components/drawer.gts" />
```

## Anatomy

```js 
import { Drawer } from 'ember-primitives';
```

or for non-tree-shaking environments:
```js 
import { Drawer } from 'ember-primitives/components/drawer';
```


```gjs 
import { Drawer } from 'ember-primitives';

<template>
  <Drawer as |d|>

    d.isOpen
    d.open
    d.close

    <d.Drawer ...attributes>
      this is just the HTMLDialogElement
    </d.Drawer>
  </Drawer>
</template>
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature 
    @package="ember-primitives" 
    @module="declarations/components/drawer" 
    @name="Signature" />
</template>
```

### State Attributes

There is no root element for this component, so there are no state attributes to use.
Since this component uses the `<dialog>` element, it will still use the `open` attribute.

## Accessibility

Once the drawer is open, the browser will focus on the first button (in this case, it's our close button on the drawer header) or any button with the autofocus attribute within the drawer. When you close the drawer, the browser restores the focus on the button we used to open it.

### Keyboard Interactions

The dialog element handles ESC (escape) key events automatically, hence reducing the burdens and efforts required to provide an effortless experience for users while working with drawers.

However, if you want to add an animation effect on _closing_ and opening drawer programmatically, note that you will lose this built-in feature support and have to implement the tab navigation focus yourself.

When the drawer is closed, you can refocus the opening button when the `{{d.focusOnClose}}` modifier is applied to that button.


## References

- [MDN HTMLDialogElement](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/dialog)
- [web.dev : Building a dialog component](https://web.dev/building-a-dialog-component/)
- [Open Props](https://open-props.style)[^animations]

<hr>

[^animations]: Animations in the examples are provided by Open Props 
