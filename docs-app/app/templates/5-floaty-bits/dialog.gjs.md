# Dialog

A small utility component. It renders a modal `<dialog>` around its block, and yields `open` and `close` already wired to that element.

Everything inside is hidden until it opens, and a trigger cannot sit outside it, so this is for content that opens and closes itself: a key combination, a router hook, anything that already has a reason to run. When a button beside the dialog is what opens it, use [`<Modal>`](/5-floaty-bits/modal.md) instead, which hands you the element to place.

Here that content is a [`<CommandPalette>`](/5-floaty-bits/command-palette.md), which takes `open` for its hotkey and `close` for its selection:

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { CommandPalette, Dialog } from "ember-primitives";
import { tracked } from "@glimmer/tracking";

const COMMANDS = ["New File", "New Folder", "Find in Files", "Open Settings"];

const query = tracked("");
const setQuery = (value) => (query.value = value);
const matching = (term) =>
  COMMANDS.filter((command) => command.toLowerCase().includes(term.trim().toLowerCase()));

<template>
  <p>Press <kbd>Ctrl</kbd> / <kbd>⌘</kbd> + <kbd>K</kbd>.</p>

  <Dialog closedby="any" as |d|>
    <CommandPalette
      @items={{(matching query.value)}}
      @onQueryChange={{setQuery}}
      @onSelect={{d.close}}
      @onOpen={{d.open}}
      @hotkey="mod+k"
      @placeholder="Type a command…"
    />
  </Dialog>

  <style>
    @scope (dialog) {
      :scope {
        --surface: light-dark(#ffffff, #1c1c1f);
        --text: light-dark(#111827, #f4f4f5);
        --muted: light-dark(#5b6472, #a9b1bd);
        --border: light-dark(#e5e7eb, #3f3f46);
        --active: light-dark(#eef2f7, #2a2a30);
        --ring: light-dark(#1d4ed8, #93c5fd);
      }

      :scope {
        width: min(90vw, 26rem);
        margin-block: 12vh auto;
        margin-inline: auto;
        padding: 0;
        border: none;
        border-radius: 12px;
        background: var(--surface);
        color: var(--text);
      }

      :scope::backdrop {
        background: rgb(0 0 0 / 0.45);
      }

      input {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        /* the dialog scrolls, so it clips; matching its corners keeps the
           focus ring, which follows this radius, out of the clipped area */
        border-radius: 12px 12px 0 0;
        border-block-end: 1px solid var(--border);
        background: none;
        color: var(--text);
        font: inherit;
      }

      /*
       * The site's focus ring is a box-shadow, which draws outside the
       * element and so is clipped by a full-bleed input in a rounded box.
       * This one is drawn inside the input instead. Matching the role as
       * well as the element clears the site rule's specificity, which CSS
       * nesting takes from the most specific selector in its list.
       */
      :scope input[role="combobox"]:focus-visible {
        box-shadow: none;
        outline: 2px solid var(--ring);
        outline-offset: -2px;
        border-radius: 12px 12px 0 0;
      }

      [role="listbox"] {
        padding: 0.4rem;
      }

      [role="option"] {
        padding: 0.5rem 0.75rem;
        border-radius: 6px;
        cursor: pointer;
      }

      [role="option"][data-active="true"] {
        background: var(--active);
      }
    }

  </style>
</template>
```

</div>

## What the browser already does

- <kbd>Escape</kbd> closes it.
- Focus moves into the dialog when it opens, and back to whatever had it when it closes.
- The rest of the page is inert while it is open, and `::backdrop` styles the layer behind it.

[`closedby`][mdn-closedby] controls which actions dismiss the dialog. `<Dialog>` does not set it, so pass it for click-outside:

```hbs
<Dialog closedby="any" as |d|>
```

## Install

```hbs live
<SetupInstructions @src="components/dialog.gts" @since="0.62.0" />
```

## Accessibility

Adheres to the [Dialog (Modal) WAI-ARIA design pattern][apg-dialog]. The `<dialog>` element does all of it: focus moves in on open, stays there while open, and returns on close.

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/dialog"
    @name="SimpleSignature"
  />
</template>
```

[mdn-closedby]: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/dialog#closedby
[apg-dialog]: https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/
