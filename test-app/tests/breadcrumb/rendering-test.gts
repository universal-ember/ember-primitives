import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Breadcrumb, Separator } from 'ember-primitives';

module('<Breadcrumb />', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default label', async function (assert) {
    await render(
      <template>
        <Breadcrumb>
          <li>
            <a href="/">Home</a>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('nav').exists();
    assert.dom('nav').hasAttribute('aria-label', 'Breadcrumb');
    assert.dom('ol').exists();
  });

  test('it renders with custom label', async function (assert) {
    await render(
      <template>
        <Breadcrumb @label="Site Navigation">
          <li>
            <a href="/">Home</a>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('nav').hasAttribute('aria-label', 'Site Navigation');
  });

  test('it renders items with links', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li>
            <a href="/">Home</a>
          </li>
          <b.Separator>/</b.Separator>
          <li>
            <a href="/docs">Docs</a>
          </li>
          <b.Separator>/</b.Separator>
          <li aria-current="page">
            Current Page
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('li:not([aria-hidden="true"])').exists({ count: 3 });
    assert.dom('a').exists({ count: 2 });
  });

  test('separators have aria-hidden', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <b.Separator>/</b.Separator>
        </Breadcrumb>
      </template>
    );

    assert.dom('li[aria-hidden="true"]').hasText('/');
  });

  test('yielded separators render as li elements', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li>
            <a href="/">Home</a>
          </li>
          <b.Separator>/</b.Separator>
          <li aria-current="page">
            Current
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('li[aria-hidden="true"]').hasText('/');
    assert.dom('li').exists({ count: 3 });
  });

  test('it accepts custom attributes', async function (assert) {
    await render(<template><Breadcrumb class="my-breadcrumb" data-test-breadcrumb /></template>);

    assert.dom('nav').hasClass('my-breadcrumb');
    assert.dom('nav').hasAttribute('data-test-breadcrumb');
  });

  test('separators accept custom attributes', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <b.Separator class="separator-class" data-test-separator>
            /
          </b.Separator>
        </Breadcrumb>
      </template>
    );

    assert.dom('li[aria-hidden="true"]').hasClass('separator-class');
    assert.dom('li[aria-hidden="true"]').hasAttribute('data-test-separator');
  });

  test('can use standalone Separator with Breadcrumb', async function (assert) {
    await render(
      <template>
        <Breadcrumb>
          <li>
            <a href="/">Home</a>
          </li>
          <Separator @as="li" @decorative={{true}}>/</Separator>
          <li aria-current="page">
            Current
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('li').exists({ count: 3 });
    assert.dom('li[aria-hidden="true"]').hasText('/');
  });
});
