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
 * Pages where the a11y audit is too expensive to run in CI.
 *
 * IncrementalEach is here because its demo renders 20k <li> elements
 * to show off incremental rendering pacing; axe-core walking that
 * DOM three times per page (default/dark/light) takes long enough on
 * the CI runner that testem treats the browser as dead. The
 * component itself has its own rendering tests in `test-app`; this
 * page is the demo, not the API surface.
 */
const a11ySkipped = new Set<string>(['/6-utils/incremental-each.gjs.md']);

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
    // The IncrementalEach docs page renders 20k rows, and axe-core
    // walks them three times per page (default/dark/light theme).
    // QUnit's default 60s testTimeout isn't enough headroom on CI;
    // bump the per-test budget to ten minutes.
    assert.timeout(600_000);

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
      const skipAudit = a11ySkipped.has(page.path);

      await visit(path);
      await waitUntil(() => findAll('nav a').length !== 0);

      if (skipAudit) {
        assert.ok(true, `a11y audit skipped for ${path} (see a11ySkipped)`);
      } else {
        await checkA11y(assert, path, 'default', settings);
      }

      assert
        .dom('[data-page-error]')
        .doesNotExist(`${page.path}: does not contain [data-page-error]`);

      if (skipAudit) continue;

      colorScheme.update('dark');
      await checkA11y(assert, path, 'dark', settings);

      colorScheme.update('light');
      await checkA11y(assert, path, 'light', settings);
    }
  });
});
