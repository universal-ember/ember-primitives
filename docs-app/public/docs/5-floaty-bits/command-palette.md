# Command Palette

A command palette is a modal dialog that provides quick access to commands and actions through a searchable interface. It's a common pattern in modern applications for power users to navigate and execute actions quickly via keyboard.

The `<CommandPalette>` component is built with the `<Dialog>` primitive and provides keyboard navigation via Tabster. It follows the [WAI-ARIA Combobox Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/) for accessibility.

## Features

- **Styleless**: No CSS shipped; only structure, semantics, and state management
- **Accessible**: Proper ARIA roles and attributes for screen readers
- **Keyboard Navigation**: Arrow keys navigate through items, Escape closes the palette
- **Focus Management**: Focus is trapped within the dialog when open and returned to the trigger when closed
- **Composable**: Build your own search/filtering logic with full control over rendering

## Example

<div class="featured-demo">

```gjs live preview no-shadow
import { CommandPalette } from 'ember-primitives';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';

class Demo {
  @tracked searchQuery = '';

  commands = [
    { id: 1, name: 'Create new file', category: 'File' },
    { id: 2, name: 'Open file', category: 'File' },
    { id: 3, name: 'Save file', category: 'File' },
    { id: 4, name: 'Search in files', category: 'Search' },
    { id: 5, name: 'Find and replace', category: 'Search' },
    { id: 6, name: 'Toggle sidebar', category: 'View' },
    { id: 7, name: 'Toggle terminal', category: 'View' },
  ];

  get filteredCommands() {
    if (!this.searchQuery) {
      return this.commands;
    }

    const query = this.searchQuery.toLowerCase();
    return this.commands.filter(cmd => 
      cmd.name.toLowerCase().includes(query) ||
      cmd.category.toLowerCase().includes(query)
    );
  }

  handleInput = (event) => {
    this.searchQuery = event.target.value;
  };

  selectCommand = (command) => {
    console.log('Selected:', command.name);
  };
}

const state = new Demo();

<template>
  <CommandPalette as |cp|>
    <button 
      type="button" 
      class="trigger" 
      {{on "click" cp.open}} 
      {{cp.focusOnClose}}
    >
      Open Command Palette (Cmd+K)
    </button>

    <cp.Dialog class="dialog-wrapper">
      <div class="palette">
        <cp.Input 
          class="search-input"
          placeholder="Type a command or search..." 
          value={{state.searchQuery}}
          {{on "input" state.handleInput}}
        />
        
        <cp.List class="command-list">
          {{#if state.filteredCommands.length}}
            {{#each state.filteredCommands as |command|}}
              <cp.Item 
                class="command-item"
                @onSelect={{fn state.selectCommand command}}
              >
                <div class="command-name">{{command.name}}</div>
                <div class="command-category">{{command.category}}</div>
              </cp.Item>
            {{/each}}
          {{else}}
            <div class="no-results">No commands found</div>
          {{/if}}
        </cp.List>
      </div>
    </cp.Dialog>
  </CommandPalette>

  <style>
    .trigger {
      padding: 8px 16px;
      background: #fff;
      border: 1px solid #d1d5db;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      box-shadow: 0 1px 2px 0 rgb(0 0 0 / 0.05);
    }

    .trigger:hover {
      background: #f9fafb;
    }

    dialog {
      padding: 0;
      border: none;
      border-radius: 12px;
      box-shadow: 0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1);
      max-width: 600px;
      width: 90vw;
    }

    dialog::backdrop {
      background: rgba(0, 0, 0, 0.5);
      backdrop-filter: blur(4px);
    }

    .dialog-wrapper {
      display: flex;
      flex-direction: column;
      max-height: 60vh;
    }

    .palette {
      display: flex;
      flex-direction: column;
      overflow: hidden;
    }

    .search-input {
      all: unset;
      padding: 16px 20px;
      font-size: 16px;
      border-bottom: 1px solid #e5e7eb;
    }

    .search-input::placeholder {
      color: #9ca3af;
    }

    .command-list {
      all: unset;
      display: flex;
      flex-direction: column;
      overflow-y: auto;
      max-height: 400px;
      padding: 8px 0;
    }

    .command-item {
      all: unset;
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 12px 20px;
      cursor: pointer;
    }

    .command-item:focus {
      background: #f3f4f6;
      outline: none;
    }

    .command-name {
      font-size: 14px;
      color: #111827;
    }

    .command-category {
      font-size: 12px;
      color: #6b7280;
      background: #f3f4f6;
      padding: 2px 8px;
      border-radius: 4px;
    }

    .no-results {
      padding: 20px;
      text-align: center;
      color: #6b7280;
      font-size: 14px;
    }
  </style>
</template>
```

</div>

## API

### `<CommandPalette>`

The root component that manages the command palette state.

#### Arguments

- `@open` (optional, `boolean`) - Set the initial open state of the command palette
- `@onClose` (optional, `() => void`) - Callback invoked when the palette is closed

#### Yields

- `isOpen` (`boolean`) - Current open state of the palette
- `open` (`() => void`) - Function to open the palette
- `close` (`() => void`) - Function to close the palette
- `focusOnClose` (`Modifier`) - Modifier to apply to the trigger element for focus management
- `Dialog` (`Component`) - Dialog wrapper component
- `Input` (`Component`) - Search input component
- `List` (`Component`) - List container component
- `Item` (`Component`) - Individual item component

### `<cp.Dialog>`

The dialog wrapper for the command palette. Wraps the `<dialog>` element.

### `<cp.Input>`

The search input element with proper ARIA attributes for the combobox pattern.

#### Attributes

All standard `<input>` attributes are supported (e.g., `placeholder`, `value`).

### `<cp.List>`

The container for command palette items. Handles keyboard navigation via Tabster.

### `<cp.Item>`

An individual item in the command palette.

#### Arguments

- `@onSelect` (optional, `(event: Event) => void`) - Callback invoked when the item is selected

## Keyboard Interaction

- **Arrow Down**: Move focus to the next item (cycles to first when at end)
- **Arrow Up**: Move focus to the previous item (cycles to last when at beginning)
- **Tab**: Move focus between input and list
- **Escape**: Close the command palette
- **Click**: Select an item and close the palette

## Accessibility

The Command Palette follows the [ARIA Combobox Pattern](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/) with the following features:

- `role="combobox"` on the input element
- `role="listbox"` on the list container
- `role="option"` on each item
- `aria-controls` linking input to list
- `aria-labelledby` linking list to input
- `aria-expanded` indicating open state
- Focus trap within the dialog when open
- Focus restoration to trigger when closed

## Examples

### Basic Usage

```gjs
import { CommandPalette } from 'ember-primitives';
import { on } from '@ember/modifier';

<template>
  <CommandPalette as |cp|>
    <button {{on "click" cp.open}} {{cp.focusOnClose}}>
      Open Commands
    </button>

    <cp.Dialog>
      <cp.Input placeholder="Search commands..." />
      <cp.List>
        <cp.Item>New File</cp.Item>
        <cp.Item>Open File</cp.Item>
        <cp.Item>Save</cp.Item>
      </cp.List>
    </cp.Dialog>
  </CommandPalette>
</template>
```

### With Search Filtering

```gjs
import { CommandPalette } from 'ember-primitives';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';

class MyComponent {
  @tracked query = '';

  commands = ['New File', 'Open File', 'Save', 'Close'];

  get filtered() {
    return this.commands.filter(cmd => 
      cmd.toLowerCase().includes(this.query.toLowerCase())
    );
  }

  handleInput = (e) => {
    this.query = e.target.value;
  };
}

const state = new MyComponent();

<template>
  <CommandPalette as |cp|>
    <button {{on "click" cp.open}} {{cp.focusOnClose}}>Commands</button>

    <cp.Dialog>
      <cp.Input 
        placeholder="Search..." 
        value={{state.query}}
        {{on "input" state.handleInput}}
      />
      <cp.List>
        {{#each state.filtered as |cmd|}}
          <cp.Item>{{cmd}}</cp.Item>
        {{/each}}
      </cp.List>
    </cp.Dialog>
  </CommandPalette>
</template>
```

### With Selection Handler

```gjs
import { CommandPalette } from 'ember-primitives';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

function handleSelect(commandId) {
  console.log('Selected:', commandId);
  // Execute command logic here
}

<template>
  <CommandPalette as |cp|>
    <button {{on "click" cp.open}} {{cp.focusOnClose}}>Commands</button>

    <cp.Dialog>
      <cp.Input placeholder="Search..." />
      <cp.List>
        <cp.Item @onSelect={{fn handleSelect "new"}}>New File</cp.Item>
        <cp.Item @onSelect={{fn handleSelect "open"}}>Open File</cp.Item>
        <cp.Item @onSelect={{fn handleSelect "save"}}>Save</cp.Item>
      </cp.List>
    </cp.Dialog>
  </CommandPalette>
</template>
```

### Controlled Open State

```gjs
import { CommandPalette } from 'ember-primitives';
import { tracked } from '@glimmer/tracking';

class Controller {
  @tracked isOpen = false;

  open = () => { this.isOpen = true; };
  close = () => { this.isOpen = false; };
}

const state = new Controller();

<template>
  <button {{on "click" state.open}}>Open</button>

  <CommandPalette @open={{state.isOpen}} @onClose={{state.close}} as |cp|>
    <cp.Dialog>
      <cp.Input placeholder="Search..." />
      <cp.List>
        <cp.Item>Command 1</cp.Item>
        <cp.Item>Command 2</cp.Item>
      </cp.List>
    </cp.Dialog>
  </CommandPalette>
</template>
```

## Implementation Notes

- The Command Palette is built on top of the native `<dialog>` element, providing native modal behavior
- Keyboard navigation is powered by [Tabster](https://tabster.io/), which handles focus movement between items
- The component is completely styleless - you have full control over the appearance
- Search/filtering logic is not built-in, allowing you to implement custom filtering strategies
- Focus is automatically moved to the input when the palette opens
- The palette closes automatically when an item is selected or when Escape is pressed
