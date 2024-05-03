import 'ember-mobile-menu/themes/android';
import './layout.css';

import { Header, isScrolled } from 'docs-app/components/header';
import { Menu } from 'docs-app/components/icons';
import { Nav } from 'docs-app/components/nav';
// @ts-expect-error - no types are provided for ember-mobile-menu
import MenuWrapper from 'ember-mobile-menu/components/mobile-menu-wrapper';
import pageTitle from 'ember-page-title/helpers/page-title';
import { colorScheme } from 'ember-primitives/color-scheme';
import Route from 'ember-route-template';

export default Route(
  <template>
    {{pageTitle "ember-primitives"}}
    {{(syncBodyClass)}}

    <MenuWrapper as |mmw|>
      <mmw.MobileMenu @mode="push" @maxWidth={{300}} as |mm|>
        <Nav @onClick={{mm.actions.close}} />
      </mmw.MobileMenu>

      <mmw.Content class="sm:px-2 lg:px-8 xl:px-12">
    <div class="
      facade-header

      bg-white shadow-md shadow-slate-900/5 transition transition-duration-500 dark:shadow-none
      {{if isScrolled.current
        'dark:bg-slate-900/95 dark:backdrop-blur dark:[@supports(backdrop-filter:blur(0))]:bg-slate-900/75'
        'dark:bg-slate-900/95'
      }}"
    ></div>
        <Header>
          <mmw.Toggle>
            <Menu class="w-6 h-6 stroke-slate-500" />
          </mmw.Toggle>
        </Header>

        <Nav />

        <main class="relative flex justify-center flex-auto w-full mx-auto max-w-8xl">
          {{outlet}}
        </main>
      </mmw.Content>
    </MenuWrapper>
  </template>
);

function isDark() {
  return colorScheme.current === 'dark';
}

function syncBodyClass() {
  if (isDark()) {
    document.body.classList.add('dark');
  } else {
    document.body.classList.remove('dark');
  }
}
