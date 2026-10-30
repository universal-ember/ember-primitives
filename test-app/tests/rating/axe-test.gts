import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Rating } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Rating> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(
      <template>
        <Rating>
          <:label>Rate me</:label>
        </Rating>
      </template>
    );

    await audit(assert);
  });
});
