import { classicEmberSupport, ember, extensions } from "@embroider/vite";

import { babel } from "@rollup/plugin-babel";
import { defineConfig } from "vite";

export default defineConfig(() => ({
  optimizeDeps: {
    exclude: ["ember-primitives"],
  },
  plugins: [
    classicEmberSupport(),
    ember(),
    babel({
      babelHelpers: "runtime",
      extensions,
    }),
  ],
}));
