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

  module('@activationMode: automatic', function () {
    test('keyboard focus selects the tab', async () => {});
    test('clicking selects the tab', async () => {});
  });

  module('@activationMode: manual', function () {
    test('keyboard focus does not select the tab', async () => {});
    test('clicking selects the tab', async () => {});
  });

  module('@activeTab', () => {
    test('with no value, the selected tab is the first tab', async (assert) => {});
    test('initial tab can be non-first', async (assert) => {});
    test('with invalid value, the first tab is selected', async (assert) => {});
  });

  module('@onChange', () => {
    test('when first called, there is no previous', () => {});
  });

  module('@label', () => {
    test('string', async (assert) => {
      await render(<template><Tabs @label="the label" /></template>);

      assert.dom().containsText('the label');
    });

    test('component', async (assert) => {
      const CustomLabel = <template>my custom label</template>;

      await render(<template><Tabs @label={{CustomLabel}} /></template>);

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

    test('@value', async (assert) => {
      const record = (x: string, y: string | null) => assert.step(`change: ${x}, ${y}`);

      await render(
        <template>
          <Tabs @onChange={{record}} as |Tab|>
            <Tab @value="a" @label="Banana" />
            <Tab @value="b" @label="Apple" />
            <Tab @value="c" @label="Orange" />
          </Tabs>
        </template>
      );

      assert.verifySteps([]);

      // Selects non-first
      await click(screen.getByText('Apple'));
      assert.verifySteps(['change: b, null']);

      // Re-selects first
      await click(screen.getByText('Banana'));
      assert.verifySteps(['change: a, b']);
    });

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

    test('explicit Label and Content components', async (assert) => {
      await render(
        <template>
          <Tabs as |Tab|>
            <Tab as |Label Content|>
              <Label>Banana</Label>
              <Content>something about bananas</Content>
            </Tab>
            <Tab as |Label Content|>
              <Label>Apple</Label>
              <Content>something about apples</Content>
            </Tab>
            <Tab as |Label Content|>
              <Label>Orange</Label>
              <Content>something about oranges</Content>
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
