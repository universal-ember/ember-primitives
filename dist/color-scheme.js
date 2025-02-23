import { waitForPromise } from '@ember/test-waiters';
import { cell } from 'ember-resources';

const _colorScheme = cell();
let callbacks = new Set();
async function runCallbacks(theme) {
  await Promise.resolve();
  for (let callback of callbacks.values()) {
    callback(theme);
  }
}

/**
 * Object for managing the color scheme
 */
const colorScheme = {
  /**
   * Set's the current color scheme to the passed value
   */
  update: value => {
    colorScheme.current = value;
    waitForPromise(runCallbacks(value));
  },
  on: {
    /**
     * register a function to be called when the color scheme changes.
     */
    update: callback => {
      callbacks.add(callback);
    }
  },
  off: {
    /**
     * unregister a function that would have been called when the color scheme changes.
     */
    update: callback => {
      callbacks.delete(callback);
    }
  },
  /**
   * the current valuel of the "color scheme"
   */
  get current() {
    return _colorScheme.current;
  },
  set current(value) {
    _colorScheme.current = value;
    if (!value) {
      localPreference.delete();
      return;
    }
    localPreference.update(value);
    setColorScheme(value);
  }
};

/**
 * Synchronizes state of `colorScheme` with the users preferences as well as reconciles with previously set theme in local storage.
 *
 * This may only be called once per app.
 */
function sync() {
  /**
   * reset the callbacks
   */
  callbacks = new Set();

  /**
   * If local prefs are set, then we don't care what prefers-color-scheme is
   */
  if (localPreference.isSet()) {
    let pref = localPreference.read();
    if (pref === 'dark') {
      setColorScheme('dark');
      _colorScheme.current = 'dark';
      return;
    }
    setColorScheme('light');
    _colorScheme.current = 'light';
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

/**
 * Helper methods to determining what the user's preferred color scheme is
 */
const prefers = {
  dark: () => window.matchMedia('(prefers-color-scheme: dark)').matches,
  light: () => window.matchMedia('(prefers-color-scheme: light)').matches,
  custom: name => window.matchMedia(`(prefers-color-scheme: ${name})`).matches,
  none: () => window.matchMedia('(prefers-color-scheme: no-preference)').matches
};
const LOCAL_PREF_KEY = 'ember-primitives/color-scheme#local-preference';

/**
 * Helper methods for working with the color scheme preference in local storage
 */
const localPreference = {
  isSet: () => Boolean(localPreference.read()),
  read: () => localStorage.getItem(LOCAL_PREF_KEY),
  update: value => localStorage.setItem(LOCAL_PREF_KEY, value),
  delete: () => localStorage.removeItem(LOCAL_PREF_KEY)
};

/**
 * For the given element, returns the `color-scheme` of that element.
 */
function getColorScheme(element) {
  let style = styleOf(element);
  return style.getPropertyValue('color-scheme');
}
function setColorScheme(...args) {
  if (typeof args[0] === 'string') {
    styleOf().setProperty('color-scheme', args[0]);
    return;
  }
  if (typeof args[1] === 'string') {
    styleOf(args[0]).setProperty('color-scheme', args[1]);
    return;
  }
  throw new Error(`Invalid arity, expected up to 2 args, received ${args.length}`);
}

/**
 * Removes the `color-scheme` from the given element
 */
function removeColorScheme(element) {
  let style = styleOf(element);
  style.removeProperty('color-scheme');
}
function styleOf(element) {
  if (element) {
    return element.style;
  }
  return document.documentElement.style;
}

export { colorScheme, getColorScheme, localPreference, prefers, removeColorScheme, setColorScheme, sync };
//# sourceMappingURL=color-scheme.js.map
