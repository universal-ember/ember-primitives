// eslint.config.js
import { configs } from "@nullvoxpopuli/eslint-configs";

const config = configs.ember(import.meta.dirname);

export default [
  ...config,
  // your modifications here
  // see: https://eslint.org/docs/user-guide/configuring/configuration-files#how-do-overrides-work

  {
    files: ["**/*.ts", "**/*.gts"],
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

  // Public docs demos live in `public/docs/**/*.gjs`.
  // In a monorepo, the TS ESLint parser can see multiple tsconfig roots;
  // pin it to this package to avoid "No tsconfigRootDir was set" errors.
  {
    files: ["**/*.gjs"],
    languageOptions: {
      parserOptions: {
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
];
