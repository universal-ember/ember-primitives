import { render, setupOnerror } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Portal, PORTALS, PortalTargets } from 'ember-primitives';

module('Rendering | <Portal>', function (hooks) {
  setupRenderingTest(hooks);

  test('errors without an existing portal target', async function (assert) {
    setupOnerror((error) => {
      assert.matches(error.message, /Could not find element by the given name: `does-not-exist`/);
    });

    await render(<template>
      <Portal @to='does-not-exist'>
        content
      </Portal>
    </template>);
  });

  test('renders in to a portal target', async function (assert) {
    await render(<template>
      <PortalTargets />
      <Portal @to={{PORTALS.popover}}>
        content
      </Portal>
    </template>);

    assert.dom(`[data-portal-name="${PORTALS.popover}"]`).hasText('content');
  });
});
