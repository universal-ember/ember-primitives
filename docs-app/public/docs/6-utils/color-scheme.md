# Sync Color Scheme 

With the introduction of [`prefers-color-scheme`][mdn-prefers-color-scheme], we can better serve our users preferences and help them feel comfortable in our applications.

However, when using prefers-color-scheme, there are some rough edges around the whole feature of color schemes in browsers:

- the scrollbars do not change unless the [`color-scheme`][mdn-color-scheme] variable is set on the root element
- default browsers styles do not change based on `prefers-color-scheme`, and instead are only reactive to `color-scheme`
- a user's `prefers-color-scheme` preference does not set `color-scheme` on the root element 
- it's not possible to, from CSS, query the value of `color-scheme`

So, we need to run some JavaScript to synchronize all this.

[mdn-prefers-color-scheme]: https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-color-scheme
[mdn-color-scheme]: https://developer.mozilla.org/en-US/docs/Web/CSS/color-scheme 


## App-based theme preference?

The `color-scheme` property can be used at any nesting level in the DOM, so if the user wishes to set their preferred color scheme to "dark mode" in your app, even though their browser reports that their `prefers-color-scheme` value is "light mode", dark mode is what we want to render. This is persisted across refreshes.

```gjs live preview 
import { 
  sync, colorScheme, prefers, getColorScheme, localPreference
} from 'ember-primitives/color-scheme';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';

// reads the user's browser preferences
sync();

function gatherSchemePreferences() {
  return {
    prefers: {
      dark: prefers.dark(),
      light: prefers.light(),
      synthWave: prefers.custom('synthwave'),
    },
    // colorScheme is a reactive value
    activeTheme: colorScheme.current,
    otherSources: {
      'documentElement': getColorScheme(), 
      localStorage: localPreference.read(),
    }
  };
}

<template>
  <button {{on 'click' (fn colorScheme.update 'dark')}}>Dark mode</button>
  <button {{on 'click' (fn colorScheme.update 'light')}}>Light mode</button>

  <pre>{{JSON.stringify (gatherSchemePreferences) null 4}}</pre>
</template>
```

Linking to external stylesheets can be made reactive by  reading from the `colorScheme` object:

Here is how this docs site swaps out the CSS theme for highlight.js, used for syntax highlighting:

```gjs 
import { colorScheme } from 'ember-primitives/color-scheme';

function isDark() {
  return colorScheme.current === 'dark';
}

<template>
  {{#if (isDark)}}
    <link 
      rel="stylesheet" 
      href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-dark.css" />
  {{else}}
    <link 
      rel="stylesheet" 
      href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-light.css" />
  {{/if}}
</template>
```

Sometimes, you may wish to control the CSS via a class property on `<body>` or similar element.

To do that, you need an effect:

```gjs 
import { colorScheme } from 'ember-primitives/color-scheme';

function syncBodyClass() {
  if (colorScheme.current === 'dark') {
    document.body.classList.remove('theme-light');
    document.body.classList.add('theme-dark');
  } else {
    document.body.classList.remove('theme-dark');
    document.body.classList.add('theme-light');
  }
}

<template>
  {{ (syncBodyClass) }}
</template>
```

## API Reference

```gjs live no-shadow
import { APIDocs } from 'docs-app/docs-support';

<template>
  <APIDocs @module="color-scheme" @name="colorScheme" />
  <APIDocs @module="color-scheme" @name="sync" />
  <APIDocs @module="color-scheme" @name="onUpdate" />
  <APIDocs @module="color-scheme" @name="prefers" />
  <APIDocs @module="color-scheme" @name="localPreference" />
  <APIDocs @module="color-scheme" @name="getColorScheme" />
  <APIDocs @module="color-scheme" @name="setColorScheme" />
  <APIDocs @module="color-scheme" @name="removeColorScheme" />
</template>
```
