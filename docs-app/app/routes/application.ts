import Route from '@ember/routing/route';
import { service } from '@ember/service';

import rehypeShikiFromHighlighter from '@shikijs/rehype/core';
import { Callout } from 'docs-app/components/callout';
import { getHighlighterCore } from 'shiki/core';
import getWasm from 'shiki/wasm';

import { APIDocs, ComponentSignature } from './api-docs';

import type { SetupService } from 'ember-primitives';
import type { DocsService } from 'kolay';

export default class Application extends Route {
  @service('kolay/docs') declare docs: DocsService;
  @service('ember-primitives/setup') declare primitives: SetupService;

  beforeModel() {
    this.primitives.setup();
  }

  async model() {
    const highlighter = await getHighlighterCore({
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
      loadWasm: getWasm,
    });

    await this.docs.setup({
      apiDocs: import('kolay/api-docs:virtual'),
      manifest: import('kolay/manifest:virtual'),
      topLevelScope: {
        Callout,
        APIDocs,
        ComponentSignature,
      },
      resolve: {
        // ember-primitives
        'ember-primitives': import('ember-primitives'),
        'ember-primitives/floating-ui': import('ember-primitives/floating-ui'),
        'ember-primitives/color-scheme': import('ember-primitives/color-scheme'),
        'ember-primitives/components/form': import('ember-primitives/components/form'),

        // community libraries
        'ember-resources': import('ember-resources'),
        'ember-headless-form': import('ember-headless-form'),
        'reactiveweb/remote-data': import('reactiveweb/remote-data'),
        // @ts-expect-error - no types provided
        'ember-focus-trap/modifiers/focus-trap': import('ember-focus-trap/modifiers/focus-trap'),
        // @ts-expect-error - no types provided
        'ember-focus-trap': import('ember-focus-trap'),

        // utility
        'lorem-ipsum': import('lorem-ipsum'),
      },
      rehypePlugins: [
        [
          // @ts-expect-error - shiki may have the wrong type, since the other plugins are fine
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
    });

    return { manifest: this.docs.manifest };
  }
}
