import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { ToggleGroup } from 'ember-primitives';

module('Rendering | <ToggleGroup>', function (hooks) {
  setupRenderingTest(hooks);

  module('type=single (default)', function () {
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
  module('type=multi', function () {
    test('it works', async function (assert) {
      const handleChange = (value: Set<unknown>) =>
        assert.step(`size:${value.size}:${[...value.values()].join(',')}`);

      await render(
        <template>
          <ToggleGroup @type="multi" @onChange={{handleChange}} as |x|>
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

      assert.verifySteps(['size:1:a', 'size:0:', 'size:1:c']);

      await click('button:nth-child(2)');
      assert.verifySteps(['size:2:c,b']);
    });
  });
});
