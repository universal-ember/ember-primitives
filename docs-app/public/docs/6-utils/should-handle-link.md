# `should-handle-link`

The utility provided from [should-handle-link](https://github.com/NullVoxPopuli/should-handle-link/) is what powers the decisions for `properLinks`.

Before we pass off the the ember router to determine if a `href` link is part of your app, we have to first determine if the browser should handle the click instead.

## Setup 

```bash 
pnpm add should-handle-link
```

## Usage 

```ts
import { shouldHandle } from 'should-handle-link';

function handler(event) {
    let anchor = getAnchor(event);

    if (!shouldHandle(location.href, anchor, event)) {
        return;
    }

    event.preventDefault();
    event.stopImmediatePropagation();
    event.stopPropagation();
    // Do single-page-app routing, 
    // or some other manual handling of the clicked anchor element
}

document.body.addEventListener('click', handler);

function getAnchor(event) {
  /**
   * Using composed path in case the link is removed from the DOM
   * before the event handler evaluates
   */
  let composedPath = event.composedPath();

  for (let element of composedPath) {
    if (element instanceof HTMLAnchorElement) {
      return element;
    }
  }
}
```
