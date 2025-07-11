'use strict';

module.exports = {
  extends: 'recommended',
  rules: {
    'no-inline-styles': false,
  },
  overrides: [
    {
      files: ['tests/**/*'],
      rules: {
        'no-invalid-meta': 'off',
        'no-forbidden-elements': 'off',
        'no-action-on-submit-button': 'off',
        'require-input-label': 'off',
      },
    },
  ],
};
