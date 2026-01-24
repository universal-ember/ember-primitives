import { modifier } from 'ember-modifier';
import { cell } from 'ember-resources';
import { Page } from 'kolay/components';

import { Article } from './article.gts';
import { Link } from './links.gts';
import { ResponsiveMenuLayout } from './menu-layout.gts';
import { ThemeToggle } from './theme-toggle.gts';

import type { TOC } from '@ember/component/template-only';

// Removes the App Shell / welcome UI
// before initial rending and chunk loading finishes
function removeLoader() {
  document.querySelector('#initial-loader')?.remove();
}

 
function resetScroll(..._args: unknown[]) {
  document.querySelector('html')?.scrollTo(0, 0);
}

const isScrolled = cell(false);

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

export const PageLayout: TOC<{
  Blocks: {
    logoLink: [];
    topRight: [];
    centerNav: [];
    editLink: [typeof EditLink];
    error: [error: string];
  };
}> = <template>
  <ResponsiveMenuLayout>
    <:header as |Toggle|>
      <header
        class="sticky top-0 z-50 transition duration-500 shadow-md shadow-slate-900/5 dark:shadow-none bg-white/95
          {{if
            isScrolled.current
            'dark:bg-slate-900/95 dark:backdrop-blur dark:[@supports(backdrop-filter:blur(0))]:bg-slate-900/75'
            'dark:bg-slate-900/95'
          }}"
        {{onWindowScroll}}
      >
        <div class="outer-content flex flex-none flex-wrap items-center justify-between py-4 relative">
          <div class="flex mr-6 lg:hidden">
            <Toggle />
          </div>
          <div class="relative flex items-center flex-grow basis-0">
            <a href="/" aria-label="Home page">
              {{yield to="logoLink"}}
            </a>
          </div>
          {{#if (has-block "centerNav")}}
            {{yield to="centerNav"}}
          {{/if}}
          {{!
            If we ever have a search bar
              <div class="mr-6 -my-5 sm:mr-8 md:mr-0">
                  input here
              </div>
            }}
          <TopRight>
            {{yield to="topRight"}}
          </TopRight>
        </div>
      </header>
    </:header>
    <:content>
      <section data-main-scroll-container class="flex-auto max-w-2xl min-w-0 py-4 lg:max-w-none">
        <Article>
          <Page>
            <:pending>
              <div
                class="fixed top-12 p-4 rounded z-50 transition border border-slate-800 duration-500 shadow-xl shadow-slate-900/5 bg-white/95 'dark:bg-slate-900/95 dark:backdrop-blur dark:[@supports(backdrop-filter:blur(0))]:bg-slate-900/75'"
              >
                Loading, Compiling, etc
              </div>
            </:pending>

            <:error as |error|>
              <section>
                {{yield error to="error"}}
              </section>
            </:error>

            <:success as |prose|>
              <prose />
              {{(removeLoader)}}
              {{! this is probably really bad, and anti-patterny
                  but ember doesn't have a good way to have libraries
                  tie in to the URL without a bunch of setup -- which is maybe fine?
                  needs some experimenting -- there is a bit of a disconnect with
                  deriving data from the URL, and the timing of the model hooks.
                  It might be possible to have an afterModel hook wait until the page is
                  compiled.
                  (that's why we have async state, because we're compiling, not loading)
              }}
              {{resetScroll prose}}
            </:success>
          </Page>
        </Article>

        {{#if (has-block "editLink")}}

          <div class="flex justify-end pt-6 mt-12 border-t border-slate-200 dark:border-slate-800">

            {{yield EditLink to="editLink"}}
          </div>
        {{/if}}
      </section>
    </:content>

  </ResponsiveMenuLayout>
</template>;

const EditLink: TOC<{ Args: { href: string }; Blocks: { default: [] } }> = <template>
  <Link class="edit-page flex" href={{@href}}>
    {{yield}}
  </Link>
</template>;

export const TopRight: TOC<{ Blocks: { default: [] } }> = <template>
  <div class="relative flex justify-end gap-6 basis-0 sm:gap-8 md:flex-grow">
    <ThemeToggle />
    {{yield}}
  </div>
</template>;
