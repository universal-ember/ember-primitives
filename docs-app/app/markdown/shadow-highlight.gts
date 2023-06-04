
import { highlight } from 'docs-app/components/highlight';
import { Shadowed } from 'ember-primitives';
import { colorScheme } from 'ember-primitives/color-scheme';

function isDark() {
  return colorScheme.current === 'dark';
}

export const Wrapper = <template>
  <Shadowed>
    <div {{highlight}}>
      {{#if (isDark)}}
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-dark.css" />
      {{else}}
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/highlight.js@11.8.0/styles/atom-one-light.css" />
      {{/if}}

      {{yield}}
    </div>
  </Shadowed>
</template>;
