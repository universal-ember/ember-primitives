# Resizable

Panels with draggable (and keyboard-operable) dividers between them.

Each `<Resizable>` is a flat row (or column) of panels -- but a panel may contain another `<Resizable>`, so layouts compose into arbitrary trees, the same way tiling window managers (i3, sway, tmux) model their screen.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

<template>
  <div class="rz-demo">
    <Resizable>
      <Panel @minSize={{15}} @size={{25}}>
        <div class="rz-pane">sidebar</div>
      </Panel>
      <Handle aria-label="Resize sidebar" />
      <Panel>
        <Resizable @orientation="vertical">
          <Panel>
            <div class="rz-pane">editor</div>
          </Panel>
          <Handle aria-label="Resize terminal" />
          <Panel @minSize={{10}} @size={{30}} @collapsible={{true}}>
            <div class="rz-pane">terminal</div>
          </Panel>
        </Resizable>
      </Panel>
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
Click a window to focus it, then split it, flip its container's layout, or kill it, i3wm style. Drag or <kbd>Tab</kbd> to the borders to resize.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { tracked } from '@glimmer/tracking';
import { trackedArray } from '@ember/reactive/collections';
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

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
  @tracked orientation;
  children;

  constructor(orientation, children) {
    this.orientation = orientation;
    this.children = trackedArray(children);
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

  toggleLayout = () => {
    const { focused, root } = this;
    const parent = focused ? findParent(root, focused) : root;

    if (!parent) return;

    // i3's $mod+e: flip the container's split direction; panels keep their sizes
    parent.orientation = parent.orientation === 'horizontal' ? 'vertical' : 'horizontal';
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
    <Resizable @orientation={{@node.orientation}}>
      {{#each @node.children as |child index|}}
        {{#if (gt index 0)}}
          <Handle aria-label="Resize window" />
        {{/if}}
        <Panel @minSize={{5}}>
          <Tree @node={{child}} />
        </Panel>
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
      <button type="button" {{on "click" (fn wm.split "horizontal")}}>split h</button>
      <button type="button" {{on "click" (fn wm.split "vertical")}}>split v</button>
      <button type="button" {{on "click" wm.toggleLayout}}>toggle layout</button>
      <button type="button" {{on "click" wm.kill}}>kill</button>
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

## Changing orientation

`@orientation` may change while rendered -- panels keep their proportions and re-flow along the new axis.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { cell } from 'ember-resources';
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

const orientation = cell('horizontal');
const toggle = () =>
  orientation.set(orientation.current === 'horizontal' ? 'vertical' : 'horizontal');

<template>
  <button type="button" {{on "click" toggle}}>
    Rotate ({{orientation.current}})
  </button>

  <div class="rz-orientation">
    <Resizable @orientation={{orientation.current}}>
      <Panel><div class="rz-pane">one</div></Panel>
      <Handle aria-label="Resize one" />
      <Panel><div class="rz-pane">two</div></Panel>
      <Handle aria-label="Resize two" />
      <Panel><div class="rz-pane">three</div></Panel>
    </Resizable>
  </div>
  <style>
    /* styles for the demo, not required */
    .rz-orientation {
      height: 200px;
      margin-top: 0.5rem;
      border: 1px solid gray;
    }
    .rz-orientation .rz-pane {
      display: grid;
      place-items: center;
      height: 100%;
      font-family: monospace;
    }
    .rz-orientation .ember-primitives__resizable__handle {
      background: gray;
      opacity: 0.4;
    }
    .rz-orientation .ember-primitives__resizable__handle:hover,
    .rz-orientation .ember-primitives__resizable__handle:focus-visible,
    .rz-orientation .ember-primitives__resizable__handle[data-resizing] {
      opacity: 1;
      background: dodgerblue;
    }
  </style>
</template>
```

</div>

## Collapsing

A `@collapsible` panel can be closed entirely: press <kbd>Enter</kbd> on its handle to collapse or restore it, or drag well past its `@minSize` to snap it closed (within `@minSize` it holds at the minimum). While collapsed, the panel has a `data-collapsed` attribute you can style.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

<template>
  <div class="rz-collapse">
    <Resizable>
      <Panel @collapsible={{true}} @minSize={{20}} @size={{30}}>
        <div class="rz-pane">sidebar<br /><small>(collapsible)</small></div>
      </Panel>
      <Handle aria-label="Resize or collapse sidebar" />
      <Panel><div class="rz-pane">content</div></Panel>
    </Resizable>
  </div>
  <p><small>Focus the handle and press <kbd>Enter</kbd>, or drag it all the way left.</small></p>
  <style>
    /* styles for the demo, not required */
    .rz-collapse {
      height: 180px;
      border: 1px solid gray;
    }
    .rz-collapse .rz-pane {
      display: grid;
      place-items: center;
      height: 100%;
      font-family: monospace;
      text-align: center;
    }
    .rz-collapse [data-collapsed] {
      border-right: 4px solid dodgerblue;
    }
    .rz-collapse .ember-primitives__resizable__handle {
      background: gray;
      opacity: 0.4;
    }
    .rz-collapse .ember-primitives__resizable__handle:hover,
    .rz-collapse .ember-primitives__resizable__handle:focus-visible,
    .rz-collapse .ember-primitives__resizable__handle[data-resizing] {
      opacity: 1;
      background: dodgerblue;
    }
  </style>
</template>
```

</div>

## Adding, removing, and splitting panels

Panels are discovered from the DOM, so managing a layout is just managing what you render: `{{#each}}` over your own state, add or remove entries, nest a `<Resizable>` for a split. New panels take an equal share (existing panels scale down to make room), removed panels give their space back, and the whole group can be rotated at any time.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { cell } from 'ember-resources';
import { trackedArray } from '@ember/reactive/collections';
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

let nextId = 1;
const entries = trackedArray([{ id: nextId++, split: false }]);
const orientation = cell('horizontal');
const crossOrientation = () => (orientation.current === 'horizontal' ? 'vertical' : 'horizontal');

const addPanel = () => entries.push({ id: nextId++, split: false });
const addSplit = () => entries.push({ id: nextId++, split: true });
const removeLast = () => entries.length > 1 && entries.pop();
const rotate = () => orientation.set(crossOrientation());

<template>
  <div class="rz-dynamic-bar">
    <button type="button" {{on "click" addPanel}}>Add panel</button>
    <button type="button" {{on "click" addSplit}}>Add split</button>
    <button type="button" {{on "click" removeLast}}>Remove last</button>
    <button type="button" {{on "click" rotate}}>Rotate ({{orientation.current}})</button>
  </div>

  <div class="rz-dynamic">
    <Resizable @orientation={{orientation.current}}>
      {{#each entries key="id" as |entry index|}}
        {{#if index}}
          <Handle aria-label="Resize" />
        {{/if}}
        <Panel @minSize={{5}}>
          {{#if entry.split}}
            <Resizable @orientation={{(crossOrientation)}}>
              <Panel><div class="rz-pane">{{entry.id}}a</div></Panel>
              <Handle aria-label="Resize split" />
              <Panel><div class="rz-pane">{{entry.id}}b</div></Panel>
            </Resizable>
          {{else}}
            <div class="rz-pane">{{entry.id}}</div>
          {{/if}}
        </Panel>
      {{/each}}
    </Resizable>
  </div>
  <style>
    /* styles for the demo, not required */
    .rz-dynamic-bar {
      display: flex;
      gap: 0.5rem;
    }
    .rz-dynamic {
      height: 220px;
      margin-top: 0.5rem;
      border: 1px solid gray;
    }
    .rz-dynamic .rz-pane {
      display: grid;
      place-items: center;
      height: 100%;
      font-family: monospace;
    }
    .rz-dynamic .ember-primitives__resizable__handle {
      background: gray;
      opacity: 0.4;
    }
    .rz-dynamic .ember-primitives__resizable__handle:hover,
    .rz-dynamic .ember-primitives__resizable__handle:focus-visible,
    .rz-dynamic .ember-primitives__resizable__handle[data-resizing] {
      opacity: 1;
      background: dodgerblue;
    }
  </style>
</template>
```

</div>

## Persisting the layout

`@onLayoutChange` is called with the panels' sizes (percentages, in document order) whenever the layout changes, and `@size` sets the initial size -- together they make persistence straightforward (localStorage, query params, etc.).

With nested groups, each group persists its own sizes under its own key. Resize the panels below, then unmount and remount the whole layout (or reload the page) -- it comes back exactly as you left it.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { cell } from 'ember-resources';
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

const KEY = 'docs:resizable:persisted-demo';
const isShown = cell(true);

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
  <button type="button" {{on "click" isShown.toggle}}>
    {{if isShown.current "Unmount" "Remount"}} the layout
  </button>

  <div class="rz-persisted">
    {{#if isShown.current}}
      <Resizable @onLayoutChange={{persist "outer"}}>
      <Panel @size={{sizeOf "outer" 0}} @minSize={{15}}>
        <div class="rz-pane">files</div>
      </Panel>
      <Handle aria-label="Resize files" />
      <Panel @size={{sizeOf "outer" 1}}>
        <Resizable @orientation="vertical" @onLayoutChange={{persist "inner"}}>
          <Panel @size={{sizeOf "inner" 0}}>
            <div class="rz-pane">editor</div>
          </Panel>
          <Handle aria-label="Resize output" />
          <Panel @size={{sizeOf "inner" 1}} @minSize={{10}}>
            <div class="rz-pane">output</div>
          </Panel>
        </Resizable>
      </Panel>
      </Resizable>
    {{else}}
      <div class="rz-pane">(unmounted)</div>
    {{/if}}
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

## Install

```bash
pnpm add ember-primitives
```

```js
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';
// or, from the barrel:
import { Resizable, ResizablePanel, ResizableHandle } from 'ember-primitives';
```

## Anatomy

```gjs
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

<template>
  <Resizable @orientation="horizontal">
    <Panel>…</Panel>
    <Handle aria-label="Resize" />
    <Panel>
      {{! panels may contain another <Resizable> }}
    </Panel>
  </Resizable>
</template>
```

`Panel` and `Handle` are their own imports and find their group through the DOM: panels declare their constraints as data attributes the group queries for, and handles locate the group's state via DOM context. There is no registration -- what's in the DOM *is* the layout.

A `Handle` resizes the two panels on either side of it. Sizes are percentages of the group's space, applied via `flex-grow` -- the component ships only the structural CSS (flex layout, cursors, `touch-action`); all appearance (handle color, width, hover/focus styles) is up to you.

Dragging uses pointer capture, so resizing keeps working when the pointer passes over iframes -- no overlay element needed.

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
