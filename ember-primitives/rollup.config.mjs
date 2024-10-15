import { Addon } from "@embroider/addon-dev/rollup";

import { babel } from "@rollup/plugin-babel";
import { execaCommand } from "execa";
import { fixBadDeclarationOutput } from "fix-bad-declaration-output";
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
    addon.hbs(),
    addon.gjs(),
    addon.keepAssets(["**/*.css"]),
    addon.clean(),
    copy({
      targets: [
        { src: "../README.md", dest: "." },
        { src: "../LICENSE.md", dest: "." },
      ],
    }),
    {
      name: "Build Declarations",
      closeBundle: async () => {
        /**
         * Generate the types (these include /// <reference types="ember-source/types"
         * but our consumers may not be using those, or have a new enough ember-source that provides them.
         */
        console.info("Building types");
        await execaCommand(`pnpm glint --declaration`, { stdio: "inherit" });
        /**
         * https://github.com/microsoft/TypeScript/issues/56571#
         * README: https://github.com/NullVoxPopuli/fix-bad-declaration-output
         */
        console.info("Fixing types");
        await fixBadDeclarationOutput("declarations/**/*.d.ts", [
          ["TypeScript#56571", { types: "all" }],
          "Glint#628",
          "Glint#697",
        ]);
        console.info("⚠️ Dangerously (but neededly) fixed bad declaration output from typescript");
      },
    },
  ],
};
