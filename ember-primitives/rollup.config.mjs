import { Addon } from "@embroider/addon-dev/rollup";

import { babel } from "@rollup/plugin-babel";
import copy from "rollup-plugin-copy";
import { copyFile, mkdir } from "node:fs/promises";
import { join, resolve } from "node:path";

const addon = new Addon({
  srcDir: "src",
  destDir: "dist",
});

const extensions = [".js", ".ts", ".gts", ".gjs", ".hbs", ".json"];

export default {
  output: addon.output(),
  plugins: [
    addon.publicEntrypoints(["**/*.js"]),
    addon.dependencies(),
    babel({ extensions, babelHelpers: "inline" }),
    addon.gjs(),
    addon.keepAssets(["**/*.css"]),
    addon.declarations(
      "declarations",
      "pnpm ember-tsc --declaration --declarationDir declarations",
    ),
    copy({
      targets: [
        { src: "../README.md", dest: "." },
        { src: "../LICENSE.md", dest: "." },
      ],
    }),
    {
      name: "inline:copy-optional-assets",
      async writeBundle() {
        let cwd = process.cwd();
        await mkdir(join(cwd, "./dist/components"), { recursive: true });
        await copyFile(
          resolve(cwd, "./src/components/violations.css"),
          join(cwd, "./dist/components/violations.css"),
        );
      },
    },
    addon.clean(),
  ],
};
