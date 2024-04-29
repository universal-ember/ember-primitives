'use strict';

const { configs } = require('@nullvoxpopuli/eslint-configs');

// accommodates: JS, TS, App, Addon, and V2 Addon
const config = configs.ember();

module.exports = {
  ...config,
  overrides: [
    ...config.overrides,
    {
      files: ['**/*.gts'],
      plugins: ['ember'],
      parser: 'ember-eslint-parser',
    },
    {
      files: ['**/*.gjs'],
      plugins: ['ember'],
      parser: 'ember-eslint-parser',
    },
    {
      files: ['tests/**/*'],
      rules: {
        'ember/no-shadow-route-definition': 'off',
      },
    },
    {
      files: ['**/*.ts', '**/*.gts'],
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
  ],
};
