import Route from '@ember/routing/route';

import rehypeShikiFromHighlighter from '@shikijs/rehype/core';
import { SetupInstructions } from 'docs-app/components/setup.gts';
import { KeyCombo } from 'ember-primitives/components/keys';
import { setupTabster } from 'ember-primitives/tabster';
import { setupKolay } from 'kolay/setup';
import { createHighlighterCore } from 'shiki/core';
import { createOnigurumaEngine } from 'shiki/engine/oniguruma';
import {
  tracked as wrappedTracked,
  TrackedArray,
  TrackedMap,
  TrackedObject,
  TrackedSet,
  TrackedWeakMap,
  TrackedWeakSet,
} from 'tracked-built-ins';

// import { visit } from 'unist-util-visit';
import { Callout } from '@universal-ember/docs-support';

import { Tabs } from '../components/tabs.gts';
import { APIDocs, Comment, comment, ComponentSignature, ModifierSignature } from './api-docs';

export default class Application extends Route {
  async model() {
    const shiki = await import('./shiki.ts');
    const highlighter = await createHighlighterCore({
      themes: [shiki.dark, shiki.light],
      langs: shiki.langs,
      engine: createOnigurumaEngine(() => import('shiki/wasm')),
    });

    const [manifest] = await Promise.all([
      setupTabster(this),
      setupKolay(this, {
        // This won't work, because the compiler can't find the element to rendedr in to.
        // remarkPlugins: [
        //   () => (tree) => {
        //     let opening = '<Shadowed>';
        //     visit(tree, 'code', (node, index, parent) => {
        //       if (!parent || typeof index !== 'number') return;
        //       if (parent.children[index - 1].value === opening) return;
        //
        //       parent.children.splice(index, 1, { type: 'html', value: opening }, node, {
        //         type: 'html',
        //         value: '</Shadowed>',
        //       });
        //     });
        //   },
        // ],
        topLevelScope: {
          SetupInstructions,
          Callout,
          APIDocs,
          ComponentSignature,
          ModifierSignature,
          Comment,
          Tabs,
          KeyCombo,
          comment,
        },
        modules: {
          // us
          '#src/api-docs': () => import('./api-docs.gts'),
          /*********************************
           *
           * importing from: "#public/*"
           * matches:
           * - "../../public/docs/*"
           *
           * -----------------------------------
           *
           * This has to be done in-app, rather than via the kolay plugin,
           * because this is customizable, and I don't want to add "Magic"
           * to the import-creation process.
           *
           * If I were to do it in the kolay plugin, I'd have to decide on a naming convention,
           * and have potentially mis-implement things.
           * At least with this being an early demo, it's safer to have it in userland for now.
           * Anyone is welcome to try to convince me to build it in somehow, but I think it would require
           * me parsing the markdown at build time, which I'm not sure I want to do 🤔
           *
           * TODO:
           * currently when importing from the public directory, we get a warning about unconventional behavior from vite:
           *     If you intend to use the URL of that asset, use /docs/3-ui/tabs/right-tabs.gjs?url.
           *     Assets in public directory cannot be imported from JavaScript.
           *     If you intend to import that asset, put the file in the src directory, and use /src/docs/3-ui/tabs/left-tabs.gjs instead of /public/docs/3-ui/tabs/left-tabs.gjs.
           *     If you intend to use the URL of that asset, use /docs/3-ui/tabs/left-tabs.gjs?url.
           *
           * (which is fair)
           *
           * Silencing this warning *is* something the Kolay build plugin could probably easily do.
           *
           ********************************/
          ...(() => {
            const modules = import.meta.glob('./**/*.{gjs,gts,js,ts}', {
              base: '../../public/docs',
            });

            const reformatted: Record<string, unknown> = {};

            for (const [relativePath, module] of Object.entries(modules)) {
              const availableName = relativePath.replace(/^./, '#public').replace('.gjs', '');

              reformatted[availableName] = module;
            }

            // console.log(reformatted);

            return reformatted;
          })(),

          // ember-primitives
          'ember-primitives': () => import('ember-primitives'),
          'ember-primitives/head': () => import('ember-primitives/head'),
          'ember-primitives/viewport': () => import('ember-primitives/viewport'),
          'ember-primitives/floating-ui': () => import('ember-primitives/floating-ui'),
          'ember-primitives/on-resize': () => import('ember-primitives/on-resize'),
          'ember-primitives/resize-observer': () => import('ember-primitives/resize-observer'),
          'ember-primitives/color-scheme': () => import('ember-primitives/color-scheme'),
          'ember-primitives/components/form': () => import('ember-primitives/components/form'),
          'ember-primitives/components/drawer': () => import('ember-primitives/components/drawer'),
          'ember-primitives/components/heading': () =>
            import('ember-primitives/components/heading'),
          'ember-primitives/components/tabs': () => import('ember-primitives/components/tabs'),
          'ember-primitives/components/portal': () => import('ember-primitives/components/portal'),
          'ember-primitives/components/portal-targets': () =>
            import('ember-primitives/components/portal-targets'),
          'ember-primitives/dom-context': () => import('ember-primitives/dom-context'),
          'ember-primitives/layout/hero': () => import('ember-primitives/layout/hero'),

          // community libraries
          'ember-resources': () => import('ember-resources'),
          'tracked-built-ins': () => {
            return {
              TrackedObject,
              TrackedArray,
              TrackedMap,
              TrackedWeakMap,
              TrackedSet,
              TrackedWeakSet,
              tracked: wrappedTracked,
            };
          },
          'reactiveweb/remote-data': () => import('reactiveweb/remote-data'),
          'reactiveweb/debounce': () => import('reactiveweb/debounce'),
          'reactiveweb/sync': () => import('reactiveweb/sync'),
          'reactiveweb/throttle': () => import('reactiveweb/throttle'),
          'reactiveweb/link': () => import('reactiveweb/link'),
          'reactiveweb/document-head': () => import('reactiveweb/document-head'),
          'reactiveweb/effect': () => import('reactiveweb/effect'),
          'reactiveweb/fps': () => import('reactiveweb/fps'),
          'reactiveweb/function': () => import('reactiveweb/function'),
          'reactiveweb/get-promise-state': () => import('reactiveweb/get-promise-state'),
          'reactiveweb/image': () => import('reactiveweb/image'),
          'reactiveweb/keep-latest': () => import('reactiveweb/keep-latest'),
          'reactiveweb/wait-until': () => import('reactiveweb/wait-until'),
          'ember-focus-trap/modifiers/focus-trap': () =>
            // @ts-expect-error - no types provided
            import('ember-focus-trap/modifiers/focus-trap'),
          // @ts-expect-error - no types provided
          'ember-focus-trap': () => import('ember-focus-trap'),
          'ember-element-helper': () => import('ember-element-helper'),
          'which-heading-do-i-need': () => import('which-heading-do-i-need'),
          'limber-ui': () => import('limber-ui'),

          // utility
          'decorator-transforms': () => import('decorator-transforms'),
          '@ember/test-waiters': () => import('@ember/test-waiters'),
          'lorem-ipsum': () => import('lorem-ipsum'),
          'form-data-utils': () => import('form-data-utils'),
          kolay: () => import('kolay'),
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
