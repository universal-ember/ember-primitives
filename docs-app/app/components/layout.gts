
import { service } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

import { Nav } from './nav';
import { Prose } from './prose';

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

function isDark() {
  return colorScheme.current === 'dark';
}

<template>
  {{#let (service 'selected') as |page|}}
    {{#if page.prose}}

      {{(removeAppShell)}}

      {{#if (isDark)}}
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-dark.css" />
      {{else}}
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-light.css" />
      {{/if}}

      <main id="layout">
        <Nav />
        <section>
          <div>
            <Prose />
          </div>
        </section>
      </main>
    {{else if page.hasError}}
      <h1>Oops!</h1>
      {{page.error}}
    {{/if}}
  {{/let}}
</template>
