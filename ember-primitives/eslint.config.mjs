// eslint.config.js
import { configs } from "@nullvoxpopuli/eslint-configs";
import compat from "eslint-plugin-compat";

const config = configs.ember(import.meta.dirname);

export default [
  ...config,
  {
    ...compat.configs["flat/recommended"],
    files: ["src/**/*.{js,ts,gjs,gts}"],
  },
  {
    files: ["./src/components/toggle-group.gts"],
    rules: {
      "@typescript-eslint/no-explicit-any": "off",
    },
  },
  {
    files: ["**/*.{ts,gts}"],
    rules: {
      "@typescript-eslint/no-explicit-any": "off",
    },
  },
  {
    files: ["*.{js,cjs}"],
    rules: {
      "n/no-unsupported-features": "off",
    },
  },
];
