import { classicEmberSupport, ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { kolay } from "kolay/vite";
import { defineConfig } from "vite";

export default defineConfig((/* { mode } */) => {
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
      classicEmberSupport(),
      ember(),
      kolay({
        src: "public/docs",
        groups: [],
        packages: ["ember-primitives"],
      }),
      babel({
        babelHelpers: "runtime",
        extensions,
      }),
    ],
    optimizeDeps: {
      // a wasm-providing dependency
      exclude: ["content-tag", "ember-primitives"],
      // for top-level-await, etc
      esbuildOptions: {
        target: "esnext",
      },
    },
  };
});
