import { modifier } from 'ember-modifier';

import { service } from 'ember-primitives';

import type { TOC } from '@ember/component/template-only';

import { highlight } from './highlight';

const resetScroll = modifier((element, [prose]) => {
  prose;
  element.scrollTo(0, 0);
});

export const Prose: TOC<{ Element: HTMLDivElement }> = <template>
  {{#let (service 'docs') as |docs|}}
    <div
      class='grid gap-4 overflow-auto pb-8 w-fit w-full'
      ...attributes
      {{resetScroll docs.selected.prose}}
    >

      <div data-prose class='prose p-4' {{highlight docs.selected.prose}}>
        {{#if docs.selected.prose}}
          <docs.selected.prose />
        {{/if}}
      </div>

      <hr class='border' />

    </div>
  {{/let}}
</template>;
