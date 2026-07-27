import { ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { apiDocs, docs } from "kolay/vite";
import { defineConfig } from "vite";
import { scopedCSS } from "ember-scoped-css/vite";
import rehypeShiki from "@shikijs/rehype";

export default defineConfig(async (/* { mode } */) => {
  return {
    plugins: [
      scopedCSS(),
      ember(),
      docs({
        rehypePlugins: [
          [
            rehypeShiki,
            {
              themes: {
                light: "github-light",
                dark: "github-dark",
              },
              defaultColor: "light-dark()",
            },
          ],
        ],
        scope: `
          import { SetupInstructions } from '#src/components/setup.gts';
          import {
            comment, APIDocs, Comment,
            ComponentSignature, ModifierSignature
          } from '#src/routes/api-docs.gts';

          import { Shadowed } from 'ember-primitives/components/shadowed';
          import { InViewport } from 'ember-primitives/viewport';

          import { Callout } from '@universal-ember/docs-support';
        `,
      }),
      apiDocs(["ember-primitives", "which-heading-do-i-need"]),
      babel({
        babelHelpers: "runtime",
        extensions,
      }),
    ],
    build: {
      /**
       * Vite's default cssTarget predates light-dark(), so lightningcss
       * rewrites it into var(--lightningcss-light/dark) space toggles whose
       * :root definitions don't survive chunking — the declarations then
       * fail at computed-value time (kolay's typedoc colors, for example).
       * The rewrite would also key theming off prefers-color-scheme,
       * ignoring our color-scheme toggle. These targets support
       * light-dark() natively.
       */
      cssTarget: ["chrome123", "firefox120", "safari17.5"],
    },
    optimizeDeps: {
      exclude: [
        // a wasm-providing dependency
        "content-tag",
        // this repo
        "ember-primitives",
        "@universal-ember/docs-support",
      ],
      include: [
        "@shikijs/rehype",
        "shiki",
        "reactiveweb/get-promise-state",
        "ember-focus-trap",
        "ember-primitives > tabster",
        "ember-primitives > tracked-built-ins",
        "ember-primitives > tracked-toolbox",
        "ember-primitives > @floating-ui/dom",
        "kolay/components",
        "lorem-ipsum",
        "ember-modifier",
        "limber-ui",
        "decorator-transforms",
      ],
      // for top-level-await, etc
    },
  };
});
