# Command Palette

A combobox over a listbox. The <kbd>⌘</kbd><kbd>K</kbd> pattern.

`<CommandPalette>` gives you the input, the keyboard, and the aria wiring. It does not filter, and it does not open or close anything. Put it inside a [`<Dialog>`](/5-floaty-bits/dialog.md) for the <kbd>⌘</kbd><kbd>K</kbd> case, or render it on a page of its own.

<div class="featured-demo">

```gjs live preview no-shadow
import { CommandPalette, Dialog } from "ember-primitives";
import { fn } from "@ember/helper";
import { tracked } from "@glimmer/tracking";

const ran = tracked("");

/**
 * `@onSelect` is handed the entry, so this is both what the row does and
 * where the dialog closes. `close` is curried in from the block.
 */
const run = (close, command) => {
  ran.value = command.label;
  close();
};

const query = tracked("");
const setQuery = (value) => (query.value = value);
const matching = (term) =>
  COMMANDS.filter((command) => command.label.toLowerCase().includes(term.trim().toLowerCase()));

const COMMANDS = [
  {
    icon: "📄",
    label: "New File",
    description: "Create a file in this folder"
  },
  { icon: "📁", label: "New Folder", description: "Create a folder" },
  {
    icon: "🔍",
    label: "Find in Files",
    description: "Search the whole project"
  },
  {
    icon: "⚙️",
    label: "Open Settings",
    description: "Preferences and keybindings"
  },
  {
    icon: "🌓",
    label: "Toggle Theme",
    description: "Switch between light and dark"
  },
];

<template>
  <Dialog as |d|>
    <CommandPalette
      @items={{(matching query.value)}}
      @onQueryChange={{setQuery}}
      @onSelect={{fn run d.close}}
      @onOpen={{d.open}}
      @hotkey="mod+k"
      @placeholder="Type a command…"
    />
  </Dialog>

  <p>Press <kbd>Ctrl</kbd> / <kbd>⌘</kbd> + <kbd>K</kbd> to open it.</p>

  {{#if ran.value}}
    <p class="last-run">Ran: <strong>{{ran.value}}</strong></p>
  {{/if}}

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
        width: min(90vw, 34rem);
        margin-block: 12vh auto;
        margin-inline: auto;
        padding: 0;
        border: none;
        border-radius: 12px;
        background: var(--surface);
        color: var(--text);
        box-shadow: 0 25px 50px -12px rgb(0 0 0 / 0.35);
      }

      :scope::backdrop {
        background: rgb(0 0 0 / 0.45);
      }

      input {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        /* the focus ring follows this radius, so it matches the container's
           corners rather than being clipped by them */
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
        max-height: 18rem;
        overflow-y: auto;
        padding: 0.5rem;
      }

      [role="option"] {
        display: grid;
        grid-template-columns: 1.5rem 1fr;
        gap: 0 0.75rem;
        padding: 0.5rem 0.75rem;
        border-radius: 8px;
        cursor: pointer;
      }

      /* the pointer and the keyboard set the same one. Do not use :hover */
      [role="option"][data-active="true"] {
        background: var(--active);
      }

      [role="option"] > :first-child {
        grid-row: span 2;
      }

      [role="option"] > :last-child {
        color: var(--muted);
        font-size: 0.875rem;
      }
    }

    .last-run {
      margin-block-start: 0.75rem;
    }
  </style>
</template>
```

</div>

## Without a modal

Leave out the `<Dialog>` and the palette is a search box with a list under it, for a page a reader can link to.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { CommandPalette } from "ember-primitives";
import { tracked } from "@glimmer/tracking";

const opened = tracked("");
const query = tracked("");
const setQuery = (value) => (query.value = value);
const matching = (term) =>
  PAGES.filter((page) => page.label.toLowerCase().includes(term.trim().toLowerCase()));

const PAGES = [
  { label: "Installation", description: "Adding ember-primitives to an app" },
  { label: "Accordion", description: "A vertically stacked set of headings" },
  { label: "Dialog", description: "A modal window over the page" },
];

const go = (page) => (opened.value = page.label);

<template>
  <div class="inline-palette">
    <CommandPalette
      @items={{(matching query.value)}}
      @onQueryChange={{setQuery}}
      @onSelect={{go}}
      @placeholder="Search the docs…"
    />
  </div>

  {{#if opened.value}}
    <p>Opened: <strong>{{opened.value}}</strong></p>
  {{/if}}

  <style>
    @scope (.inline-palette) {
      :scope {
        --surface: light-dark(#ffffff, #1c1c1f);
        --text: light-dark(#111827, #f4f4f5);
        --muted: light-dark(#5b6472, #a9b1bd);
        --border: light-dark(#e5e7eb, #3f3f46);
        --active: light-dark(#eef2f7, #2a2a30);
        --ring: light-dark(#1d4ed8, #93c5fd);
      }

      :scope {
        max-width: 30rem;
        margin-inline: auto;
        border: 1px solid var(--border);
        border-radius: 10px;
        background: var(--surface);
        color: var(--text);
      }

      input {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        /* the focus ring follows this radius, so it matches the container's
           corners rather than being clipped by them */
        border-radius: 10px 10px 0 0;
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
        border-radius: 10px 10px 0 0;
      }

      [role="listbox"] {
        padding: 0.4rem;
      }

      [role="option"] {
        display: grid;
        padding: 0.5rem 0.75rem;
        border-radius: 6px;
        cursor: pointer;
      }

      [role="option"][data-active="true"] {
        background: var(--active);
      }

      [role="option"] > :last-child {
        color: var(--muted);
        font-size: 0.875rem;
      }
    }
  </style>
</template>
```

</div>

## Rendering your own rows

Leave `@items` off and pass a block instead. Then you render the rows. Choosing is still delegated, so a row is markup rather than a listener, and `@onSelect` is handed the event that reached it.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { CommandPalette } from "ember-primitives";
import { tracked } from "@glimmer/tracking";

const picked = tracked("");

const PEOPLE = [
  {
    name: "Ada Lovelace",
    role: "Mathematician",
    note: "Wrote the first algorithm intended for a machine, and the notes explaining why it mattered.",
  },
  {
    name: "Grace Hopper",
    role: "Rear Admiral",
    note: "Built the first compiler, then spent decades arguing that programming should read like English.",
  },
  {
    name: "Karen Spärck Jones",
    role: "Computer Scientist",
    note: "Gave search engines inverse document frequency, which is why ranking works at all.",
  },
];

const matching = (query) =>
  PEOPLE.filter((person) => person.name.toLowerCase().includes(query.toLowerCase().trim()));

/**
 * Choosing is delegated, so a row carries no handler. The block form's
 * `@onSelect` is handed the event, and the row is `event.target.closest`.
 */
const pick = (event) => {
  picked.value = event.target.closest("[role=option]").dataset.name;
};

<template>
  <div class="people">
    <CommandPalette @onSelect={{pick}} as |c|>
      <c.Input placeholder="Search people…" aria-label="Search people" />

      <c.List as |l|>
        {{#each (matching c.query) as |person|}}
          <l.Item data-name={{person.name}}>
            <p class="who">
              <strong>{{person.name}}</strong>
              <span>{{person.role}}</span>
            </p>
            <p class="note">{{person.note}}</p>
          </l.Item>
        {{else}}
          <p class="empty">Nobody matches “{{c.query}}”.</p>
        {{/each}}
      </c.List>
    </CommandPalette>
  </div>

  {{#if picked.value}}
    <p>Picked: <strong>{{picked.value}}</strong></p>
  {{/if}}

  <style>
    @scope (.people) {
      :scope {
        --surface: light-dark(#ffffff, #1c1c1f);
        --text: light-dark(#111827, #f4f4f5);
        --muted: light-dark(#5b6472, #a9b1bd);
        --border: light-dark(#e5e7eb, #3f3f46);
        --active: light-dark(#eef2f7, #2a2a30);
        --ring: light-dark(#1d4ed8, #93c5fd);
      }

      :scope {
        max-width: 32rem;
        margin-inline: auto;
        border: 1px solid var(--border);
        border-radius: 10px;
        background: var(--surface);
        color: var(--text);
      }

      input {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        /* the focus ring follows this radius, so it matches the container's
           corners rather than being clipped by them */
        border-radius: 10px 10px 0 0;
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
        border-radius: 10px 10px 0 0;
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

      .who {
        display: flex;
        gap: 0.5rem;
        align-items: baseline;
        margin: 0;
      }

      .who span {
        color: var(--muted);
        font-size: 0.8rem;
      }

      /* a description that runs to several lines wraps rather than clipping */
      .note {
        margin: 0.15rem 0 0;
        color: var(--muted);
        font-size: 0.875rem;
        line-height: 1.4;
      }

      .empty {
        padding: 1rem;
        text-align: center;
        color: var(--muted);
      }
    }
  </style>
</template>
```

</div>

## Results from a request

`@items` does not have to hold anything when the reader types. Set it once the request answers, and the palette re-activates the top row, so <kbd>Enter</kbd> still chooses the best match.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { CommandPalette } from "ember-primitives";
import { tracked } from "@glimmer/tracking";
import { getPromiseState } from "reactiveweb/get-promise-state";

const EMPTY = [];

const query = tracked("");
const setQuery = (value) => (query.value = value);

const planets = new Map();
const planetName = async (url) => {
  if (!planets.has(url)) {
    planets.set(
      url,
      fetch(url)
        .then((response) => response.json())
        .then((planet) => planet.name),
    );
  }

  return planets.get(url);
};

const load = async (term) => {
  const response = await fetch(`https://swapi.dev/api/people/?search=${encodeURIComponent(term)}`);
  const { results } = await response.json();

  return Promise.all(
    results.map(async (person) => ({
      label: person.name,
      description: `born ${person.birth_year} · ${person.height}cm · ${await planetName(person.homeworld)}`,
    })),
  );
};

/**
 * `getPromiseState` keys its state off the promise it is handed, so the same
 * search has to hand back the same promise. A new one per render would mean a
 * new pending state per render, and it would never settle.
 */
const searches = new Map();
const search = (term) => {
  const key = term.trim().toLowerCase();

  if (key.length < 2) return undefined;
  if (!searches.has(key)) searches.set(key, load(key));

  return searches.get(key);
};

<template>
  {{#let (getPromiseState (search query.value)) as |state|}}
    <div class="swapi">
      <CommandPalette
        @items={{if state.resolved state.resolved EMPTY}}
        @onQueryChange={{setQuery}}
        @placeholder="Search Star Wars characters…"
      />

      <p class="status" role="status">
        {{#if state.isLoading}}
          Searching…
        {{else if state.error}}
          The API did not answer
        {{else if state.resolved.length}}
          {{state.resolved.length}}
          found
        {{else if state.resolved}}
          Nobody matches “{{query.value}}”
        {{else}}
          Type a name: luke, skywalker, r2…
        {{/if}}
      </p>
    </div>
  {{/let}}

  <style>
    @scope (.swapi) {
      :scope {
        --surface: light-dark(#ffffff, #1c1c1f);
        --text: light-dark(#111827, #f4f4f5);
        --muted: light-dark(#5b6472, #a9b1bd);
        --border: light-dark(#e5e7eb, #3f3f46);
        --active: light-dark(#eef2f7, #2a2a30);
        --ring: light-dark(#1d4ed8, #93c5fd);
      }

      :scope {
        max-width: 32rem;
        margin-inline: auto;
        border: 1px solid var(--border);
        border-radius: 10px;
        background: var(--surface);
        color: var(--text);
      }

      input {
        width: 100%;
        padding: 0.75rem 1rem;
        border: none;
        /* the focus ring follows this radius, so it matches the container's
           corners rather than being clipped by them */
        border-radius: 10px 10px 0 0;
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
        border-radius: 10px 10px 0 0;
      }

      [role="listbox"] {
        max-height: 14rem;
        overflow-y: auto;
        padding: 0.4rem;
      }

      [role="option"] {
        display: grid;
        padding: 0.5rem 0.75rem;
        border-radius: 6px;
        cursor: pointer;
      }

      [role="option"][data-active="true"] {
        background: var(--active);
      }

      [role="option"] > :last-child {
        color: var(--muted);
        font-size: 0.875rem;
      }

      .status {
        margin: 0;
        padding: 0.6rem 1rem;
        border-block-start: 1px solid var(--border);
        color: var(--muted);
        font-size: 0.8rem;
      }
    }
  </style>
</template>
```

</div>

Only the source of the rows changed. `@onQueryChange` starts the request, `@items` takes what comes back, and the palette does the rest.

`LinkItem` is a row that is also a link. <kbd>Enter</kbd> dispatches a real click on the anchor, so the router navigates exactly as it would have for a mouse, and <kbd>⌘</kbd>-click still opens a new tab.

`LinkItem` needs [`properLinks`](/4-routing/proper-links.md) set up in the application route for a plain `<a href>` support.

```hbs
<c.List as |l|>
  {{#each this.results as |result|}}
    <l.LinkItem @href={{result.path}}>{{result.title}}</l.LinkItem>
  {{/each}}
</c.List>
```

## Closing, and opening

The palette does not open or close anything by itself. Hand it the two functions [`<Dialog>`](/5-floaty-bits/dialog.md) yields:

```hbs
<Dialog as |d|>
  <CommandPalette
    @items={{this.commands}}
    @onSelect={{d.close}}
    @onOpen={{d.open}}
    @hotkey="mod+k"
  />
</Dialog>
```

`<Dialog>` renders the element, so a trigger cannot sit outside it. That suits a palette, which opens on a key combination. When a button opens it instead, use [`<Modal>`](/5-floaty-bits/modal.md). The palette composes with either.

`@onSelect` runs every time a row is chosen, whichever row and however it was rendered. That is why `d.close` is all it takes to close on select. What a row does belongs to the row: `onSelect` on its `@items` entry, or `@onSelect` on its `Item`.

`@hotkey` calls `@onOpen`. Without `@onOpen` there is nothing to open, and no listener is installed.

## Styling

The active row carries `data-active="true"` and `aria-selected="true"`. Style either.

Do not use `:hover` for this. The pointer and the keyboard set the same active row, so one selector covers both, and the two can never disagree about what <kbd>Enter</kbd> will do.

## Install

```hbs live
<SetupInstructions @src="components/command-palette.gts" @since="0.62.0" />
```

## Accessibility

Adheres to the [Combobox WAI-ARIA design pattern][apg-combobox], in its list-autocomplete form: the `<input>` is the combobox, the rows are its listbox, and `aria-activedescendant` reports the active row without moving focus.

### Keyboard Interactions

|                   key                   | description                                                                                   |
| :-------------------------------------: | :-------------------------------------------------------------------------------------------- |
|            `@hotkey`, if set            | Opens the surrounding `<Modal>` from anywhere on the page.                                    |
| <kbd>ArrowDown</kbd> <kbd>ArrowUp</kbd> | Moves the active row, wrapping at either end. Focus does not move.                            |
|            <kbd>Enter</kbd>             | Chooses the active row, or the first row when you have not moved yet.                         |
|             <kbd>Esc</kbd>              | Closes the `<Modal>` and returns focus to whatever opened it. Handled by the browser.         |
|     <kbd>Home</kbd> <kbd>End</kbd>      | Left to the browser: in a text field these move the caret, so the palette does not take them. |

## API Reference

`Signature` is a union of the two forms, so each is documented on its own rather than as one shape with arguments that only apply half the time.

### With `@items`

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/command-palette"
    @name="ItemsSignature"
  />
</template>
```

### With a block

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/command-palette"
    @name="BlockSignature"
  />
</template>
```

### Item

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/command-palette"
    @name="ItemSignature"
  />
</template>
```

### LinkItem

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/command-palette"
    @name="LinkItemSignature"
  />
</template>
```

[apg-combobox]: https://www.w3.org/WAI/ARIA/apg/patterns/combobox/
