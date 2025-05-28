import Route from '@ember/routing/route';

import rehypeShikiFromHighlighter from '@shikijs/rehype/core';
import { setupTabster } from 'ember-primitives/tabster';
import { setupKolay } from 'kolay/setup';
import { createHighlighterCore } from 'shiki/core';
import { createOnigurumaEngine } from 'shiki/engine/oniguruma';

import { Callout } from '@universal-ember/docs-support';

import { APIDocs, ComponentSignature, ModifierSignature } from './api-docs';

export default class Application extends Route {
  async model() {
    const highlighter = await createHighlighterCore({
      themes: [import('shiki/themes/github-dark.mjs'), import('shiki/themes/github-light.mjs')],
      langs: [
        import('shiki/langs/javascript.mjs'),
        import('shiki/langs/typescript.mjs'),
        import('shiki/langs/bash.mjs'),
        import('shiki/langs/css.mjs'),
        import('shiki/langs/diff.mjs'),
        import('shiki/langs/html.mjs'),
        import('shiki/langs/glimmer-js.mjs'),
        import('shiki/langs/glimmer-ts.mjs'),
        import('shiki/langs/handlebars.mjs'),
        import('shiki/langs/jsonc.mjs'),
        import('shiki/langs/markdown.mjs'),
      ],
      engine: createOnigurumaEngine(() => import('shiki/wasm')),
    });

    const [manifest] = await Promise.all([
      setupTabster(this),
      setupKolay(this, {
        topLevelScope: {
          Callout,
          APIDocs,
          ComponentSignature,
          ModifierSignature,
        },
        resolve: {
          // ember-primitives
          'ember-primitives': import('ember-primitives'),
          'ember-primitives/floating-ui': import('ember-primitives/floating-ui'),
          'ember-primitives/on-resize': import('ember-primitives/on-resize'),
          'ember-primitives/color-scheme': import('ember-primitives/color-scheme'),
          'ember-primitives/components/form': import('ember-primitives/components/form'),

          // community libraries
          'ember-resources': import('ember-resources'),
          'reactiveweb/remote-data': import('reactiveweb/remote-data'),
          // @ts-expect-error - no types provided
          'ember-focus-trap/modifiers/focus-trap': import('ember-focus-trap/modifiers/focus-trap'),
          // @ts-expect-error - no types provided
          'ember-focus-trap': import('ember-focus-trap'),

          // utility
          '@ember/test-waiters': import('@ember/test-waiters'),
          'lorem-ipsum': import('lorem-ipsum'),
          'form-data-utils': import('form-data-utils'),
          kolay: import('kolay'),
        },
        rehypePlugins: [
          [
            rehypeShikiFromHighlighter,
            highlighter,
            {
              // Theme chosen by CSS variables in app/css/site/shiki.css
              defaultColor: false,
              themes: {
                light: 'github-light',
                dark: 'github-dark',
              },
            },
          ],
        ],
      }),
    ]);

    return { manifest };
  }
}
