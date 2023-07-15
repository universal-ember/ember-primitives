import { cell } from 'ember-resources';

const _colorScheme = cell();
const colorScheme = {
  update: value => colorScheme.current = value,
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
function sync() {
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
const prefers = {
  dark: () => window.matchMedia('(prefers-color-scheme: dark)').matches,
  light: () => window.matchMedia('(prefers-color-scheme: light)').matches,
  custom: name => window.matchMedia(`(prefers-color-scheme: ${name})`).matches,
  none: () => window.matchMedia('(prefers-color-scheme: no-preference)').matches
};
const LOCAL_PREF_KEY = 'ember-primitives/color-scheme#local-preference';
const localPreference = {
  isSet: () => Boolean(localPreference.read()),
  read: () => localStorage.getItem(LOCAL_PREF_KEY),
  update: value => localStorage.setItem(LOCAL_PREF_KEY, value),
  delete: () => localStorage.removeItem(LOCAL_PREF_KEY)
};
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
  }
  throw new Error(`Invalid arity, expected up to 2 args, received ${args.length}`);
}
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
