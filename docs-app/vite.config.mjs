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
import { createRequire } from "node:module";

import { babel } from "@rollup/plugin-babel";
import { kolay } from "kolay/vite";
import { defineConfig } from "vite";

const require = createRequire(import.meta.url);

const extensions = [".mjs", ".gjs", ".js", ".mts", ".gts", ".ts", ".hbs", ".json"];

const aliasPlugin = {
  name: "deal-with-weird-pre-official-runtime-compiler",
  setup(build) {
    // Intercept import paths called "env" so esbuild doesn't attempt
    // to map them to a file system location. Tag them with the "env-ns"
    // namespace to reserve them for this plugin.
    build.onResolve({ filter: /^kolay.*:virtual$/ }, (args) => ({
      path: args.path,
      external: true,
    }));

    build.onResolve({ filter: /ember-template-compiler/ }, () => ({
      path: require.resolve("ember-source/dist/ember-template-compiler"),
    }));

    build.onResolve({ filter: /content-tag$/ }, () => ({
      path: "content-tag",
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
        groups: [],
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
      target: "esnext",
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
