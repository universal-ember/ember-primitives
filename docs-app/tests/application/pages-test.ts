import { findAll, settled, visit, waitUntil } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { colorScheme } from 'ember-primitives/color-scheme';
import { docsManager } from 'kolay';

import { a11yAudit } from 'ember-a11y-testing/test-support';

/**
 * per-page settings
 */
const a11yChecks: {
  [url: string]: {
    [checkName: string]: Record<string, unknown>;
  };
} = {
  '/3-ui/heading.md': {
    'landmark-main-is-top-level': {
      enabled: false,
    },
    'landmark-no-duplicate-main': {
      enabled: false,
    },
  },
  '/3-ui/key-combo.md': {
    // Buggy: doesn't allow the "same heading" under different headers
    'heading-order': {
      enabled: false,
    },
  },
  '/5-floaty-bits/portal-targets.md': {
    // Buggy: doesn't allow the "same heading" under different headers
    'heading-order': {
      enabled: false,
    },
  },
};

/**
 * a11yAudit halts tests, this gets around that
 */
async function checkA11y(assert: Assert, path: string, theme: string, settings: object) {
  await settled();

  try {
    await a11yAudit({
      rules: {
        // TODO: find a syntax highlighting theme
        //       with better contrast
        'color-contrast': {
          enabled: false,
        },
        ...settings,
      },
    });
    assert.ok(true, `no a11y errors found for ${path} using the ${theme} theme`);
  } catch (e) {
    let errorText = '';

    if (typeof e === 'object') {
      if (e && 'message' in e && typeof e.message === 'string') {
        errorText = e.message;
      }
    }

    const message = `${path}: no a11y errors found using the ${theme} theme` + `\n\n` + errorText;

    if (window.location.search.includes('debugA11yAudit')) {
      console.error(errorText);
    }

    assert.ok(false, message);
  }
}

module('Application | Pages', function (hooks) {
  setupApplicationTest(hooks);

  test('Pages all fit a11y criteria', async function (assert) {
    await visit('/');

    const pages: { path: string }[] = [];

    const docsService = docsManager(this);
    const groups = docsService.manifest.groups;

    for (const group of groups) {
      for (const page of group.list) {
        pages.push(page);
      }
    }

    assert.ok(pages.length > 10, `There are at least a few pages`);

    for (const page of pages) {
      const path = page.path.replace('.gjs.md', '').replace('.md', '');
      const settings: object = a11yChecks[page.path] ?? {};

      await visit(path);
      await waitUntil(() => findAll('nav a').length !== 0);
      await checkA11y(assert, path, 'default', settings);

      assert
        .dom('[data-page-error]')
        .doesNotExist(`${page.path}: does not contain [data-page-error]`);

      colorScheme.update('dark');
      await checkA11y(assert, path, 'dark', settings);

      colorScheme.update('light');
      await checkA11y(assert, path, 'light', settings);
    }
  });
});
