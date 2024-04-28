// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { Header } from 'docs-app/components/header';
import { Nav } from 'docs-app/components/nav';
import pageTitle from 'ember-page-title/helpers/page-title';
import { colorScheme } from 'ember-primitives/color-scheme';
import Route from 'ember-route-template';

export default Route(
  <template>
    {{pageTitle "ember-primitives"}}
    {{(removeAppShell)}}
    {{(syncBodyClass)}}

    <div class="flex w-full flex-col">
      <Header />
      <main
        class="relative flex justify-center flex-auto w-full mx-auto max-w-8xl sm:px-2 lg:px-8 xl:px-12"
      >
        <Nav />
        {{outlet}}
      </main>
    </div>
  </template>
);

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

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
