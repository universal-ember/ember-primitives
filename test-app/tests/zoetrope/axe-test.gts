import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Zoetrope } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Zoetrope> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations', async function (assert) {
    await render(
      <template>
        <Zoetrope aria-label="Cards">
          <:content>
            <a href="#a">One</a>
            <a href="#b">Two</a>
          </:content>
        </Zoetrope>
      </template>
    );

    await audit(assert);
  });
});
