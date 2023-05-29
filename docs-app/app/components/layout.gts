import { service } from 'ember-primitives';

import { Nav } from './nav';
import { Prose } from './prose';

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

<template>
  {{#let (service 'selected') as |page|}}
    {{#if page.prose}}

      {{(removeAppShell)}}

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
