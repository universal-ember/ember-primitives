import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Separator } from 'ember-primitives';

module('<Separator />', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders a semantic separator by default', async function (assert) {
    await render(<template><Separator /></template>);

    assert.dom('hr').exists();
    assert.dom('hr').doesNotHaveAttribute('aria-hidden');
    assert.dom('hr').doesNotHaveAttribute('role');
  });

  test('decorative separators render content and are aria-hidden', async function (assert) {
    await render(
      <template>
        <Separator @as="span" @decorative={{true}}>/</Separator>
      </template>
    );

    assert.dom('span').exists();
    assert.dom('span').hasAttribute('aria-hidden', 'true');
    assert.dom('span').doesNotHaveAttribute('role');
    assert.dom('span').hasText('/');
  });

  test('it accepts custom attributes', async function (assert) {
    await render(
      <template>
        <Separator @as="span" @decorative={{true}} class="separator-class" data-test-separator>
          →
        </Separator>
      </template>
    );

    assert.dom('span[aria-hidden="true"]').hasClass('separator-class');
    assert.dom('span[aria-hidden="true"]').hasAttribute('data-test-separator');
    assert.dom('span[aria-hidden="true"]').hasText('→');
  });

  test('it can use @as to change element tag', async function (assert) {
    await render(
      <template>
        <Separator @as="li" @decorative={{true}}>/</Separator>
      </template>
    );

    assert.dom('li').exists();
    assert.dom('li').hasAttribute('aria-hidden', 'true');
    assert.dom('li').doesNotHaveAttribute('role');
    assert.dom('li').hasText('/');
  });

  test('it can be used in lists with @as="li"', async function (assert) {
    await render(
      <template>
        <nav>
          <ol>
            <li>Item 1</li>
            <Separator @as="li" @decorative={{true}}>|</Separator>
            <li>Item 2</li>
          </ol>
        </nav>
      </template>
    );

    assert.dom('li[aria-hidden="true"]').hasText('|');
    assert.dom('li').exists({ count: 3 });
  });

  test('non-hr elements get role="separator"', async function (assert) {
    await render(<template><Separator @as="div" /></template>);

    assert.dom('div').exists();
    assert.dom('div').hasAttribute('role', 'separator');
    assert.dom('div').doesNotHaveAttribute('aria-hidden');
    assert.dom('div').hasNoText();
  });
});
