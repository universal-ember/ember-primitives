import { Addon } from "@embroider/addon-dev/rollup";

import { execa } from "execa";
import { execSync } from "node:child_process";
import { babel } from "@rollup/plugin-babel";
import copy from "rollup-plugin-copy";

const addon = new Addon({
  srcDir: "src",
  destDir: "dist",
});

const extensions = [".js", ".ts", ".gts", ".gjs", ".hbs", ".json"];

export default {
  output: addon.output(),
  plugins: [
    addon.publicEntrypoints(["**/*.js"]),
    // Services are the only thing we can't rely on auto-import
    // handling for us.
    addon.appReexports(["services/**/*.js"]),
    addon.dependencies(),
    babel({ extensions, babelHelpers: "inline" }),
    addon.gjs(),
    addon.keepAssets(["**/*.css"]),
    {
      name: "generate types",
      async writeBundle() {
        execa(
          `./node_modules/.bin/ember-tsc`,
          ["--declaration", "--declarationDir", "declarations"],
          {
            cwd: process.cwd(),
            shell: true,
            stdio: "inherit",
          },
        );
      },
    },
    addon.declarations("declarations"),
    addon.clean(),
    copy({
      targets: [
        { src: "../README.md", dest: "." },
        { src: "../LICENSE.md", dest: "." },
      ],
    }),
  ],
};
