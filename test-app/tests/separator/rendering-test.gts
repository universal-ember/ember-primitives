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

  test('it can be used standalone outside of Breadcrumb', async function (assert) {
    await render(
      <template>
        <nav>
          <ul>
            <li>Item 1</li>
            <Separator>|</Separator>
            <li>Item 2</li>
          </ul>
        </nav>
      </template>
    );

    assert.dom('span[aria-hidden="true"]').hasText('|');
  });
});
