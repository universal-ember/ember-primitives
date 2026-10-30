import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Breadcrumb } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Breadcrumb> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li><a href="/">Home</a></li>
          <b.Separator>/</b.Separator>
          <li aria-current="page">Here</li>
        </Breadcrumb>
      </template>
    );

    await audit(assert);
  });
});
