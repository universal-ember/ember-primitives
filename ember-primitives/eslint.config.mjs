// eslint.config.js
import { configs } from "@nullvoxpopuli/eslint-configs";

const config = configs.ember(import.meta.dirname);

export default [
  ...config,
    {
      files: ['./src/components/toggle-group.gts'],
      rules: {
        '@typescript-eslint/no-explicit-any': 'off',
      },
    },
    {
      files: ['*.{js,cjs}'],
      rules: {
        'n/no-unsupported-features': 'off',
      },
    },
  ];
