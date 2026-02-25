import { scopedCSS } from "ember-scoped-css/babel";

export default {
  plugins: [
    [
      "@babel/plugin-transform-typescript",
      {
        allExtensions: true,
        onlyRemoveTypeImports: true,
        allowDeclareFields: true,
      },
    ],
    "@embroider/addon-dev/template-colocation-plugin",
    scopedCSS(),
    [
      "babel-plugin-ember-template-compilation",
      {
        targetFormat: "hbs",
        transforms: [scopedCSS.template({})],
      },
    ],
    ["module:decorator-transforms", { runtime: { import: "decorator-transforms/runtime" } }],
  ],
};
