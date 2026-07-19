# Resizable

Panels with draggable (and keyboard-operable) dividers between them.

Each `<Resizable>` is a flat row (or column) of panels -- but a panel may contain another `<Resizable>`, so layouts compose into arbitrary trees, the same way tiling window managers (i3, sway, tmux) model their screen.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Resizable } from 'ember-primitives';

<template>
  <div class="rz-demo">
    <Resizable as |r|>
      <r.Panel @minSize={{15}} @defaultSize={{25}}>
        <div class="rz-pane">sidebar</div>
      </r.Panel>
      <r.Handle aria-label="Resize sidebar" />
      <r.Panel>
        <Resizable @orientation="vertical" as |inner|>
          <inner.Panel>
            <div class="rz-pane">editor</div>
          </inner.Panel>
          <inner.Handle aria-label="Resize terminal" />
          <inner.Panel @minSize={{10}} @defaultSize={{30}} @collapsible={{true}}>
            <div class="rz-pane">terminal</div>
          </inner.Panel>
        </Resizable>
      </r.Panel>
    </Resizable>
  </div>
  <style>
    /* styles for the demo, not required */
    .rz-demo {
      height: 240px;
      border: 1px solid gray;
    }
    .rz-demo .rz-pane {
      display: grid;
      place-items: center;
      height: 100%;
      font-family: monospace;
    }
    .rz-demo .ember-primitives__resizable__handle {
      background: gray;
      opacity: 0.4;
    }
    .rz-demo .ember-primitives__resizable__handle:hover,
    .rz-demo .ember-primitives__resizable__handle:focus-visible,
    .rz-demo .ember-primitives__resizable__handle[data-resizing] {
      opacity: 1;
      background: dodgerblue;
    }
  </style>
</template>
```

</div>

## i3: a tree-based window manager

Because groups nest, a whole tiling window manager layout is just a tree of `<Resizable>`s.
Click a window to focus it, then split or kill it, i3wm style. Drag or <kbd>Tab</kbd> to the borders to resize.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { tracked } from '@glimmer/tracking';
import { TrackedArray } from 'tracked-built-ins';
import { Resizable } from 'ember-primitives';

const PROGRAMS = ['URxvt', 'firefox', 'emacs', 'htop', 'ncmpcpp', 'ranger', 'weechat', 'neomutt'];
const PROMPTS = ['~ $ ', '~/dev $ make', '*scratch*', 'MEM 42%', '♫ paused', '~/…/photos', '#ember', 'INBOX (3)'];
let launches = 0;

class AppWindow {
  @tracked title;
  content;

  constructor() {
    this.title = PROGRAMS[launches % PROGRAMS.length];
    this.content = PROMPTS[launches % PROMPTS.length];
    launches++;
  }
}

class Split {
  orientation;
  children;

  constructor(orientation, children) {
    this.orientation = orientation;
    this.children = new TrackedArray(children);
  }
}

const isSplit = (node) => node instanceof Split;

function findParent(node, target) {
  if (!isSplit(node)) return null;

  for (const child of node.children) {
    if (child === target) return node;

    const found = findParent(child, target);

    if (found) return found;
  }

  return null;
}

function firstWindow(node) {
  if (!isSplit(node)) return node;

  return node.children.length ? firstWindow(node.children[0]) : null;
}

class WindowManager {
  root = new Split('horizontal', [new AppWindow()]);
  @tracked focused = firstWindow(this.root);

  focus = (node) => (this.focused = node);

  split = (orientation) => {
    const win = new AppWindow();
    const { focused, root } = this;
    const parent = focused ? findParent(root, focused) : root;

    if (!parent) return;

    if (!focused) {
      root.children.push(win);
    } else if (parent.orientation === orientation) {
      // i3: splitting along the container's own axis just adds a sibling
      parent.children.splice(parent.children.indexOf(focused) + 1, 0, win);
    } else {
      // otherwise the focused window is wrapped in a new (nested) container
      const wrapped = new Split(orientation, [focused, win]);

      parent.children.splice(parent.children.indexOf(focused), 1, wrapped);
    }

    this.focused = win;
  };

  kill = () => {
    const { focused, root } = this;

    if (!focused) return;

    const parent = findParent(root, focused);

    if (!parent) return;

    parent.children.splice(parent.children.indexOf(focused), 1);

    // containers with a single child dissolve into their parent
    if (parent !== root && parent.children.length === 1) {
      const grandparent = findParent(root, parent);
      const only = parent.children[0];

      grandparent.children.splice(grandparent.children.indexOf(parent), 1, only);
    }

    this.focused = firstWindow(parent.children.length ? parent : root);
  };
}

const wm = new WindowManager();

const Tree = <template>
  {{#if (isSplit @node)}}
    <Resizable @orientation={{@node.orientation}} as |r|>
      {{#each @node.children as |child index|}}
        {{#if (gt index 0)}}
          <r.Handle aria-label="Resize window" />
        {{/if}}
        <r.Panel @minSize={{5}}>
          <Tree @node={{child}} />
        </r.Panel>
      {{/each}}
    </Resizable>
  {{else}}
    <button
      type="button"
      class="i3-window {{if (eq wm.focused @node) 'is-focused'}}"
      {{on "click" (fn wm.focus @node)}}
    >
      <span class="i3-title">{{@node.title}}</span>
      <span class="i3-body">{{@node.content}}</span>
    </button>
  {{/if}}
</template>;

<template>
  <div class="i3">
    <div class="i3-bar">
      <button type="button" {{on "click" (fn wm.split "horizontal")}}>$mod+Enter (split h)</button>
      <button type="button" {{on "click" (fn wm.split "vertical")}}>$mod+v (split v)</button>
      <button type="button" {{on "click" wm.kill}}>$mod+Shift+q (kill)</button>
      <span class="i3-status">1: {{if wm.focused wm.focused.title "(empty)"}}</span>
    </div>
    <div class="i3-workspace">
      <Tree @node={{wm.root}} />
    </div>
  </div>
  <style>
    /* styles for the demo, not required */
    .i3 {
      background: #000;
      border: 1px solid #333;
      font-family: monospace;
    }
    .i3-bar {
      display: flex;
      gap: 0.5rem;
      align-items: center;
      padding: 0.25rem 0.5rem;
      background: #111;
      border-bottom: 1px solid #333;
    }
    .i3-bar button {
      font: inherit;
      font-size: 0.75rem;
      color: #ccc;
      background: #222;
      border: 1px solid #444;
      padding: 0.125rem 0.5rem;
      cursor: pointer;
    }
    .i3-bar button:hover {
      border-color: #4c7899;
    }
    .i3-status {
      margin-left: auto;
      color: #888;
      font-size: 0.75rem;
    }
    .i3-workspace {
      height: 320px;
      padding: 3px;
    }
    .i3-window {
      display: flex;
      flex-direction: column;
      width: 100%;
      height: 100%;
      padding: 0;
      text-align: left;
      font: inherit;
      background: #0c0c0c;
      border: 2px solid #333;
      cursor: pointer;
    }
    .i3-window.is-focused {
      border-color: #285577;
    }
    .i3-title {
      display: block;
      padding: 2px 6px;
      font-size: 0.75rem;
      background: #333;
      color: #888;
    }
    .i3-window.is-focused .i3-title {
      background: #285577;
      color: #fff;
    }
    .i3-body {
      flex: 1;
      padding: 6px;
      font-size: 0.8125rem;
      color: #6a9955;
    }
    .i3 .ember-primitives__resizable__handle {
      background: #1a1a1a;
    }
    .i3 .ember-primitives__resizable[data-orientation='horizontal']
      > .ember-primitives__resizable__handle {
      width: 5px;
    }
    .i3 .ember-primitives__resizable[data-orientation='vertical']
      > .ember-primitives__resizable__handle {
      height: 5px;
    }
    .i3 .ember-primitives__resizable__handle:hover,
    .i3 .ember-primitives__resizable__handle:focus-visible,
    .i3 .ember-primitives__resizable__handle[data-resizing] {
      background: #4c7899;
      outline: none;
    }
  </style>
</template>
```

</div>

## Install

```bash
pnpm add ember-primitives
```

```js
import { Resizable } from 'ember-primitives';
// or
import { Resizable } from 'ember-primitives/components/resizable';
```

## Anatomy

```gjs
import { Resizable } from 'ember-primitives';

<template>
  <Resizable @orientation="horizontal" as |r|>
    <r.Panel>…</r.Panel>
    <r.Handle aria-label="Resize" />
    <r.Panel>
      {{! panels may contain another <Resizable> }}
    </r.Panel>
  </Resizable>
</template>
```

A `Handle` resizes the two panels on either side of it. Sizes are percentages of the group's space, applied via `flex-grow` -- the component ships only the structural CSS (flex layout, cursors, `touch-action`); all appearance (handle color, width, hover/focus styles) is up to you.

Dragging uses pointer capture, so resizing keeps working when the pointer passes over iframes -- no overlay element needed.

## Persisting the layout

`@onLayoutChange` is called with the panels' sizes (percentages, in document order) whenever the layout changes, and `@defaultSize` sets the initial size -- together they make persistence straightforward (localStorage, query params, etc.).

With nested groups, each group persists its own sizes under its own key. Resize the panels below, then reload the page -- the layout is remembered.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Resizable } from 'ember-primitives';

const KEY = 'docs:resizable:persisted-demo';

function load() {
  try {
    return JSON.parse(localStorage.getItem(KEY)) ?? {};
  } catch {
    return {};
  }
}

const saved = load();

const persist = (group) => (sizes) => {
  saved[group] = sizes;
  localStorage.setItem(KEY, JSON.stringify(saved));
};

const sizeOf = (group, index) => saved[group]?.[index];

<template>
  <div class="rz-persisted">
    <Resizable @onLayoutChange={{persist "outer"}} as |r|>
      <r.Panel @defaultSize={{sizeOf "outer" 0}} @minSize={{15}}>
        <div class="rz-pane">files</div>
      </r.Panel>
      <r.Handle aria-label="Resize files" />
      <r.Panel @defaultSize={{sizeOf "outer" 1}}>
        <Resizable @orientation="vertical" @onLayoutChange={{persist "inner"}} as |inner|>
          <inner.Panel @defaultSize={{sizeOf "inner" 0}}>
            <div class="rz-pane">editor</div>
          </inner.Panel>
          <inner.Handle aria-label="Resize output" />
          <inner.Panel @defaultSize={{sizeOf "inner" 1}} @minSize={{10}}>
            <div class="rz-pane">output</div>
          </inner.Panel>
        </Resizable>
      </r.Panel>
    </Resizable>
  </div>
  <style>
    /* styles for the demo, not required */
    .rz-persisted {
      height: 220px;
      border: 1px solid gray;
    }
    .rz-persisted .rz-pane {
      display: grid;
      place-items: center;
      height: 100%;
      font-family: monospace;
    }
    .rz-persisted .ember-primitives__resizable__handle {
      background: gray;
      opacity: 0.4;
    }
    .rz-persisted .ember-primitives__resizable__handle:hover,
    .rz-persisted .ember-primitives__resizable__handle:focus-visible,
    .rz-persisted .ember-primitives__resizable__handle[data-resizing] {
      opacity: 1;
      background: dodgerblue;
    }
  </style>
</template>
```

</div>

## Accessibility

The handle follows the [window splitter](https://www.w3.org/WAI/ARIA/apg/patterns/windowsplitter/) pattern: it is a focusable `role="separator"` with `aria-valuenow/min/max` describing the panel before it (also referenced via `aria-controls`).

Give each handle an accessible name (e.g. `aria-label="Resize sidebar"`).

### Keyboard Interactions

| key | description |
| :---: | :----------- |
| <kbd>ArrowLeft</kbd> / <kbd>ArrowRight</kbd> | Move the boundary of a horizontal group (1%, or 10% with <kbd>Shift</kbd>) |
| <kbd>ArrowUp</kbd> / <kbd>ArrowDown</kbd> | Move the boundary of a vertical group (1%, or 10% with <kbd>Shift</kbd>) |
| <kbd>Home</kbd> | Shrink the preceding panel to its `@minSize` |
| <kbd>End</kbd> | Grow the preceding panel to its `@maxSize` |
| <kbd>Enter</kbd> | Collapse / restore the preceding panel (when it is `@collapsible`) |

## API Reference

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/resizable"
    @name="Signature" />
</template>
```

### Panel

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/resizable"
    @name="PanelSignature" />
</template>
```

### Handle

```gjs live no-shadow
import { ComponentSignature } from 'kolay';

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/resizable"
    @name="HandleSignature" />
</template>
```
