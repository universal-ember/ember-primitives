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
        'no-action-on-submit-button': 'off',
      },
    },
  ],
};
