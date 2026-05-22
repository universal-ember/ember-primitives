import { tracked } from '@glimmer/tracking';
import { findAll, render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { IncrementalEach } from 'ember-primitives';

module('Rendering | IncrementalEach', function (hooks) {
  setupRenderingTest(hooks);

  test('renders the first batch on initial paint and the rest after settle', async function (assert) {
    const items = Array.from({ length: 25 }, (_, i) => `item-${i}`);

    await render(
      <template>
        <ul>
          <IncrementalEach @items={{items}} @batchSize={{10}} as |item|>
            <li class="row">{{item}}</li>
          </IncrementalEach>
        </ul>
      </template>
    );

    // After settle, every batch should be flushed
    assert.strictEqual(findAll('.row').length, 25, 'all items rendered after settle');
  });

  test('default batch size is 50', async function (assert) {
    const items = Array.from({ length: 60 }, (_, i) => i);

    await render(
      <template>
        <IncrementalEach @items={{items}} as |item|>
          <span class="row">{{item}}</span>
        </IncrementalEach>
      </template>
    );

    assert.strictEqual(findAll('.row').length, 60, 'renders all items by the time we settle');
  });

  test('yields item and index', async function (assert) {
    const items = ['a', 'b', 'c'];

    await render(
      <template>
        <IncrementalEach @items={{items}} @batchSize={{10}} as |item index|>
          <span class="row" data-index={{index}}>{{item}}</span>
        </IncrementalEach>
      </template>
    );

    const rows = findAll('.row');

    assert.strictEqual(rows.length, 3);
    assert.strictEqual(rows[0]?.textContent, 'a');
    assert.strictEqual(rows[0]?.getAttribute('data-index'), '0');
    assert.strictEqual(rows[2]?.textContent, 'c');
    assert.strictEqual(rows[2]?.getAttribute('data-index'), '2');
  });

  test('an empty collection renders nothing', async function (assert) {
    const items: string[] = [];

    await render(
      <template>
        <IncrementalEach @items={{items}} as |item|>
          <span class="row">{{item}}</span>
        </IncrementalEach>
      </template>
    );

    assert.strictEqual(findAll('.row').length, 0);
  });

  test('replacing @items restarts rendering and onDone fires for the new collection', async function (assert) {
    class State {
      @tracked items: string[] = Array.from({ length: 3 }, (_, i) => `a-${i}`);
    }

    const state = new State();
    const onDone = () => assert.step('onDone');

    await render(
      <template>
        <IncrementalEach @items={{state.items}} @batchSize={{5}} @onDone={{onDone}} as |item|>
          <span class="row">{{item}}</span>
        </IncrementalEach>
      </template>
    );

    assert.strictEqual(findAll('.row').length, 3, 'initial collection rendered');

    state.items = Array.from({ length: 7 }, (_, i) => `b-${i}`);
    await settled();

    assert.strictEqual(findAll('.row').length, 7, 'new collection rendered');
    assert.verifySteps(['onDone', 'onDone'], 'onDone fired once per fully rendered collection');
  });

  test('onDone is called once per collection that fully renders', async function (assert) {
    const items = Array.from({ length: 4 }, (_, i) => i);
    const onDone = () => assert.step('onDone');

    await render(
      <template>
        <IncrementalEach @items={{items}} @batchSize={{2}} @onDone={{onDone}} as |item|>
          <span class="row">{{item}}</span>
        </IncrementalEach>
      </template>
    );

    assert.strictEqual(findAll('.row').length, 4);
    assert.verifySteps(['onDone']);
  });
});
