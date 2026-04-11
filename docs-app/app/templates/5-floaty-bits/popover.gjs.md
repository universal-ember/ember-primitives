# Popover

Popovers are built with [Floating UI][docs-floating-ui], a set of utilities for making floating elements relate to each other with minimal configuration. The `<Popover>` component uses the [Popover API](https://developer.mozilla.org/en-US/docs/Web/API/Popover_API) for layering, which totally solves z-index and overflow clipping issues — no portals needed.

One thing to note is that the position of the popover can _escape_ the boundary of a [ShadowDom][docs-shadow-dom] -- all demos on this docs site for `ember-primitives` use a `ShadowDom` to allow for isolated CSS usage within the demos.

[docs-floating-ui]: /5-floaty-bits/floating-ui.md
[docs-floating]: https://floating-ui.com/
[docs-popper]: https://popper.js.org/
[docs-shadow-dom]: https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM

<div class="featured-demo">

```gjs live preview
import { Popover } from "ember-primitives";
import { array, hash } from "@ember/helper";
import { loremIpsum } from "lorem-ipsum";

<template>
  <div class="scroll-content" tabindex="0">
    {{loremIpsum (hash count=1 units="sentence")}}

    <Popover @placement="top" @offsetOptions={{8}} as |p|>
      <div class="hook" {{p.reference}}>
        the hook / anchor of the popover.
        <br />
        it sticks the boundary of this element.
      </div>
      <p.Content class="floatybit">
        The floaty bit here
        <div class="arrow" {{p.arrow}}></div>
      </p.Content>
    </Popover>

    {{loremIpsum (hash count=2 units="paragraphs")}}
  </div>

  <style>
    @scope {
      .floatybit {
        width: max-content;
        position: absolute;
        background: #222;
        color: white;
        font-weight: bold;
        padding: 5px;
        border-radius: 4px;
        border: none;
        font-size: 90%;
        filter: drop-shadow(0 0 0.75rem rgba(0, 0, 0, 0.4));
        z-index: 10;
      }
      .arrow {
        position: absolute;
        background: #222;
        width: 8px;
        height: 8px;
        transform: rotate(45deg);
      }
      .hook {
        padding: 0.5rem;
        border: 1px solid;
        display: inline-block;
        color: black;
      }
      .scroll-content {
        max-height: 150px;
        overflow-y: auto;
        border: 1px solid;
        padding: 0.5rem;
      }
    }
  </style>
</template>
```

</div>

## Disabled button with tooltip

A common pattern is a button that explains _why_ it's disabled. The tooltip appears on hover and focus, and is itself focusable so screen reader users can read the reason.

<div class="featured-demo">

```gjs live preview
import { Popover } from "ember-primitives";

<template>
  <Popover @placement="top" @offsetOptions={{6}} as |p|>
    <button class="fancy-btn" aria-disabled="true" {{p.reference}}>
      Submit
    </button>

    <p.Content class="tooltip">
      You must fill out all required fields before submitting.
      <div class="arrow" {{p.arrow}}></div>
    </p.Content>
  </Popover>

  <style>
    @scope {
      :scope {
        display: flex;
        justify-content: center;
        align-items: center;
      }
      .fancy-btn {
        padding: 0.5rem 1.5rem;
        border-radius: 4px;
        border: 1px solid;
        display: inline-block;
        color: black;
        background: white;
        font-weight: 600;
        cursor: not-allowed;

        &:hover + .tooltip,
        &:focus-visible + .tooltip {
          opacity: 1;
          pointer-events: all;
        }
      }
      .tooltip {
        display: block;
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.15s;
        width: max-content;
        max-width: 260px;
        background: #222;
        color: white;
        font-weight: bold;
        padding: 5px;
        border-radius: 4px;
        border: none;
        font-size: 90%;
        filter: drop-shadow(0 0 0.75rem rgba(0, 0, 0, 0.4));
        z-index: 10;

        &:hover,
        &:focus,
        &:focus-visible {
          opacity: 1;
          pointer-events: all;
        }
      }
      .arrow {
        position: absolute;
        background: #222;
        width: 8px;
        height: 8px;
        transform: rotate(45deg);
      }
    }
  </style>
</template>
```

</div>

The tooltip is always in the DOM (for screen readers) but visually hidden via `opacity: 0`. On hover or focus of the button, CSS transitions it to `opacity: 1`. The tooltip itself is hoverable and focusable, so users can select and copy the text within it — unlike native `title` attributes which don't allow interaction.

## Usage within a header

It's often common to provide popover-using UIs in site headers, such as a settings menu, or navigation.

<div class="featured-demo">

```gjs live preview
import { Popover } from "ember-primitives";
import { hash } from "@ember/helper";
import { loremIpsum } from "lorem-ipsum";
import { cell } from "ember-resources";
import { on } from "@ember/modifier";
import { focusTrap } from "ember-focus-trap";

const settings = cell(false);

<template>
  <div class="site not-prose">

    <header>
      <span>My App: click settings -&gt;</span>

      <Popover @offsetOptions={{8}} as |p|>
        <button class="hook" {{p.reference}} {{on "click" settings.toggle}}>
          Settings
        </button>

        {{#if settings.current}}
          <p.Content open class="floatybit">

            <ul>
              <li>a</li>
              <li>not so big list</li>
              <li>of</li>
              <li>
                things<br />

                <Popover @placement="left" @offsetOptions={{16}} as |pp|>
                  <button {{pp.reference}}>view profile</button>

                  <pp.Content class="floatybit">
                    View or edit your profile settings
                    <div class="arrow" {{pp.arrow}}></div>
                  </pp.Content>
                </Popover>
              </li>
            </ul>
            <div class="arrow" {{p.arrow}}></div>
          </p.Content>
        {{/if}}
      </Popover>

    </header>

    <div class="main">
      {{loremIpsum (hash count=2 units="paragraphs")}}
    </div>
  </div>

  <style>
    @scope {
      .floatybit {
        width: 200px;
        position: absolute;
        background: #222;
        color: white;
        font-weight: bold;
        padding: 1rem;
        border-radius: 4px;
        font-size: 90%;
        filter: drop-shadow(0 0 0.75rem rgba(0, 0, 0, 0.4));
        z-index: 10;
        border: 1px solid rgba(0, 255, 255, 0.6);
      }
      .floatybit .floatybit {
        background: light-dark(#eee, #334155);
        color: light-dark(black, #f8fafc);
      }
      .floatybit .floatybit .arrow {
        background: light-dark(#eee, #334155);
        transform: translateY(-1rem) rotate(45deg);

        &::before {
          background: light-dark(#eee, #334155);
          border-top: 1px solid rgba(0, 255, 255, 0.6);
          transform: rotate(45deg) translateY(7px) translateX(-8px);
          border-left: none;
        }
      }
      ul {
        padding-left: 1rem;
        margin: 0;
      }
      .arrow {
        position: absolute;
        background: #222;
        width: 8px;
        height: 8px;
        transform: rotate(45deg);
        border: 1px solid rgba(0, 255, 255, 0.6);

        &::before {
          content: "";
          position: absolute;
          display: block;
          width: 1rem;
          height: 1rem;
          background: #222;
          transform: rotate(45deg);
          border-left: 1px solid rgba(0, 255, 255, 0.6);
        }
      }
      .hook {
        padding: 0.5rem;
        border: 1px solid currentColor;
        display: inline-block;
        color: inherit;
        background: light-dark(white, #1e293b);
        border-radius: 4px;
      }
      header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        background: light-dark(white, #1e293b);
        color: light-dark(black, #f8fafc);
        position: sticky;
        top: 0;
        width: 100%;
        padding: 0.25rem 0.5rem;
        box-shadow: 0px 3px 6px #000000aa;
      }
      .main {
        padding: 0.5rem;
        color: light-dark(black, #cbd5e1);
      }
      .site {
        max-height: 200px;
        overflow-y: auto;
        border: 1px solid light-dark(#ccc, #334155);
        color-scheme: light dark;
      }
      * {
        box-sizing: border-box;
      }
    }
  </style>
</template>
```

</div>

## Install

```hbs live
<SetupInstructions @src="components/popover.gts" />
```

## API Reference

```gjs live no-shadow
import { ComponentSignature } from "kolay";

<template>
  <ComponentSignature
    @package="ember-primitives"
    @module="declarations/components/popover"
    @name="Signature"
  />
</template>
```

## Accessibility

The `Content` of a popover is focusable, so that keyboard (and screenreader) users can interact with the Popover content. Generally this is great for modals, but also extends to things like tooltips, so that folks can copy the content out.

Since a `Popover` isn't an explicit design pattern provided by W3, but instead, `Popover` is a low level primitive that could be used to build the W3 examples of

- [Modal Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/dialog/)
- [Date Picker Dialog](https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/examples/datepicker-dialog/)
- [Date Picker Combobox](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-datepicker/)
- [Select-Only Combobox](https://www.w3.org/WAI/ARIA/apg/patterns/combobox/examples/combobox-select-only/)
- [Menu Button](https://www.w3.org/WAI/ARIA/apg/patterns/menu-button/)
- and more
