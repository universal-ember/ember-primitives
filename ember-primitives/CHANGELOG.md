# ember-primitives

## 0.2.0

### Minor Changes

- ef7306f: Link now exposes an `isActive` property on the yielded data, as well as provides a data-active attribute on the generated `<a>` element
- 2c7696d: Add a loosemode template-registry for Glint users not yet using gjs/gts

## 0.1.0

### Minor Changes

- 5921fb4: Drop support for Ember 4.8. It could still be supported through @embroider/macros, but I don't have the energy for that right now. If someone wanted to submit a PR, that'd be ligit -- however, the gap between 4.8 and 4.12 is very small, and folks should just use latest 4.x if they can"

### Patch Changes

- 7267ccb: @properLinks
  - needs to support both QueryParams and the hash
  - supports custom rootURL
  - internally: adding tests for all of this as well

## 0.0.9

### Patch Changes

- 59c02c3: Fix peers so that this library is compatible with all the next majors

## 0.0.8

### Patch Changes

- 79b0e5f: Fix issue where <Link> did not fallback to browser-behavior like @properLinks does

## 0.0.7

### Patch Changes

- fec2dc4: Add dialog component

## 0.0.6

### Patch Changes

- 644c6ba: Add iframe utilities for checking if the current frame is in an iframe or not. Also added documentation, and fixed the docs-renderer for rendering the comment block next to functions

## 0.0.5

### Patch Changes

- d72fb6e: Update proper-links to be compat with TS 5.1

## 0.0.4

### Patch Changes

- 78406fc: Add Popover, PortalTargets, and Portal

## 0.0.3

### Patch Changes

- 5f505a7: Add Toggle component, see: https://ember-primitives.pages.dev/3-components/toggle

## 0.0.2

### Patch Changes

- 1430a90: Remove extraneous span from ExternalLink

## 0.0.1

### Patch Changes

- 23bfdb6: initial pre-alpha
