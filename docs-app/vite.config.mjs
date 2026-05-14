import { ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { kolay } from "kolay/vite";
import { globby } from "globby";
import { defineConfig } from "vite";
import { scopedCSS } from "ember-scoped-css/vite";
import { emberSsg } from "vite-ember-ssr/vite-plugin";
import rehypeShiki from "@shikijs/rehype";

/**
 * Replace runtime-only deps with empty stubs during SSR. Pre-rendering
 * never exercises the REPL's runtime template compilation, but bundling
 * content-tag/babel-standalone into the SSR build trips up rolldown
 * (and isn't useful even if it built).
 */
function stubRuntimeOnlyDepsForSsr() {
  const stubs = new Map([
    ["content-tag", "export class Preprocessor {}; export default { Preprocessor };"],
    ["@babel/standalone", "export default {};"],
    /**
     * Imported via named export by demo snippets in markdown samples.
     * lorem-ipsum is CJS and rolldown can't extract named exports from
     * CJS during SSR builds, so substitute an ESM stub. The real package
     * loads client-side after rehydration.
     */
    [
      "lorem-ipsum",
      'export const loremIpsum = () => ""; export class LoremIpsum { generateSentences() { return ""; } generateParagraphs() { return ""; } generateWords() { return ""; } } export default { loremIpsum, LoremIpsum };',
    ],
  ]);

  return {
    name: "docs-app:stub-runtime-only-deps-for-ssr",
    enforce: "pre",
    resolveId(id, _importer, options) {
      if (!options?.ssr) return;
      if (stubs.has(id)) return `\0virtual:ssr-stub:${id}`;
    },
    load(id) {
      const prefix = "\0virtual:ssr-stub:";
      if (!id.startsWith(prefix)) return;
      return stubs.get(id.slice(prefix.length));
    },
  };
}

export default defineConfig(async ({ isSsrBuild } = {}) => {
  const docsRoutes = (await globby("app/templates/**/*.gjs.md", { cwd: import.meta.dirname }))
    .map((p) => p.replace(/^app\/templates\//, "").replace(/\.gjs\.md$/, ".md"))
    .sort();

  return {
    /**
     * Force a single SSR bundle. Without this, rolldown splits Ember
     * into chunks that circular-import `@ember/object` internals — the
     * `ComputedProperty` class isn't initialized by the time
     * `proxy.js`'s top-level `computed()` calls run.
     *
     * The banner installs no-op shims for globals that downstream
     * modules read while loading (repl-sdk constructs a `new Worker(...)`
     * at module-eval; @embroider/macros expects `process.env`). Rolldown
     * inlines our app's module bodies after vendor inits, so a polyfill
     * import isn't early enough — the banner runs before the first
     * statement of the bundle.
     */
    build: isSsrBuild
      ? {
          rollupOptions: {
            output: {
              inlineDynamicImports: true,
              banner: [
                "globalThis.process ??= { env: {} };",
                "globalThis.Buffer ??= {};",
                "globalThis.Worker ??= class { postMessage(){} terminate(){} addEventListener(){} removeEventListener(){} };",
                /**
                 * repl-sdk captures browser-only globals into a
                 * `standardScope` map at module init. Provide minimal
                 * shims so the capture step doesn't throw under Node.
                 */
                "globalThis.postMessage ??= () => {};",
                "globalThis.localStorage ??= { getItem(){return null}, setItem(){}, removeItem(){}, clear(){}, key(){return null}, length: 0 };",
                "globalThis.sessionStorage ??= globalThis.localStorage;",
                "globalThis.isSecureContext ??= false;",
                /**
                 * happy-dom installs `window` but not its DOM
                 * interfaces or layout APIs on globalThis. A few demos
                 * touch them at module init.
                 */
                "if (globalThis.window) {",
                "  globalThis.Text ??= globalThis.window.Text;",
                "  globalThis.getComputedStyle ??= globalThis.window.getComputedStyle?.bind(globalThis.window);",
                /**
                 * happy-dom lacks the Popover API. Stub it so demos
                 * that call showPopover() on render don't throw.
                 */
                "  if (globalThis.window.HTMLElement) {",
                "    globalThis.window.HTMLElement.prototype.showPopover ??= function() {};",
                "    globalThis.window.HTMLElement.prototype.hidePopover ??= function() {};",
                "    globalThis.window.HTMLElement.prototype.togglePopover ??= function() {};",
                "  }",
                /**
                 * happy-dom never fires onload/onerror on `<img>`
                 * elements (no resource fetching). Make src setter
                 * synthesise an onload microtask so `ReactiveImage`'s
                 * waitForPromise waiter resolves and settled() can
                 * complete without hitting the per-route timeout.
                 */
                "  const HTMLImageElement = globalThis.window.HTMLImageElement;",
                "  if (HTMLImageElement) {",
                "    const desc = Object.getOwnPropertyDescriptor(HTMLImageElement.prototype, 'src');",
                "    Object.defineProperty(HTMLImageElement.prototype, 'src', {",
                "      configurable: true,",
                "      get() { return desc?.get ? desc.get.call(this) : this.getAttribute('src'); },",
                "      set(v) {",
                "        if (desc?.set) desc.set.call(this, v); else this.setAttribute('src', v);",
                "        queueMicrotask(() => { try { this.onload?.(new Event('load')); } catch {} });",
                "      },",
                "    });",
                "  }",
                "}",
              ].join("\n"),
            },
          },
        }
      : {},
    plugins: [
      stubRuntimeOnlyDepsForSsr(),
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
      emberSsg({
        routes: ["index", ...docsRoutes],
        ssrEntry: "app/app-ssr.ts",
        rehydrate: true,
      }),
    ],
    ssr: {
      noExternal: [/./],
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
