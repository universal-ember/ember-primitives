import './theme-toggle.css';

import { on } from '@ember/modifier';

import { Switch } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Moon, Sun } from './icons.gts';

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
  <Switch class="site-theme-toggle" as |s|>
    <s.Control name="color-scheme" checked={{(isDark)}} {{on "change" toggleTheme}} />
    <s.Label>
      <span class="sr-only">Toggle between light and dark mode</span>
      {{!
        🎵 It's raining, it's pouring, ... 🎵
        https://www.youtube.com/watch?v=ll5ykbAumD4
      }}
      <Moon style="fill: #94a3b8;" />
      <Sun style="fill: #facc15;" />
      <span class="ball"></span>
    </s.Label>
  </Switch>
</template>;
