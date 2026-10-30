import { tracked } from '@glimmer/tracking';
import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { CommandPalette } from 'ember-primitives';

module('Rendering | <CommandPalette> results status', function (hooks) {
  setupRenderingTest(hooks);

  test('the status follows the number of results', async function (assert) {
    class State {
      @tracked items = ['One', 'Two'];
    }

    const state = new State();

    await render(<template><CommandPalette @items={{state.items}} /></template>);

    assert.dom('[role="status"]').hasText('2 results');

    state.items = ['One'];
    await settled();
    assert.dom('[role="status"]').hasText('1 result');

    state.items = [];
    await settled();
    assert.dom('[role="status"]').hasText('0 results');
  });

  test('@resultsText replaces the wording', async function (assert) {
    const items = ['One', 'Two'];
    const resultsText = (count: number) => `${count} résultats`;

    await render(
      <template><CommandPalette @items={{items}} @resultsText={{resultsText}} /></template>
    );

    assert.dom('[role="status"]').hasText('2 résultats');
  });
});
