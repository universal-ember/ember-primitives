import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { ToggleGroup } from 'ember-primitives';

module('Rendering | <ToggleGroup>', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    const handleChange = (value: unknown) => assert.step(`Change:${value}`);

    await render(
      <template>
        <ToggleGroup @onChange={{handleChange}} as |x|>
          <x.Item @value="a">a</x.Item>
          <x.Item @value="b">b</x.Item>
          <x.Item @value="c">c</x.Item>
        </ToggleGroup>
      </template>
    );

    assert.dom('[aria-pressed=true]').doesNotExist();

    await click('button:nth-child(1)');

    assert.dom('[aria-pressed=true]').exists({ count: 1 });
    assert.dom('[aria-pressed=true]').hasText('a');

    await click('button:nth-child(1)');
    assert.dom('[aria-pressed=true]').doesNotExist();

    await click('button:nth-child(3)');
    assert.dom('[aria-pressed=true]').exists({ count: 1 });
    assert.dom('[aria-pressed=true]').hasText('c');

    assert.verifySteps(['Change:a', 'Change:c']);
  });

  test('it has a starting value', async function (assert) {
    const handleChange = (value: unknown) => assert.step(`Change:${value}`);

    await render(
      <template>
        <ToggleGroup @value="b" @onChange={{handleChange}} as |x|>
          <x.Item @value="a">a</x.Item>
          <x.Item @value="b">b</x.Item>
          <x.Item @value="c">c</x.Item>
        </ToggleGroup>
      </template>
    );

    assert.dom('[aria-pressed=true]').hasText('b');

    await click('button:nth-child(1)');

    assert.dom('[aria-pressed=true]').exists({ count: 1 });
    assert.dom('[aria-pressed=true]').hasText('a');

    assert.verifySteps(['Change:a']);
  });
});
