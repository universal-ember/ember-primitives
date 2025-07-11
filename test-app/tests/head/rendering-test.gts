import { findAll, render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { InHead } from 'ember-primitives/head';
import { cell } from 'ember-resources';

function findInHead(selector) {
  return document.head.querySelector(selector);
}

module('Rendering | InHead', function (hooks) {
  setupRenderingTest(hooks);

  test('renders into head', async function (assert) {
    await render(
      <template>
        <InHead>
          <meta name="test-foo" />
        </InHead>
      </template>
    );

    assert.ok(findInHead('[name=test-foo]'), 'meta exists');
  });

  test('dynamic head', async function (assert) {
    const show = cell(false);

    await render(
      <template>
        {{#if show.current}}
          <InHead>
            <meta name="test-foo" />
          </InHead>
        {{/if}}
      </template>
    );

    assert.notOk(findInHead('[name=test-foo]'), 'meta does not exists');

    show.current = true;
    await settled();
    assert.ok(findInHead('[name=test-foo]'), 'meta exists');
  });
});
