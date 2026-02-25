import { ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import tailwindcss from "@tailwindcss/vite";
import { kolay } from "kolay/vite";
import { defineConfig } from "vite";
import { scopedCSS } from "ember-scoped-css/vite";
import rehypeShiki from "@shikijs/rehype";

export default defineConfig(async (/* { mode } */) => {
  return {
    build: {
      target: ["esnext"],
    },
    resolve: {
      extensions,
    },
    plugins: [
      tailwindcss(),
      scopedCSS(),
      ember(),
      kolay({
        packages: ["ember-primitives", "which-heading-do-i-need"],
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
      babel({
        babelHelpers: "runtime",
        extensions,
      }),
    ],
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
      esbuildOptions: {
        target: "esnext",
      },
    },
  };
});
