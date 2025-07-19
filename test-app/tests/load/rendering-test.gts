import { module, test } from 'qunit';
import { render, getRootElement } from '@ember/test-helpers';
import { setupRenderingTest } from 'ember-qunit';

import { load } from 'ember-primitives/load';

module('Rendering | load', async function (hooks) {
  setupRenderingTest(hooks);

  test('it works with no promise', async function (assert) {
    const Loader = load(() => <template>hi</template>);
    const step = (msg: string) => assert.step(msg);

    await render(
      <template>
        <Loader>
          <:loading>
            {{step "loading"}}
          </:loading>
          <:error as |reason|>
            {{step "error"}}
          </:error>
          <:success as |component|>
            {{step "success"}}
            <component />
          </:success>
        </Loader>
      </template>
    );

    assert.verifySteps(['success']);
    assert.dom().hasText('hi');
    assert.strictEqual(getRootElement().innerHTML.trim(), 'hi', 'there are no elements');
  });

  test('it works with a promise', async function (assert) {
    const Hi = <template>hi</template>;
    const Loader = load(() => Promise.resolve(Hi));
    const step = (msg: string) => assert.step(msg);

    await render(
      <template>
        <Loader>
          <:loading>
            {{step "loading"}}
          </:loading>
          <:error as |reason|>
            {{step "error"}}
          </:error>
          <:success as |component|>
            {{step "success"}}
            <component />
          </:success>
        </Loader>
      </template>
    );

    assert.verifySteps(['success']);
    assert.dom().hasText('hi');
    assert.strictEqual(getRootElement().innerHTML.trim(), 'hi', 'there are no elements');
  });
});
