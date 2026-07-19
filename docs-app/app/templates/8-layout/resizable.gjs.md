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
    this.id = launches;
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

function windowById(node, id) {
  if (!isSplit(node)) return node.id === id ? node : null;

  for (const child of node.children) {
    const found = windowById(child, id);

    if (found) return found;
  }

  return null;
}

/**
 * Focus lives in the DOM: the windows are buttons, so clicking one
 * focuses it, the highlight is plain CSS `:focus`, and the toolbar
 * reads document.activeElement to find its target. No focus state to
 * keep in sync, and focusing a window writes nothing anywhere else.
 */
function focusedWindow(root) {
  const element = document.activeElement?.closest?.('.i3-window');

  return element ? windowById(root, Number(element.dataset.id)) : null;
}

// the new window's element exists after the next render
function focusWindow(win) {
  if (!win) return;

  requestAnimationFrame(() => document.querySelector(`.i3-window[data-id="${win.id}"]`)?.focus());
}

// on the toolbar: keep focus on the window the button operates on
const keepFocus = (event) => event.preventDefault();

class WindowManager {
  root = new Split('horizontal', [new AppWindow()]);

  /**
   * Mirrors document.activeElement for the status bar (activeElement
   * itself is not reactive); everything else reads the DOM directly.
   */
  @tracked focused = null;

  syncFocus = (event) => {
    const element = event.type === 'focusout' ? event.relatedTarget : event.target;
    const win = element?.closest?.('.i3-window');
    const node = win ? windowById(this.root, Number(win.dataset.id)) : null;

    // focusout fires mid-render when the focused element is removed
    // (split, kill); the tracked write has to happen outside of it
    queueMicrotask(() => (this.focused = node));
  };

  split = (orientation) => {
    const win = new AppWindow();
    const root = this.root;
    const focused = focusedWindow(root);
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

    focusWindow(win);
  };

  toggleLayout = () => {
    const root = this.root;
    const focused = focusedWindow(root);
    const parent = focused ? findParent(root, focused) : root;

    if (!parent) return;

    // i3's $mod+e: flip the container's split direction; panels keep their sizes
    parent.orientation = parent.orientation === 'horizontal' ? 'vertical' : 'horizontal';
  };

  kill = () => {
    const root = this.root;
    const focused = focusedWindow(root);

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

    focusWindow(firstWindow(parent.children.length ? parent : root));
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
    <button type="button" class="i3-window" data-id="{{@node.id}}">
      <span class="i3-title">{{@node.title}}</span>
      <span class="i3-body">{{@node.content}}</span>
    </button>
  {{/if}}
</template>;

<template>
  <div class="i3">
    <div class="i3-bar">
      <button
        type="button"
        {{on "mousedown" keepFocus}}
        {{on "click" (fn wm.split "horizontal")}}
      >split h</button>
      <button
        type="button"
        {{on "mousedown" keepFocus}}
        {{on "click" (fn wm.split "vertical")}}
      >split v</button>
      <button
        type="button"
        {{on "mousedown" keepFocus}}
        {{on "click" wm.toggleLayout}}
      >toggle layout</button>
      <button type="button" {{on "mousedown" keepFocus}} {{on "click" wm.kill}}>kill</button>
      <span class="i3-status">1: {{if wm.focused wm.focused.title "(empty)"}}</span>
    </div>
    <div class="i3-workspace" {{on "focusin" wm.syncFocus}} {{on "focusout" wm.syncFocus}}>
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
    .i3-window:focus {
      border-color: #285577;
      outline: none;
    }
    .i3-title {
      display: block;
      padding: 2px 6px;
      font-size: 0.75rem;
      background: #333;
      color: #888;
    }
    .i3-window:focus .i3-title {
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

Panels are discovered from the DOM, so managing a layout is just managing what you render: `{{#each}}` over your own state, add or remove entries, nest a `<Resizable>` for a split.

Click a panel to focus it (highlighted). **Add panel** inserts a sibling after the focused panel, **Split h** / **Split v** wrap the focused panel in a new group of that orientation -- dividing its space in half, with further additions landing *inside* the split -- **Rotate** flips the focused panel's group, and **Remove** deletes the focused panel -- groups left with a single child dissolve.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { tracked } from '@glimmer/tracking';
import { cell } from 'ember-resources';
import { trackedArray } from '@ember/reactive/collections';
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

let nextId = 1;

class PanelNode {
  id = nextId++;
}

class GroupNode {
  @tracked orientation;
  children;

  constructor(orientation, children) {
    this.orientation = orientation;
    this.children = trackedArray(children);
  }
}

const isGroup = (node) => node instanceof GroupNode;
const cross = (orientation) => (orientation === 'horizontal' ? 'vertical' : 'horizontal');

const root = new GroupNode('horizontal', [new PanelNode(), new PanelNode()]);

/**
 * Focus lives in the DOM: the panels are buttons, so clicking one
 * focuses it, the highlight is plain CSS `:focus`, and the toolbar
 * reads document.activeElement to find its target. The cell only
 * mirrors the focused panel's id for the status text (activeElement
 * itself is not reactive).
 */
const focusedId = cell(null);

const syncFocus = (event) => {
  const element = event.type === 'focusout' ? event.relatedTarget : event.target;
  const pane = element?.closest?.('.rz-pane');
  const id = pane ? Number(pane.dataset.id) : null;

  // focusout fires mid-render when the focused element is removed
  // (split, remove); the tracked write has to happen outside of it
  queueMicrotask(() => focusedId.set(id));
};

function panelById(node, id) {
  if (!isGroup(node)) return node.id === id ? node : null;

  for (const child of node.children) {
    const found = panelById(child, id);

    if (found) return found;
  }

  return null;
}

function focusedPanel() {
  const pane = document.activeElement?.closest?.('.rz-pane');

  return pane ? panelById(root, Number(pane.dataset.id)) : null;
}

// the new panel's element exists after the next render
function focusPanel(panel) {
  if (!panel) return;

  requestAnimationFrame(() => document.querySelector(`.rz-pane[data-id="${panel.id}"]`)?.focus());
}

// on the toolbar: keep focus on the panel the button operates on
const keepFocus = (event) => event.preventDefault();

function findParent(node, target) {
  if (!isGroup(node)) return null;

  for (const child of node.children) {
    if (child === target) return node;

    const found = findParent(child, target);

    if (found) return found;
  }

  return null;
}

function firstPanel(node) {
  if (!isGroup(node)) return node;

  return node.children.length ? firstPanel(node.children[0]) : null;
}

const addPanel = () => {
  const target = focusedPanel();
  const parent = (target && findParent(root, target)) ?? root;
  const panel = new PanelNode();

  parent.children.splice(parent.children.indexOf(target) + 1, 0, panel);
  focusPanel(panel);
};

const split = (orientation) => {
  const target = focusedPanel();
  const parent = target && findParent(root, target);

  if (!parent) return;

  const panel = new PanelNode();
  const group = new GroupNode(orientation, [target, panel]);

  parent.children.splice(parent.children.indexOf(target), 1, group);
  focusPanel(panel);
};

const removePanel = () => {
  const target = focusedPanel();
  const parent = target && findParent(root, target);

  if (!parent) return;

  parent.children.splice(parent.children.indexOf(target), 1);

  // groups left with a single child dissolve into their parent
  if (parent !== root && parent.children.length === 1) {
    const grandparent = findParent(root, parent);

    grandparent.children.splice(grandparent.children.indexOf(parent), 1, parent.children[0]);
  }

  focusPanel(firstPanel(parent.children.length ? parent : root));
};

const rotate = () => {
  const target = focusedPanel();
  const parent = target && findParent(root, target);

  if (parent) parent.orientation = cross(parent.orientation);
};

const Tree = <template>
  <Resizable @orientation={{@node.orientation}}>
    {{#each @node.children key="id" as |child index|}}
      {{#if index}}
        <Handle aria-label="Resize" />
      {{/if}}
      <Panel @minSize={{10}}>
        {{#if (isGroup child)}}
          <Tree @node={{child}} />
        {{else}}
          <button type="button" class="rz-pane" data-id="{{child.id}}">
            {{child.id}}
          </button>
        {{/if}}
      </Panel>
    {{/each}}
  </Resizable>
</template>;

<template>
  <div class="rz-dynamic-bar">
    <button type="button" {{on "mousedown" keepFocus}} {{on "click" addPanel}}>Add panel</button>
    <button
      type="button"
      {{on "mousedown" keepFocus}}
      {{on "click" (fn split "horizontal")}}
    >Split h</button>
    <button
      type="button"
      {{on "mousedown" keepFocus}}
      {{on "click" (fn split "vertical")}}
    >Split v</button>
    <button type="button" {{on "mousedown" keepFocus}} {{on "click" removePanel}}>Remove</button>
    <button type="button" {{on "mousedown" keepFocus}} {{on "click" rotate}}>Rotate</button>
    <span>
      {{#if focusedId.current}}
        focused: panel
        {{focusedId.current}}
      {{else}}
        focused: (none)
      {{/if}}
    </span>
  </div>

  <div class="rz-dynamic" {{on "focusin" syncFocus}} {{on "focusout" syncFocus}}>
    <Tree @node={{root}} />
  </div>
  <style>
    /* styles for the demo, not required */
    .rz-dynamic-bar {
      display: flex;
      gap: 0.5rem;
      align-items: center;
    }
    .rz-dynamic {
      height: 220px;
      margin-top: 0.5rem;
      border: 1px solid gray;
    }
    .rz-dynamic .rz-pane {
      display: grid;
      place-items: center;
      width: 100%;
      height: 100%;
      padding: 0;
      border: none;
      background: transparent;
      color: inherit;
      font-family: monospace;
      font-size: 1rem;
      cursor: pointer;
    }
    .rz-dynamic .rz-pane:focus {
      outline: 2px solid dodgerblue;
      outline-offset: -2px;
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

## Controlled layout

A layout like [limber](https://limber.glimdown.com)'s REPL: an editor and its output, with controls layered on top of the editor for minimizing, maximizing, and rotating. Maximized and minimized are just different templates -- the `<Resizable>` only renders in the default mode, and remembers its sizes (via `@onLayoutChange` / `@size`) across mode changes.

<div class="featured-demo auto-height">

```gjs live preview no-shadow
import { cell } from 'ember-resources';
import { Resizable, Panel, Handle } from 'ember-primitives/components/resizable';

const mode = cell('default'); // 'default' | 'maximized' | 'minimized'
const orientation = cell('horizontal');

// remembered across mode changes (this could also be localStorage)
let sizes = [40, 60];
const rememberSizes = (next) => (sizes = next);
const sizeAt = (index) => sizes[index];

const toggleMaximize = () => mode.set(mode.current === 'maximized' ? 'default' : 'maximized');
const toggleMinimize = () => mode.set(mode.current === 'minimized' ? 'default' : 'minimized');
const rotate = () =>
  orientation.set(orientation.current === 'horizontal' ? 'vertical' : 'horizontal');

const Controls = <template>
  <div class="limber-controls">
    <button type="button" {{on "click" rotate}}>
      rotate
    </button>
    <button type="button" {{on "click" toggleMinimize}}>
      {{if (eq mode.current "minimized") "restore" "min"}}
    </button>
    <button type="button" {{on "click" toggleMaximize}}>
      {{if (eq mode.current "maximized") "restore" "max"}}
    </button>
  </div>
</template>;

const Editor = <template>
  <div class="limber-editor">
    <Controls />
    <pre>&lt;template&gt;
  Hello, &#123;&#123;@name&#125;&#125;!
&lt;/template&gt;</pre>
  </div>
</template>;

const Output = <template>
  <div class="limber-output">Hello, world!</div>
</template>;

<template>
  <div class="limber">
    {{#if (eq mode.current "maximized")}}
      <Editor />
    {{else if (eq mode.current "minimized")}}
      <div class="limber-minimized" data-orientation={{orientation.current}}>
        <div class="limber-sliver"><Controls /></div>
        <Output />
      </div>
    {{else}}
      <Resizable @orientation={{orientation.current}} @onLayoutChange={{rememberSizes}}>
        <Panel @size={{sizeAt 0}} @minSize={{10}}>
          <Editor />
        </Panel>
        <Handle aria-label="Resize editor" />
        <Panel @size={{sizeAt 1}} @minSize={{10}}>
          <Output />
        </Panel>
      </Resizable>
    {{/if}}
  </div>
  <style>
    /* styles for the demo, not required */
    .limber {
      height: 240px;
      border: 1px solid gray;
    }
    .limber-editor {
      position: relative;
      height: 100%;
      background: #1e1e2e;
      color: #cdd6f4;
    }
    .limber-editor pre {
      margin: 0;
      padding: 1rem;
      font-size: 0.8125rem;
    }
    .limber-controls {
      position: absolute;
      top: 0.375rem;
      right: 0.375rem;
      display: flex;
      gap: 0.25rem;
      z-index: 1;
    }
    .limber-controls button {
      font-family: monospace;
      font-size: 0.6875rem;
      padding: 0.125rem 0.375rem;
      background: #313244;
      color: #cdd6f4;
      border: 1px solid #45475a;
      cursor: pointer;
    }
    .limber-controls button:hover {
      border-color: #89b4fa;
    }
    .limber-output {
      display: grid;
      place-items: center;
      height: 100%;
      font-family: monospace;
    }
    .limber-minimized {
      display: flex;
      height: 100%;
    }
    .limber-minimized[data-orientation='horizontal'] {
      flex-direction: row;
    }
    .limber-minimized[data-orientation='vertical'] {
      flex-direction: column;
    }
    .limber-sliver {
      position: relative;
      flex: 0 0 auto;
      background: #1e1e2e;
    }
    .limber-minimized[data-orientation='horizontal'] .limber-sliver {
      width: 2rem;
    }
    /* in the narrow sliver, the whole button row rotates 90° to fit */
    .limber-minimized[data-orientation='horizontal'] .limber-controls {
      top: 0.375rem;
      right: 100%;
      transform: rotate(-90deg);
      transform-origin: top right;
    }
    .limber-minimized[data-orientation='vertical'] .limber-sliver {
      height: 2rem;
    }
    .limber-minimized .limber-output {
      flex: 1;
    }
    .limber .ember-primitives__resizable__handle {
      background: gray;
      opacity: 0.4;
    }
    .limber .ember-primitives__resizable__handle:hover,
    .limber .ember-primitives__resizable__handle:focus-visible,
    .limber .ember-primitives__resizable__handle[data-resizing] {
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

The handle follows the [window splitter](https://www.w3.org/WAI/ARIA/apg/patterns/windowsplitter/) pattern: it is a focusable `role="separator"` with `aria-valuenow/min/max` describing the panel before it.

Each panel gets a stable, component-owned id (incrementing, not overridable -- it renders after `...attributes`), and each handle references the panel before it via `aria-controls`.

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
