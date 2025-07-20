import { getRootElement, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { load } from 'ember-primitives/load';

module('Rendering | load', function (hooks) {
  setupRenderingTest(hooks);

  test('it works with no function', async function (assert) {
    const Loader = load(<template>hi</template>);
    const step = (msg: string) => assert.step(msg);

    await render(
      <template>
        <Loader>
          <:loading>
            {{step "loading"}}
          </:loading>
          <:error>
            {{step "error"}}
          </:error>
          <:success as |comp|>
            {{step "success"}}
            <comp />
          </:success>
        </Loader>
      </template>
    );

    assert.verifySteps(['success']);
    assert.dom().hasText('hi');
    // @ts-expect-error
    assert.strictEqual(getRootElement().innerHTML.trim(), 'hi', 'there are no elements');
  });

  test('it works with no promise', async function (assert) {
    const Loader = load(() => <template>hi</template>);
    const step = (msg: string) => assert.step(msg);

    await render(
      <template>
        <Loader>
          <:loading>
            {{step "loading"}}
          </:loading>
          <:error>
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
    // @ts-expect-error
    assert.strictEqual(getRootElement().innerHTML.trim(), 'hi', 'there are no elements');
  });

  test('it works with a resolved promise', async function (assert) {
    const Hi = <template>hi</template>;
    const Loader = load(() => Promise.resolve(Hi));
    const step = (msg: string) => assert.step(msg);

    await render(
      <template>
        <Loader>
          <:loading>
            {{step "loading"}}
          </:loading>
          <:error>
            {{step "error"}}
          </:error>
          <:success as |component|>
            {{step "success"}}
            <component />
          </:success>
        </Loader>
      </template>
    );

    assert.verifySteps(['loading', 'success']);
    assert.dom().hasText('hi');
    // @ts-expect-error
    assert.strictEqual(getRootElement().innerHTML.trim(), 'hi', 'there are no elements');
  });

  test('it works with a promise', async function (assert) {
    const Hi = <template>hi</template>;
    const Loader = load(async () => {
      await new Promise((resolve) => setTimeout(() => resolve(0), 100));

      return Hi;
    });

    const step = (msg: string) => assert.step(msg);

    await render(
      <template>
        <Loader>
          <:loading>
            {{step "loading"}}
          </:loading>
          <:error>
            {{step "error"}}
          </:error>
          <:success as |component|>
            {{step "success"}}
            <component />
          </:success>
        </Loader>
      </template>
    );

    assert.verifySteps(['loading', 'success']);
    assert.dom().hasText('hi');
    // @ts-expect-error
    assert.strictEqual(getRootElement().innerHTML.trim(), 'hi', 'there are no elements');
  });
});
