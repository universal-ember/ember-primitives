# Drawer

A drawer is a sliding panel that appears from the side of the screen, typically used for navigation, filters, or additional content.
It is built on top of the native `<dialog>` element, similar to modals, but designed to slide in from a specific side of the viewport.

Drawers are commonly used for:
- Side navigation menus
- Filter panels
- Settings panels
- Additional contextual information

<Callout>

This pattern of a sliding drawer / sheet can be done with only the native `<dialog>` and some `<button>` to open it. This component is a _very_ small wrapper for this pattern -- primarily a state container for easily controlling the open state of the `<dialog>` element without wiring it up yourself.

</Callout>


<div class="featured-demo">

```gjs live preview no-shadow
import { Drawer } from 'ember-primitives';

import { on } from '@ember/modifier';
import { cell } from 'ember-resources';
import { loremIpsum } from 'lorem-ipsum';

<template>
  <Drawer as |d|>
    <button {{on 'click' d.open}} {{d.focusOnClose}}>Open Drawer</button>

    <d.Drawer class="not-prose">
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
        </footer>
      </form>
    </d.Drawer>
  </Drawer>

  <link rel="stylesheet" href="https://unpkg.com/open-props" />
  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <link rel="stylesheet" href="https://unpkg.com/open-props/animations.min.css"/>
  <style>
@scope {
[data-repl-output] {
  display: block;
}
button {
  padding: 0.5rem 1rem;
  border-radius: 0.25rem;;

  background-color: #2563eb;   /* blue */
  color: #ffffff;

  transition:
    background-color 120ms ease-out,
    box-shadow 120ms ease-out,
    transform 120ms ease-out;
}

button:hover {
  background-color: #1d4ed8;
}

button:active {
  transform: translateY(1px);
  box-shadow: 0 1px 2px rgba(15, 23, 42, 0.3) inset;
}

}
  @scope {

/* Basic reset for the dialog */
dialog {
  margin: 0;
  padding: 0;
  border: none;
  position: fixed;
  left: 0;
  right: 0;
  bottom: 100px;
  color: black;
  background: white;
  box-shadow: var(--shadow-4);
  margin: 0 auto;
  min-width: 80dvw;
  min-height: 30dvh;

  main {
    padding: 1rem;
  }

  header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0.5rem 1rem;
    border-bottom: 1px solid color-mix(in srgb, currentColor 10%, transparent);

    h2 {
      font-size: 1.5rem;
    }
  }

  footer {
    display: flex;
    justify-content: flex-end;
    gap: 2rem;
    padding: 1rem;
  }
}

/* backdrop */
dialog::backdrop {
  background: color-mix(in srgb, #020617 60%, transparent);
}

dialog[open] {
  bottom: 0;

  /* Open Props slide-up animation */
  animation: var(--animation-slide-in-up), var(--animation-slide-in-down);
  animation-duration: 250ms;
  animation-timing-function: var(--ease-spring-3);
}

@media (prefers-reduced-motion: reduce) {
  dialog[open] {
    animation: none;
  }
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

## Install

```hbs live
<SetupInstructions @src="components/drawer.gts" />
```

## Anatomy

```gjs 
import { Drawer } from 'ember-primitives/components/drawer';

<template>
  <Drawer as |d|>

    d.isOpen - boolean
    d.open   - function
    d.close  - function

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
