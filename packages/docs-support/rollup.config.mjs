import { babel } from "@rollup/plugin-babel";
import { Addon } from "@embroider/addon-dev/rollup";
import { scopedCSS } from "ember-scoped-css/rollup";

const addon = new Addon({
  srcDir: "src",
  destDir: "dist",
});

export default {
  output: addon.output(),

  plugins: [
    addon.publicEntrypoints(["index.js", "template-registry.js", "icons.js"]),
    addon.dependencies(),
    scopedCSS(),
    babel({
      extensions: [".js", ".gjs", ".ts", ".gts"],
      babelHelpers: "bundled",
    }),
    addon.hbs(),
    addon.gjs(),
    addon.keepAssets(["**/*.css"]),
    addon.declarations(
      "declarations",
      "pnpm ember-tsc --declaration --declarationDir declarations",
    ),
    addon.clean(),
  ],
};
