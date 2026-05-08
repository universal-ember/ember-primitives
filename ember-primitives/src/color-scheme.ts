import { waitForPromise } from '@ember/test-waiters';

import { cell } from 'ember-resources';

const _colorScheme = cell<string | undefined>();

let callbacks: Set<(colorScheme: string) => void> = new Set();

async function runCallbacks(theme: string) {
  await Promise.resolve();

  for (const callback of callbacks.values()) {
    callback(theme);
  }
}

/**
 * Object for managing the color scheme
 */
export const colorScheme = {
  /**
   * Set's the current color scheme to the passed value
   */
  update: (value: string) => {
    colorScheme.current = value;

    void waitForPromise(runCallbacks(value));
  },

  on: {
    /**
     * register a function to be called when the color scheme changes.
     */
    update: (callback: (colorScheme: string) => void) => {
      callbacks.add(callback);
    },
  },
  off: {
    /**
     * unregister a function that would have been called when the color scheme changes.
     */
    update: (callback: (colorScheme: string) => void) => {
      callbacks.delete(callback);
    },
  },

  /**
   * the current valuel of the "color scheme"
   */
  get current(): string | undefined {
    return _colorScheme.current;
  },
  set current(value: string | undefined) {
    _colorScheme.current = value;

    if (!value) {
      localPreference.delete();

      return;
    }

    localPreference.update(value);
    setColorScheme(value);
  },

  get isDark() {
    return _colorScheme.current === 'dark';
  },
  get isLight() {
    return _colorScheme.current !== 'dark';
  },
};

/**
 * Synchronizes state of `colorScheme` with the users preferences as well as reconciles with previously set theme in local storage.
 *
 * This may only be called once per app.
 */
export function sync() {
  /**
   * reset the callbacks
   */
  callbacks = new Set();

  /**
   * If local prefs are set, then we don't care what prefers-color-scheme is
   */
  const userPreference = localPreference.read();

  if (userPreference) {
    setColorScheme(userPreference);
    _colorScheme.current = userPreference;

    return;
  }

  if (prefers.dark()) {
    setColorScheme('dark');
    _colorScheme.current = 'dark';
  } else if (prefers.light()) {
    setColorScheme('light');
    _colorScheme.current = 'light';
  }
}

const queries = {
  dark: window.matchMedia('(prefers-color-scheme: dark)'),
  light: window.matchMedia('(prefers-color-scheme: light)'),
  none: window.matchMedia('(prefers-color-scheme: no-preference)'),
};

queries.dark.addEventListener('change', (e) => {
  if (localPreference.isSet()) return;

  const mode = e.matches ? 'dark' : 'light';

  colorScheme.update(mode);
});

/**
 * Helper methods to determining what the user's preferred color scheme is
 * based on the system preferences rather than the users explicit preference.
 */
export const prefers = {
  dark: () => queries.dark.matches,
  light: () => queries.light.matches,
  none: () => queries.none.matches,
  custom: (name: string) => window.matchMedia(`(prefers-color-scheme: ${name})`).matches,
};

const LOCAL_PREF_KEY = 'ember-primitives/color-scheme#local-preference';

/**
 * Helper methods for working with the color scheme preference in local storage
 */
export const localPreference = {
  isSet: () => Boolean(localPreference.read()),
  read: () => localStorage.getItem(LOCAL_PREF_KEY),
  update: (value: string) => localStorage.setItem(LOCAL_PREF_KEY, value),
  delete: () => localStorage.removeItem(LOCAL_PREF_KEY),
};

/**
 * The attribute name mirrored alongside the inline `color-scheme`
 * style. Inline-style declarations aren't selectable from CSS, so we
 * also write the value to a plain HTML attribute that authors can
 * target with selectors like `:root[data-color-scheme='dark']`.
 *
 * Some CSS pipelines (notably lightning-css, which Vite uses by
 * default) don't reliably resolve the `light-dark()` function — any
 * variables defined with it can come through computed-empty. Selecting
 * on this attribute side-steps that whole class of issue.
 */
export const COLOR_SCHEME_ATTRIBUTE = 'data-color-scheme';

/**
 * For the given element, returns the `color-scheme` of that element.
 */
export function getColorScheme(element?: HTMLElement) {
  const style = styleOf(element);

  return style.getPropertyValue('color-scheme');
}

export function setColorScheme(element: HTMLElement, value: string): void;
export function setColorScheme(value: string): void;

export function setColorScheme(...args: [string] | [HTMLElement, string]): void {
  if (typeof args[0] === 'string') {
    apply(elementOf(), args[0]);

    return;
  }

  if (typeof args[1] === 'string') {
    apply(args[0], args[1]);

    return;
  }

  throw new Error(`Invalid arity, expected up to 2 args, received ${args.length}`);
}

/**
 * Removes the `color-scheme` from the given element
 */
export function removeColorScheme(element?: HTMLElement) {
  const el = elementOf(element);

  el.style.removeProperty('color-scheme');
  el.removeAttribute(COLOR_SCHEME_ATTRIBUTE);
}

function apply(element: HTMLElement, value: string) {
  element.style.setProperty('color-scheme', value);
  element.setAttribute(COLOR_SCHEME_ATTRIBUTE, value);
}

function styleOf(element?: HTMLElement) {
  return elementOf(element).style;
}

function elementOf(element?: HTMLElement): HTMLElement {
  return element ?? document.documentElement;
}

sync();

window.addEventListener('storage', (e: StorageEvent) => {
  try {
    if (e.key !== LOCAL_PREF_KEY) return;

    // If the key was removed in another tab, fall back to system preference
    if (e.newValue === null) {
      if (prefers.dark()) {
        colorScheme.update('dark');

        return;
      } else if (prefers.light()) {
        colorScheme.update('light');

        return;
      }

      // default to light
      colorScheme.update('light');

      return;
    }

    const newScheme = e.newValue;

    colorScheme.update(newScheme);
  } catch {
    // swallow errors from storage event handling
  }
});
