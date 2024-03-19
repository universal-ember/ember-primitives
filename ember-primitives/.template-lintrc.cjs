'use strict';

module.exports = {
  extends: 'recommended',
  rules: {
    'no-forbidden-elements': 'off',
  },
  overrides: [
    {
      files: ['src/components/toggle-group.gts'],
      rules: {
        // https://github.com/typed-ember/glint/issues/715
        'no-args-paths': 'off',
      },
    },
  ],
};
