import { tracked } from '@glimmer/tracking';
import { renderSettled } from '@ember/renderer';
import { findAll, render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { IncrementalEach } from 'ember-primitives';

module('Rendering | IncrementalEach', function (hooks) {
  setupRenderingTest(hooks);

  test('renders every item across batches by the time we settle', async function (assert) {
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

  test('replacing @items restarts rendering with the new collection', async function (assert) {
    class State {
      @tracked items: string[] = Array.from({ length: 3 }, (_, i) => `a-${i}`);
    }

    const state = new State();

    await render(
      <template>
        <IncrementalEach @items={{state.items}} @batchSize={{5}} as |item|>
          <span class="row">{{item}}</span>
        </IncrementalEach>
      </template>
    );

    assert.strictEqual(findAll('.row').length, 3, 'initial collection rendered');

    state.items = Array.from({ length: 7 }, (_, i) => `b-${i}`);
    await settled();

    assert.strictEqual(findAll('.row').length, 7, 'new collection rendered');
    assert.dom('.row').hasText('b-0', 'first row belongs to the new collection');
  });

  test('changing tracked state on one item only re-renders that item', async function (assert) {
    class Row {
      @tracked label: string;
      constructor(label: string) {
        this.label = label;
      }
    }

    const a = new Row('A');
    const b = new Row('B');
    const c = new Row('C');
    const items = [a, b, c];
    const trace = (label: string) => assert.step(`render:${label}`);

    await render(
      <template>
        <IncrementalEach @items={{items}} @batchSize={{10}} as |row|>
          {{trace row.label}}
          <span class="row">{{row.label}}</span>
        </IncrementalEach>
      </template>
    );

    assert.verifySteps(
      ['render:A', 'render:B', 'render:C'],
      'each yield runs once on initial render'
    );

    b.label = 'B-mutated';
    await settled();

    assert.verifySteps(['render:B-mutated'], 'only the mutated yield re-runs');
    assert.dom('.row:nth-of-type(2)').hasText('B-mutated');
  });

  test('quickly replacing @items between renders ends up on the final collection', async function (assert) {
    class State {
      @tracked items: string[] = ['a-0', 'a-1', 'a-2', 'a-3', 'a-4'];
    }

    const state = new State();

    await render(
      <template>
        <IncrementalEach @items={{state.items}} @batchSize={{2}} as |item|>
          <span class="row">{{item}}</span>
        </IncrementalEach>
      </template>
    );

    // Swap to a second collection, let exactly one render flush, then
    // swap again without giving the idle queue a chance to drain. Any
    // stale idle callback from `a-*` or `b-*` that survives the swap
    // would push wrong items into `c-*` once settled.
    state.items = ['b-0', 'b-1', 'b-2'];
    await renderSettled();
    state.items = ['c-0', 'c-1', 'c-2', 'c-3'];
    await settled();

    const labels = findAll('.row').map((el) => el.textContent);

    assert.deepEqual(labels, ['c-0', 'c-1', 'c-2', 'c-3'], 'only the final collection renders');
  });
});
