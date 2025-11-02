import { click, find, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { screen } from '@testing-library/dom';
import { Tabs } from 'ember-primitives/components/tabs';

module('Rendering | <Tabs>', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders correctly (basic args-only)', async function (assert) {
    await render(
      <template>
        <Tabs @label="the label" as |Tab|>
          <Tab @label="Banana" @content="something about bananas" />
          <Tab @label="Apple" @content="something about apples" />
          <Tab @label="Orange" @content="something about oranges" />
        </Tabs>
      </template>
    );

    assert.dom().containsText('the label');
    assert.dom().containsText('Banana');
    assert.dom().containsText('Apple');
    assert.dom().containsText('Orange');
    assert.dom().containsText('something about bananas');
    assert.dom().doesNotContainText('something about apples');
    assert.dom().doesNotContainText('something about oranges');
  });

  module('@activationMode: automatic', function () {});
  module('@activationMode: manual', function () {});

  module('@label', function () {
    test('string', async function (assert) {
      await render(<template><Tabs @label="the label" as |Tab| /></template>);

      assert.dom().containsText('the label');
    });

    test('component', async function (assert) {
      const CustomLabel = <template>my custom label</template>;

      await render(<template><Tabs @label={{CustomLabel}} as |Tab| /></template>);

      assert.dom().containsText('my custom label');
    });
  });

  module('Tab.Label', () => {
    test('block content', async (assert) => {
      await render(
        <template>
          <Tabs as |Tab|>
            <Tab.Label>it worked</Tab.Label>
          </Tabs>
        </template>
      );

      assert.dom().containsText('it worked');
    });

    test('block content takes precedence over the @label', async (assert) => {
      await render(
        <template>
          <Tabs @label="nope" as |Tab|>
            <Tab.Label>it worked</Tab.Label>
          </Tabs>
        </template>
      );

      assert.dom().containsText('it worked');
      assert.dom().doesNotContainText('nope');
    });
  });

  module('Tab', () => {
    for (const scenario of [
      { name: 'string', value: 'Banana' },
      { name: 'component', value: <template>Banana</template> },
    ]) {
      test(`@label: ${scenario.name}`, async (assert) => {
        await render(
          <template>
            <Tabs as |Tab|>
              <Tab @label={{scenario.value}} @content="something about bananas" />
              <Tab @label="Apple" @content="something about apples" />
              <Tab @label="Orange" @content="something about oranges" />
            </Tabs>
          </template>
        );

        assert.dom('[aria-selected="true"]').exists({ count: 1 });
        assert.dom('[aria-selected="true"]').hasText('Banana');
        assert.dom('[role="tabpanel"]').exists({ count: 1 });
        assert.dom().containsText('something about bananas');
        assert.dom().doesNotContainText('something about apples');
        assert.dom().doesNotContainText('something about oranges');

        // Selects non-first
        await click(screen.getByText('Apple'));
        assert.dom('[aria-selected="true"]').exists({ count: 1 });
        assert.dom('[aria-selected="true"]').hasText('Apple');
        assert.dom('[role="tabpanel"]').exists({ count: 1 });
        assert.dom().doesNotContainText('something about bananas');
        assert.dom().containsText('something about apples');
        assert.dom().doesNotContainText('something about oranges');

        // Re-selects first
        await click(screen.getByText('Banana'));
        assert.dom('[aria-selected="true"]').exists({ count: 1 });
        assert.dom('[aria-selected="true"]').hasText('Banana');
        assert.dom('[role="tabpanel"]').exists({ count: 1 });
        assert.dom().containsText('something about bananas');
        assert.dom().doesNotContainText('something about apples');
        assert.dom().doesNotContainText('something about oranges');
      });

      test(`@content: ${scenario.name}`, async (assert) => {
        await render(
          <template>
            <Tabs as |Tab|>
              <Tab @label="Banana" @content={{scenario.value}} />
              <Tab @label="Apple" @content="something about apples" />
              <Tab @label="Orange" @content="something about oranges" />
            </Tabs>
          </template>
        );

        assert.dom('[aria-selected="true"]').exists({ count: 1 });
        assert.dom('[aria-selected="true"]').hasText('Banana');
        assert.dom('[role="tabpanel"]').exists({ count: 1 });
        assert.dom('[role="tabpanel"]').containsText('Banana');
        assert.dom('[role="tabpanel"]').doesNotContainText('something about apples');
        assert.dom('[role="tabpanel"]').doesNotContainText('something about oranges');

        // Selects non-first
        await click(screen.getByText('Apple'));
        assert.dom('[aria-selected="true"]').exists({ count: 1 });
        assert.dom('[aria-selected="true"]').hasText('Apple');
        assert.dom('[role="tabpanel"]').exists({ count: 1 });
        assert.dom('[role="tabpanel"]').doesNotContainText('Banana');
        assert.dom('[role="tabpanel"]').containsText('something about apples');
        assert.dom('[role="tabpanel"]').doesNotContainText('something about oranges');

        // Re-selects first
        await click(screen.getByText('Banana'));
        assert.dom('[aria-selected="true"]').exists({ count: 1 });
        assert.dom('[aria-selected="true"]').hasText('Banana');
        assert.dom('[role="tabpanel"]').exists({ count: 1 });
        assert.dom('[role="tabpanel"]').containsText('Banana');
        assert.dom('[role="tabpanel"]').doesNotContainText('something about apples');
        assert.dom('[role="tabpanel"]').doesNotContainText('something about oranges');
      });
    }

    test('default block', async (assert) => {
      await render(
        <template>
          <Tabs as |Tab|>
            <Tab @label="Banana">
              something about bananas
            </Tab>
            <Tab @label="Apple">
              something about apples
            </Tab>
            <Tab @label="Orange">
              something about oranges
            </Tab>
          </Tabs>
        </template>
      );

      assert.dom('[aria-selected="true"]').exists({ count: 1 });
      assert.dom('[aria-selected="true"]').hasText('Banana');
      assert.dom('[role="tabpanel"]').exists({ count: 1 });
      assert.dom('[role="tabpanel"]').containsText('something about bananas');
      assert.dom('[role="tabpanel"]').doesNotContainText('something about apples');
      assert.dom('[role="tabpanel"]').doesNotContainText('something about oranges');

      // Selects non-first
      await click(screen.getByText('Apple'));
      assert.dom('[aria-selected="true"]').exists({ count: 1 });
      assert.dom('[aria-selected="true"]').hasText('Apple');
      assert.dom('[role="tabpanel"]').exists({ count: 1 });
      assert.dom('[role="tabpanel"]').doesNotContainText('something about bananas');
      assert.dom('[role="tabpanel"]').containsText('something about apples');
      assert.dom('[role="tabpanel"]').doesNotContainText('something about oranges');

      // Re-selects first
      await click(screen.getByText('Banana'));
      assert.dom('[aria-selected="true"]').exists({ count: 1 });
      assert.dom('[aria-selected="true"]').hasText('Banana');
      assert.dom('[role="tabpanel"]').exists({ count: 1 });
      assert.dom('[role="tabpanel"]').containsText('something about bananas');
      assert.dom('[role="tabpanel"]').doesNotContainText('something about apples');
      assert.dom('[role="tabpanel"]').doesNotContainText('something about oranges');
    });
  });
});
