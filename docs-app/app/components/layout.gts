import { on } from '@ember/modifier';
import { service } from 'ember-primitives';

import { Prose } from './prose';
import { Nav } from './nav';

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

const toggleTheme = () => {
  let docStyle = document.documentElement.style;

  let current = docStyle.colorScheme;
  let prefersDark = window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches

  if (!current) {
    if (prefersDark) {
      docStyle.setProperty('color-scheme', 'light');
      return
    }

    return docStyle.setProperty('color-scheme', 'dark');
  }

  if (current === 'dark') {
    return docStyle.setProperty('color-scheme', 'light');
  }

  return docStyle.setProperty('color-scheme', 'dark');
}

<template>
  {{#let (service 'selected') as |tutorial|}}
    {{#if tutorial.isReady}}

      {{(removeAppShell)}}

      <button type="button" {{on 'click' toggleTheme}}> Toggle </button>

      <main id="layout">
        <Nav />
        <section>
          <div>
            <Prose />
          </div>
        </section>
      </main>
    {{/if}}
  {{/let}}
</template>
