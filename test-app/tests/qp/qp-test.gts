import Controller from '@ember/controller';
import { visit } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { qp } from 'ember-primitives/qp';
import Route from 'ember-route-template';

module('qp', function (hooks) {
  setupApplicationTest(hooks);

  test('it wokrs', async function (assert) {
    this.owner.register(
      'template:application',
      Route(
        <template>
          <output>{{qp "foo"}}</output>
        </template>
      )
    );
    this.owner.register(
      'controller:application',
      class extends Controller {
        queryParams = ['foo'];
      }
    );

    await visit('/');
    assert.dom('output').hasText('');

    await visit('/?foo=bar');
    assert.dom('output').hasText('bar');

    await visit('/?foo=hello');
    assert.dom('output').hasText('hello');

    await visit('/');
    assert.dom('output').hasText('');
  });
});
