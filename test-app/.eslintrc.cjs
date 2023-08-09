'use strict';

const { configs } = require('@nullvoxpopuli/eslint-configs');

// accommodates: JS, TS, App, Addon, and V2 Addon
const config = configs.ember();

module.exports = {
  ...config,
  overrides: [
    ...config.overrides,
    {
      files: ['tests/**/*'],
      rules: {
        'ember/no-shadow-route-definition': 'off',
      },
    },
    {
      files: ['**/*.ts', '**/*.gts'],
      rules: {
        '@typescript-eslint/prefer-optional-chain': 'off',
        '@typescript-eslint/no-explicit-any': 'off',
      },
    },
  ],
};
