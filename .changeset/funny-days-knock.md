---
'ember-primitives': patch
---

it turns out that colorScheme's onUpdate wasn't possible to have as a don't-worry-about-cleanup thing because the GarbageCollector over-eagerly cleaned up the function, and the callback wouldn't get executed. So now, onUpdate is removed, and the colorScheme object has on.update and off.update.
