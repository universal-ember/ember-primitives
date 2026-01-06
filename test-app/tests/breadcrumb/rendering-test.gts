import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Breadcrumb } from 'ember-primitives';

module('<Breadcrumb />', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders with default label', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
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
        <Breadcrumb @label="Site Navigation" as |b|>
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

    assert.dom('li').exists({ count: 3 });
    assert.dom('a').exists({ count: 2 });
    assert.dom('a[href="/"]').hasText('Home');
    assert.dom('a[href="/docs"]').hasText('Docs');
    assert.dom('li[aria-current="page"]').hasText('Current Page');
  });

  test('separators have aria-hidden', async function (assert) {
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
        </Breadcrumb>
      </template>
    );

    assert.dom('span[aria-hidden="true"]').exists();
    assert.dom('span[aria-hidden="true"]').hasText('/');
  });

  test('it accepts custom attributes', async function (assert) {
    await render(
      <template>
        <Breadcrumb class="my-breadcrumb" data-test-breadcrumb as |b|>
          <li>
            <a href="/">Home</a>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('nav').hasClass('my-breadcrumb');
    assert.dom('nav').hasAttribute('data-test-breadcrumb');
  });

  test('items accept custom attributes', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li class="item-class" data-test-item>
            <a href="/">Home</a>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('li').hasClass('item-class');
    assert.dom('li').hasAttribute('data-test-item');
  });

  test('links accept custom attributes', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li>
            <a href="/" class="link-class" data-test-link>Home</a>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('a').hasClass('link-class');
    assert.dom('a').hasAttribute('data-test-link');
  });

  test('separators accept custom attributes', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li>
            <a href="/">Home</a>
          </li>
          <b.Separator class="separator-class" data-test-separator>
            /
          </b.Separator>
          <li>
            <a href="/docs">Docs</a>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('span[aria-hidden="true"]').hasClass('separator-class');
    assert.dom('span[aria-hidden="true"]').hasAttribute('data-test-separator');
  });

  test('works with any link component', async function (assert) {
    await render(
      <template>
        <Breadcrumb as |b|>
          <li>
            <a href="/">Regular Link</a>
          </li>
          <b.Separator>/</b.Separator>
          <li>
            <button type="button">Button</button>
          </li>
        </Breadcrumb>
      </template>
    );

    assert.dom('a').hasText('Regular Link');
    assert.dom('button').hasText('Button');
  });
});
