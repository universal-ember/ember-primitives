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
        </footer>
      </form>
    </d.Drawer>
  </Drawer>

  <link rel="stylesheet" href="https://unpkg.com/open-props" />
  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <link rel="stylesheet" href="https://unpkg.com/open-props/animations.min.css"/>
  <style>
@scope {
button {
  /* Reset-ish */
  appearance: none;
  border: none;
  font: inherit;

  /* Layout */
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 0.35rem;
  padding: 0.45rem 0.9rem;
  border-radius: 999px;

  /* Colors */
  background-color: #2563eb;   /* blue */
  color: #ffffff;

  /* Text */
  font-size: 0.95rem;
  font-weight: 500;
  line-height: 1;

  /* Interaction */
  cursor: pointer;
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

/* Accessible focus state */
button:focus-visible {
  outline: 2px solid #1d4ed8;
  outline-offset: 2px;
}

/* Disabled state */
button:disabled,
button[aria-disabled="true"] {
  cursor: not-allowed;
  opacity: 0.6;
  box-shadow: none;
}

}
  @scope {

/* Basic reset for the dialog */
dialog {
  margin: 0;
  padding: 0;
  border: none;
}

/* Bottom sheet */
dialog[open] {
  position: fixed;

  /* kill UA centering */
  top: auto;
  left: 0;
  right: 0;
  transform: none;
  margin: 0;

  bottom: 0;                 /* anchor to bottom */
  width: 100vw;
  max-height: 80vh;

  display: flex;
  flex-direction: column;

  background: var(--surface-1, #fff);
  color: var(--text-1, #0f172a);
  border-radius: var(--radius-3, 1rem) 1rem 0 0;
  box-shadow: var(--shadow-4, 0 -10px 40px rgba(15, 23, 42, 0.25));
  font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;

  /* Open Props animation: slide up */
  animation: var(--animation-slide-in-up);
  animation-duration: 240ms; /* tighten duration if you want */
  animation-timing-function: var(--ease-spring-3, ease-out);
}

/* backdrop */
dialog::backdrop {
  background: color-mix(in srgb, #020617 60%, transparent);
}

/* content layout (same as before, just tightened a bit) */
dialog > header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--size-3, 0.75rem) var(--size-4, 1.25rem);
  border-bottom: 1px solid color-mix(in srgb, currentColor 10%, transparent);
}

dialog > header h2 {
  margin: 0 !important;
  font-size: var(--font-size-2, 1.1rem);
  font-weight: 600;
}

dialog > header > button {
  border: none;
  background: transparent;
  padding: 0.25rem 0.5rem;
  border-radius: 999px;
  cursor: pointer;
}

/* form fills the rest */
dialog > form {
  display: flex;
  flex-direction: column;
  min-height: 0;
  flex: 1;
}

dialog main {
  flex: 1;
  padding: var(--size-4, 1.25rem);
  overflow-y: auto;
  line-height: 1.5;
}

/* footer buttons */
dialog footer {
  display: flex;
  justify-content: flex-end;
  gap: var(--size-2, 0.5rem);
  padding: var(--size-3, 0.75rem) var(--size-4, 1.25rem);
  border-top: 1px solid color-mix(in srgb, currentColor 10%, transparent);
}

dialog footer button {
  appearance: none;
  border-radius: 999px;
  padding: 0.35rem 0.9rem;
  font-size: 0.9rem;
  font-weight: 500;
  border: 1px solid color-mix(in srgb, currentColor 18%, transparent);
  background: var(--surface-1, #fff);
  cursor: pointer;
}

dialog footer button[type="submit"] {
  background: var(--brand, #2563eb);
  border-color: var(--brand, #2563eb);
  color: #fff;
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
