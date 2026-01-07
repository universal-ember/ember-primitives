import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Separator } from 'ember-primitives';

module('<Separator />', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with aria-hidden', async function (assert) {
    await render(
      <template>
        <Separator>/</Separator>
      </template>
    );

    assert.dom('span').exists();
    assert.dom('span').hasAttribute('aria-hidden', 'true');
    assert.dom('span').hasText('/');
  });

  test('it accepts custom attributes', async function (assert) {
    await render(
      <template>
        <Separator class="separator-class" data-test-separator>
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
        <Separator @as="li">/</Separator>
      </template>
    );

    assert.dom('li').exists();
    assert.dom('li').hasAttribute('aria-hidden', 'true');
    assert.dom('li').hasText('/');
  });

  test('it can be used in lists with @as="li"', async function (assert) {
    await render(
      <template>
        <nav>
          <ol>
            <li>Item 1</li>
            <Separator @as="li">|</Separator>
            <li>Item 2</li>
          </ol>
        </nav>
      </template>
    );

    assert.dom('li[aria-hidden="true"]').hasText('|');
    assert.dom('li').exists({ count: 3 });
  });
});
