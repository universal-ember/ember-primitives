import { service } from 'ember-primitives';

import { Nav } from './nav';
import { Prose } from './prose';

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

<template>
  {{#let (service 'selected') as |tutorial|}}
    {{#if tutorial.isReady}}

      {{(removeAppShell)}}

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
