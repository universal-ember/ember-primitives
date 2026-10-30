import { on } from '@ember/modifier';
import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Modal } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Modal> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations when open', async function (assert) {
    await render(
      <template>
        <Modal as |m|>
          <button type="button" {{on "click" m.open}}>Open</button>
          <m.Dialog aria-label="Settings">Content</m.Dialog>
        </Modal>
      </template>
    );

    await click('button');
    await audit(assert);
  });
});
