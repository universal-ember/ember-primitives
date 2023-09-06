import { on } from '@ember/modifier';
import { get } from '@ember/object';

import { ExternalLink, service } from 'ember-primitives';

import { Flask, GitHub } from './icons';
import { ThemeToggle } from './theme-toggle';

export const Footer = <template>
  <footer id='site-footer'>
    <div>
      <span class='left'>
        <a href='/'>ember-primitives</a>
      </span>
      <span class='right'>
        <ToggleNav />
        <TestsLink />
        <GitHubLink />
        <ThemeToggle />
      </span>
    </div>
  </footer>
</template>;

const TestsLink = <template>
  <ExternalLink href='/tests' class='icon-link'>
    <span class='small:sr-only'>Tests</span>
    <Flask />
  </ExternalLink>
</template>;

const GitHubLink = <template>
  <ExternalLink class='icon-link' href='https://github.com/universal-ember/ember-primitives'>
    <span class='small:sr-only'>GitHub</span>
    <GitHub />
  </ExternalLink>
</template>;

const ToggleNav = <template>
  <button
    id='nav-toggle'
    aria-label='Toggle navigation'
    type='button'
    {{on 'click' (get (service 'ui') 'toggleNav')}}
  >
    Toggle Nav
  </button>
</template>;
