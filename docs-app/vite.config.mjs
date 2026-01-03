import { classicEmberSupport, ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { kolay } from "kolay/vite";
import { defineConfig } from "vite";
import { scopedCSS } from "ember-scoped-css/vite";

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
      classicEmberSupport(),
      ember(),
      kolay({
        src: "public/docs",
        groups: [],
        packages: ["ember-primitives", "which-heading-do-i-need"],
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
      // for top-level-await, etc
      esbuildOptions: {
        target: "esnext",
      },
    },
  };
});
