import { on } from '@ember/modifier';

import { Switch } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Moon, Sun } from './icons';

function toggleTheme() {
  if (colorScheme.current === 'dark') {
    colorScheme.update('light');
  } else {
    colorScheme.update('dark');
  }
}

function isDark() {
  return colorScheme.current === 'dark';
}

export const ThemeToggle = <template>
  <Switch id="site-theme-toggle" as |s|>
    <s.Control name="color-scheme" checked={{(isDark)}} {{on "change" toggleTheme}} />
    <s.Label>
      <span class="sr-only">Toggle between light and dark mode</span>
      {{!
        🎵 It's raining, it's pouring, ... 🎵
        https://www.youtube.com/watch?v=ll5ykbAumD4
      }}
      <Moon class="fill-sky-400" />
      <Sun class="fill-yellow-400" />
      <span class="ball"></span>
    </s.Label>
  </Switch>

  {{! template-lint-disable no-forbidden-elements }}
  <style>
    #site-theme-toggle { display: flex; justify-content: center; align-items: center;
    flex-direction: column; text-align: center; margin: 0; transition: background 0.2s linear; }
    #site-theme-toggle .sr-only { margin-left: -0.5rem; } #site-theme-toggle
    input[type='checkbox'][role='switch'] { opacity: 0; position: absolute; } #site-theme-toggle
    label { background-color: #111; width: 50px; height: 26px; border-radius: 50px; position:
    relative; padding: 5px; cursor: pointer; display: flex; justify-content: space-between;
    align-items: center; gap: 0.5rem; box-shadow: inset 1px 0px 1px gray; } #site-theme-toggle label
    .ball { background-color: #fff; width: 22px; height: 22px; position: absolute; left: 2px; top:
    2px; border-radius: 50%; transition: transform 0.2s linear; } #site-theme-toggle
    input[type='checkbox'][role='switch']:checked + label .ball { transform: translateX(24px); }
  </style>
</template>;
