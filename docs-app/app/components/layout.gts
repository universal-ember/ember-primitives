import { ExternalLink, service } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Header } from './header';
import { Nav } from './nav';
import { Prose } from './prose';

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

const ReportingAnIssue = <template>
  <ExternalLink href="https://github.com/universal-ember/ember-primitives/issues/new">
    reporting an issue
  </ExternalLink>
</template>;

<template>
  {{#let (service "selected") as |page|}}
    {{#if page.prose}}

      {{(removeAppShell)}}

      {{(syncBodyClass)}}

      <Header />
      <main
        class="relative flex justify-center flex-auto w-full mx-auto max-w-8xl sm:px-2 lg:px-8 xl:px-12"
      >
        <Nav />
        <Prose />
      </main>
    {{else if page.hasError}}
      <h1>Oops!</h1>
      {{page.error}}

      <br />
      <br />
      If you have a GitHub account (and the time),
      <ReportingAnIssue />
      would be most helpful! 🎉
    {{/if}}
  {{/let}}
</template>
