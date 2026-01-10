# Drawer

A drawer is a sliding panel that appears from the side of the screen, typically used for navigation, filters, or additional content.
It is built on top of the native `<dialog>` element, similar to modals, but designed to slide in from a specific side of the viewport.

<Callout>

This pattern of a sliding drawer / sheet can be done with only the native `<dialog>` and some `<button>` to open it. This component is a _very_ small wrapper for this pattern -- primarily a state container for easily controlling the open state of the `<dialog>` element without wiring it up yourself.

</Callout>


<div class="featured-demo">

```gjs live preview no-shadow
import { Drawer } from 'ember-primitives/components/drawer';
import { on } from '@ember/modifier';

<template>
  <Drawer as |d|>
    <button {{on 'click' d.open}}>Open Drawer</button>

    <d.Drawer class="not-prose">
      <header>
        <h2>Example Drawer</h2>
        <button {{on 'click' d.close}}>Close</button>
      </header>
      <form method="dialog">
        <main>
          Drawer content here
          <br>
          Because this is a native dialog element, it captures focus,
          and pressing escape will close the dialog and return focus to the 
          original button.
        </main>

        <footer>
          <button type="submit" value="confirm">Confirm</button>
          <button type="submit" value="create">Create</button>
        </footer>
      </form>
    </d.Drawer>
  </Drawer>

  <link rel="stylesheet" href="https://unpkg.com/open-props/easings.min.css"/>
  <style>
    @scope {
      dialog {
        transition: 
          display 0.125s allow-discrete, 
          overlay 0.125s allow-discrete;
        animation: close 0.125s forwards;

        &[open] {
          animation: open 0.25s forwards;
        }
      }

      @keyframes open {
        from {
          opacity: 0;
          transform: translate(0, 100%);
        }
        to {
          opacity: 1;
          transform: translate(0, 0);
        }
      }

      @keyframes close {
        from {
          opacity: 1;
          transform: translate(0, 0);
        }
        to {
          opacity: 0;
          transform: translate(0, 100%);
        }
      }

    }

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
        position: fixed;
        top: unset;
        bottom: 0px;
        color: black;
        background: white;
        margin: 0 auto;
        min-width: 80dvw;
        border-top-right-radius: 0.5rem;
        border-top-left-radius: 0.5rem;

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
    }
  </style>
</template>
```

</div>

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


