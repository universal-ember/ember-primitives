import 'ember-mobile-menu/themes/android';

import { Header } from 'docs-app/components/header';
import { Nav } from 'docs-app/components/nav';
import { Menu } from 'docs-app/components/icons';
import pageTitle from 'ember-page-title/helpers/page-title';
import { colorScheme } from 'ember-primitives/color-scheme';
import Route from 'ember-route-template';
import MenuWrapper from 'ember-mobile-menu/components/mobile-menu-wrapper';

export default Route(
  <template>
    {{pageTitle "ember-primitives"}}
    {{(syncBodyClass)}}

    <MenuWrapper as |mmw|>
      <mmw.MobileMenu @mode="push" @maxWidth={{270}} as |mm|>
        <Nav @onClick={{mm.actions.close}} />
      </mmw.MobileMenu>

      <mmw.Content>
        <Header>
          <mmw.Toggle>
            <Menu class="w-6 h-6 stroke-slate-500" />
          </mmw.Toggle>
        </Header>

        <div class="big-layout">
          <Nav />

          <main
            class="relative flex justify-center flex-auto w-full mx-auto max-w-8xl sm:px-2 lg:px-8 xl:px-12"
          >
            {{outlet}}
          </main>
        </div>
      </mmw.Content>
    </MenuWrapper>

    {{!-- prettier-ignore --}}
    <style>
      .mobile-menu-wrapper {
        height: 100dvh;
        overflow: auto;
      }
      .mobile-menu-wrapper__content,
      .mobile-menu__tray {
        background: none;
      }

      header {
        border-bottom: 1px solid currentColor;
      }

      header button.mobile-menu__toggle {
        padding: 0.25rem 0.5rem;
        background: none;
        color: currentColor;
        width: 48px;
        height: 44px;
        display: inline-flex;
        align-self: center;
        align-items: center;
        justify-content: center;
        margin: 0;
      }

      @media (min-width: 768px) {
        header button.mobile-menu__toggle {
          display: none;
        }
      }

      @media (max-width: 768px) {
        .big-layout aside { display: none; }
      }

      .big-layout {
        display: grid;
        grid-template-columns: max-content 1fr;
        gap: 2rem;
        margin: 0 auto;
        max-width: 90rem;

        main {
          max-width: 100%;
          display: flex;
          flex-direction: column;
          overflow-x: hidden;
        }
      }


      .mobile-menu__tray, .big-layout {
        overflow-x: hidden;

        nav {
          padding: 1rem;

          ul {
            padding-left: 0.5rem;
            list-style: none;
            line-height: 1.75rem;
          }
        }
      }
    </style>
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
