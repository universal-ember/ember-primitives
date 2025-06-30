import Controller from '@ember/controller';
import { find, visit } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

import { withQP } from 'ember-primitives/qp';
import Route from 'ember-route-template';

module('withQP', function (hooks) {
  setupApplicationTest(hooks);

  test('it wokrs', async function (assert) {
    this.owner.register(
      'template:application',
      Route(
        <template>
          <a href={{withQP "foo" 2}}>link</a>
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

    const url = new URL(find('a').getAttribute('href'));

    assert.strictEqual(url.search, '?foo=2');
  });
});
