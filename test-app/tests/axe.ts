import { a11yAudit } from 'ember-a11y-testing/test-support';

/**
 * A rendering test is a fragment of a page.
 *
 * These rules are about whole pages, which the docs-app audits.
 */
const axeOptions = {
  rules: {
    'landmark-one-main': { enabled: false },
    'page-has-heading-one': { enabled: false },
    region: { enabled: false },
  },
};

export async function audit(assert: Assert) {
  await a11yAudit('#ember-testing', axeOptions);

  assert.ok(true, 'axe found no violations');
}
