import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Zoetrope } from 'ember-primitives';

module('<Zoetrope />', function (hooks) {
  setupRenderingTest(hooks);

  test('basic usage renders', async function (assert) {
    await render(
      <template>
        <Zoetrope>
          <:content>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    assert.dom('.zoetrope').exists();
    assert.dom('.zoetrope a').exists();
  });

  test('gap is applied to cards', async function (assert) {
    await render(
      <template>
        <Zoetrope @gap={{10}}>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    assert.dom('.zoetrope-scroller').hasStyle({ gap: '10px' });
  });

  test('offset is applied to cards', async function (assert) {
    await render(
      <template>
        <Zoetrope @offset={{40}}>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    assert
      .dom('.zoetrope-scroller')
      .hasStyle({ paddingLeft: '40px' })
      .hasStyle({ paddingRight: '40px' });
  });

  test('header is visible if provided', async function (assert) {
    await render(
      <template>
        <Zoetrope @offset={{40}}>
          <:header>
            <h1>Header</h1>
          </:header>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    assert.dom('.zoetrope-header').hasText('Header');
  });

  test('no controls visible if no need to scroll', async function (assert) {
    await render(
      <template>
        <Zoetrope @offset={{40}}>
          <:header>
            <h1>Header</h1>
          </:header>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    await Promise.resolve();

    assert.dom('.zoetrope-controls').doesNotExist();
  });

  test('controls visible if scrolling required', async function (assert) {
    await render(
      <template>
        <Zoetrope @offset={{40}}>
          <:header>
            <h1>Header</h1>
          </:header>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>

        {{! template-lint-disable no-forbidden-elements}}
        <style>
          a {width: 100%; display: block;}
        </style>
      </template>
    );

    assert.dom('.zoetrope-controls').exists();
  });

  test('can scroll right', async function (assert) {
    await render(
      <template>
        {{! template-lint-disable no-forbidden-elements}}
        <style>
          .zoetrope {width: 400px;} a {width: 200px; display: block;}
        </style>

        <Zoetrope>
          <:header>
            <h1>Header</h1>
          </:header>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    await click('.zoetrope-controls button:last-child');

    assert.dom('.zoetrope-scroller').hasProperty('scrollLeft', 208);
  });

  test('can scroll left', async function (assert) {
    await render(
      <template>
        {{! template-lint-disable no-forbidden-elements}}
        <style>
          .zoetrope {width: 400px;} a {width: 200px; display: block;}
        </style>

        <Zoetrope>
          <:header>
            <h1>Header</h1>
          </:header>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    // scroll right first so we can scroll left
    await click('.zoetrope-controls button:last-child');
    // now scroll left
    await click('.zoetrope-controls button:first-child');

    assert.dom('.zoetrope-scroller').hasProperty('scrollLeft', 0);
  });

  test('can provide own controls', async function (assert) {
    await render(
      <template>
        <Zoetrope>
          <:controls>
            <div class="my-controls">
              <button type="button">Left</button>
              <button type="button">Right</button>
            </div>
          </:controls>
          <:content>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    assert.dom('.my-controls').exists();
  });
});
