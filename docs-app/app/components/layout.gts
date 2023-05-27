import { service } from 'ember-primitives';

import { Prose } from './prose';

function removeAppShell() {
  document.querySelector('#initial-loader')?.remove();
}

<template>
  {{#let (service 'selected') as |tutorial|}}
    {{#if tutorial.isReady}}

      {{(removeAppShell)}}

      <main
        class='grid w-full md:grid-cols-[minmax(min-content,_50%)_1fr] lg:grid-cols-[640px_1fr] h-[100dvh] max-h-[100dvh]'
        data-container
      >
        <section
          class='transition-transform md:translate-x-0 z-10 border-r border-r-[#ccc] drop-shadow flex flex-col justify-between bg-[#eee] text-black max-h-[100dvh] max-w-[100dvw]'
          data-words
        >
          <div class='grid grid-rows-[min-content_1fr]'>
            <Prose class='max-h-[calc(100dvh-94px)]' />
          </div>
        </section>
      </main>
    {{/if}}
  {{/let}}
</template>
