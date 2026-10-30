import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Tabs } from 'ember-primitives/components/tabs';

import { setupTabster } from 'ember-primitives/test-support';

import { audit } from '../axe.ts';

module('<Tabs> | axe', function (hooks) {
  setupRenderingTest(hooks);
  setupTabster(hooks);

  test('has no axe violations', async function (assert) {
    await render(
      <template>
        <Tabs @label="Fruit" as |Tab|>
          <Tab @label="Apple" @content="Red" />
          <Tab @label="Banana" @content="Yellow" />
        </Tabs>
      </template>
    );

    await audit(assert);
  });
});
