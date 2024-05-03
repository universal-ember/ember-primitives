import { modifier } from 'ember-modifier';
import { ExternalLink } from 'ember-primitives';
import { cell } from 'ember-resources';

import { Flask, GitHub, Logo, Logomark } from './icons';
import { ThemeToggle } from './theme-toggle';

import type { TOC } from '@ember/component/template-only';

export const isScrolled = cell(false);

const onWindowScroll = modifier(() => {
  function onScroll() {
    isScrolled.current = window.scrollY > 0;
  }

  onScroll();
  window.addEventListener('scroll', onScroll, { passive: true });

  return () => {
    window.removeEventListener('scroll', onScroll);
  };
});

export const Header: TOC<{ Blocks: { default: [] } }> = <template>
  <header
    class="sticky top-0 z-50 flex flex-none flex-wrap items-center justify-between px-4 py-5 transition duration-500 dark:shadow-none"
    {{onWindowScroll}}
  >
    <div class="flex mr-6 lg:hidden">
      {{yield}}
    </div>
    <div class="relative flex items-center flex-grow basis-0">
      <LogoLink />
    </div>
    {{!
    If we ever have a search bar
      <div class="mr-6 -my-5 sm:mr-8 md:mr-0">
          input here
      </div>
    }}
    <div class="relative flex justify-end gap-6 basis-0 sm:gap-8 md:flex-grow">
      <ThemeToggle />
      <TestsLink />
      <GitHubLink />
    </div>
  </header>
</template>;

const LogoLink = <template>
  <a href="/" aria-label="Home page">
    <Logomark class="h-9 w-28 lg:hidden" />
    <Logo class="hidden w-auto h-9 fill-slate-700 lg:block dark:fill-sky-100" />
  </a>
</template>;

const TestsLink = <template>
  <ExternalLink href="/tests" class="group" aria-label="Tests">
    <Flask
      class="w-6 h-6 fill-slate-400 group-hover:fill-slate-500 dark:group-hover:fill-slate-300"
    />
  </ExternalLink>
</template>;

const GitHubLink = <template>
  <ExternalLink
    class="group"
    href="https://github.com/universal-ember/ember-primitives"
    aria-label="GitHub"
  >
    <GitHub
      class="w-6 h-6 fill-slate-400 group-hover:fill-slate-500 dark:group-hover:fill-slate-300"
    />
  </ExternalLink>
</template>;
