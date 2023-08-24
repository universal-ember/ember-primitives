---
'ember-primitives': minor
---

For `<Popover>`, provide an escape hatch on `<Content>` so that folks can opt out of portaling, if their CSS or middleware is misbehaving. This should be a last resort, however, as portalling can help solve layering and z-index issues across the whole application -- see https://ember-primitives.pages.dev/5-floaty-bits/portal for a demo.
