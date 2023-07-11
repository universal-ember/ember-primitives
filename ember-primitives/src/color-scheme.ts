import { cell } from 'ember-resources';

const _colorScheme = cell<string | undefined>();

export const colorScheme = {
  update: (value: string) => (colorScheme.current = value),

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
};

export function sync() {
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

export const prefers = {
  dark: () => {
    // Fastboot has no graceful fallbacks
    if (typeof matchMedia === 'undefined') return;

    return window.matchMedia('(prefers-color-scheme: dark)').matches;
  },
  light: () => {
    // Fastboot has no graceful fallbacks
    if (typeof matchMedia === 'undefined') return;

    return window.matchMedia('(prefers-color-scheme: light)').matches;
  },
  custom: (name: string) => {
    // Fastboot has no graceful fallbacks
    if (typeof matchMedia === 'undefined') return;

    return window.matchMedia(`(prefers-color-scheme: ${name})`).matches;
  },
  none: () => {
    // Fastboot has no graceful fallbacks
    if (typeof matchMedia === 'undefined') return;

    return window.matchMedia('(prefers-color-scheme: no-preference)').matches;
  },
};

const LOCAL_PREF_KEY = 'ember-primitives/color-scheme#local-preference';

export const localPreference = {
  isSet: () => Boolean(localPreference.read()),
  read: () => {
    // Fastboot has no graceful fallbacks
    if (typeof localStorage === 'undefined') return;

    return localStorage.getItem(LOCAL_PREF_KEY);
  },
  update: (value: string) => {
    // Fastboot has no graceful fallbacks
    if (typeof localStorage === 'undefined') return;

    return localStorage.setItem(LOCAL_PREF_KEY, value);
  },
  delete: () => {
    // Fastboot has no graceful fallbacks
    if (typeof localStorage === 'undefined') return;

    return localStorage.removeItem(LOCAL_PREF_KEY);
  },
};

export function getColorScheme(element?: HTMLElement) {
  let style = styleOf(element);

  return style.getPropertyValue('color-scheme');
}

export function setColorScheme(element: HTMLElement, value: string): void;
export function setColorScheme(value: string): void;

export function setColorScheme(...args: [string] | [HTMLElement, string]): void {
  if (typeof args[0] === 'string') {
    styleOf().setProperty('color-scheme', args[0]);

    return;
  }

  if (typeof args[1] === 'string') {
    styleOf(args[0]).setProperty('color-scheme', args[1]);
  }

  throw new Error(`Invalid arity, expected up to 2 args, received ${args.length}`);
}

export function removeColorScheme(element?: HTMLElement) {
  let style = styleOf(element);

  style.removeProperty('color-scheme');
}

function styleOf(element?: HTMLElement) {
  if (element) {
    return element.style;
  }

  return document.documentElement.style;
}
