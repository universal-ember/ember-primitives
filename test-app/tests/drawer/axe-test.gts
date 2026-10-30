import { on } from '@ember/modifier';
import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Drawer } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Drawer> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations when open', async function (assert) {
    await render(
      <template>
        <Drawer as |d|>
          <button type="button" {{on "click" d.open}}>Open</button>
          <d.Drawer aria-label="Filters">Content</d.Drawer>
        </Drawer>
      </template>
    );

    await click('button');
    await audit(assert);
  });
});
