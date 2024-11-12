import {
  assets,
  compatPrebuild,
  contentFor,
  hbs,
  optimizeDeps,
  resolver,
  scripts,
  templateTag,
} from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { kolay } from "kolay/vite";
import { defineConfig } from "vite";

const extensions = [".mjs", ".gjs", ".js", ".mts", ".gts", ".ts", ".hbs", ".json"];

const aliasPlugin = {
  name: "deal-with-weird-pre-official-runtime-compiler",
  setup(build) {
    build.onResolve({ filter: /ember-template-compiler/ }, () => ({
      path: "ember-source/dist/ember-template-compiler",
      external: true,
    }));
  },
};

const optimization = optimizeDeps();

export default defineConfig(async ({ mode }) => {
  return {
    resolve: {
      extensions,
      alias: {
        "ember-template-compiler": "ember-source/dist/ember-template-compiler",
      },
    },
    plugins: [
      kolay({
        src: "public/docs",
        packages: ["ember-primitives"],
      }),
      hbs(),
      templateTag(),
      scripts(),
      resolver(),
      compatPrebuild(),
      assets(),
      contentFor(),

      babel({
        babelHelpers: "runtime",
        extensions,
      }),
    ],
    optimizeDeps: {
      ...optimization,
      exclude: ["content-tag", "ember-repl", "kolay"],
      esbuildOptions: {
        ...optimization.esbuildOptions,
        target: "esnext",
        plugins: [aliasPlugin, ...optimization.esbuildOptions.plugins],
      },
    },

    css: {
      postcss: "./config/postcss.config.mjs",
    },
    esbuild: {
      supported: {
        "top-level-await": true,
      },
    },
    server: {
      port: 4200,
      mimeTypes: {
        "application/wasm": ["wasm"],
      },
    },
    build: {
      outDir: "dist",
      rollupOptions: {
        input: {
          main: "index.html",
          ...(shouldBuildTests(mode) ? { tests: "tests/index.html" } : undefined),
        },
      },
    },
  };
});

function shouldBuildTests(mode) {
  return mode !== "production" || process.env.FORCE_BUILD_TESTS;
}
