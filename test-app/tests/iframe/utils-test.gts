import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { inIframe, notInIframe } from 'ember-primitives/iframe';

module('Iframe', function (hooks) {
  setupRenderingTest(hooks);

  module('inIframe', function () {
    test('returns false, because tests are not in an iframe', async function (assert) {
      assert.false(inIframe());
    });

    test('works in templates', async function (assert) {
      await render(
        <template>
          {{#if (inIframe)}}
            in iframe
          {{else}}
            not in iframe
          {{/if}}
        </template>
      );

      assert.dom().hasText('not in iframe');
    });
  });

  module('notInIframe', function () {
    test('returns true, because tests are not in an iframe', async function (assert) {
      assert.true(notInIframe());
    });

    test('works in templates', async function (assert) {
      await render(
        <template>
          {{#if (notInIframe)}}
            not in iframe
          {{else}}
            in iframe
          {{/if}}
        </template>
      );

      assert.dom().hasText('not in iframe');
    });
  });
});
