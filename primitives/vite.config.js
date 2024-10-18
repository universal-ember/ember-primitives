import { readFile } from 'node:fs/promises';
import { join, resolve } from 'node:path';

import { babel } from '@rollup/plugin-babel';
import { defineConfig } from 'vite';

const entrypoints = ['index.ts', 'switch.ts'];

const manifestStr = await readFile(join(import.meta.dirname, 'package.json'));
const manifest = JSON.parse(manifestStr);
// Why is this not default?
// Why else would you specify (peer)deps?
const externals = [
  ...Object.keys(manifest.dependencies ?? {}),
  ...Object.keys(manifest.peerDependencies ?? {}),
];

export default defineConfig({
  build: {
    outDir: 'dist',
    // These targets are not "support".
    // A consuming app or library should compile further if they need to support
    // old browsers.
    target: ['esnext', 'firefox121'],
    minify: false,
    sourcemap: true,
    lib: {
      // Could also be a dictionary or array of multiple entry points
      entry: entrypoints.map((name) => resolve(import.meta.dirname, 'src', name)),
      name: 'primitives',
      formats: ['es'],
      // the proper extensions will be added
    },
    rollupOptions: {
      external: [...externals, 'lit/decorators.js'],
    },
  },
  plugins: [
    babel({
      babelHelpers: 'bundled',
      extensions: ['.js', '.ts'],
    }),
  ],
});
