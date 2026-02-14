import { ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { kolay } from "kolay/vite";
import { defineConfig } from "vite";
import { scopedCSS } from "ember-scoped-css/vite";
import rehypeShiki from "@shikijs/rehype";
import { visit } from "unist-util-visit";

function flatReplaceAt(array, index, replacement) {
  array.splice(index, 1, ...replacement);
}

export default defineConfig(async (/* { mode } */) => {
  return {
    build: {
      target: ["esnext"],
    },
    css: {
      postcss: "./config/postcss.config.mjs",
    },
    resolve: {
      extensions,
    },
    plugins: [
      scopedCSS(),
      ember(),
      kolay({
        packages: ["ember-primitives", "which-heading-do-i-need"],
        remarkPlugins: [
          [
            function codeToRepl(/* options */) {
              return (tree) => {
                return visit(tree, ["code"], function (node, index, parent) {
                  if (node.meta?.includes("repl")) {
                    let { value, lang, meta } = node;

                    let newNode = {
                      value: `<REPL @code="${JSON.stringify(value)}" @format="${lang}" />`,
                      data: {},
                      type: "glimmer_raw",
                      children: [],
                    };
                    flatReplaceAt(parent.children, index, [newNode]);
                    return;
                  }
                });
              };
            },
            {},
          ],
        ],
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
          import { REPL } from 'limber-ui';
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
        // Because we rely on postcss processing
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
