import { on } from '@ember/modifier';
import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Zoetrope } from 'ember-primitives';

import { ZoetropeHelper } from 'ember-primitives/test-support';

const zoetrope = new ZoetropeHelper();

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

    assert.dom('.ember-primitives__zoetrope').exists();
    assert.dom('.ember-primitives__zoetrope a').exists();
  });

  test('can count visible items', async function (assert) {
    await render(
      <template>
        {{! template-lint-disable no-forbidden-elements}}
        <style>
          .ember-primitives__zoetrope {width: 400px;} a {width: 200px; display: block;}
        </style>

        <Zoetrope>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    assert.strictEqual(zoetrope.visibleItemCount(), 2);
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

    assert.dom('.ember-primitives__zoetrope__scroller').hasStyle({ gap: '10px' });
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
      .dom('.ember-primitives__zoetrope__scroller')
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

    assert.dom('.ember-primitives__zoetrope__header').hasText('Header');
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

    assert.dom('.ember-primitives__zoetrope__controls').doesNotExist();
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

    assert.dom('.ember-primitives__zoetrope__controls').exists();
  });

  test('can scroll right', async function (assert) {
    await render(
      <template>
        {{! template-lint-disable no-forbidden-elements}}
        <style>
          .ember-primitives__zoetrope {width: 400px;} a {width: 200px; display: block;}
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

    await zoetrope.scrollRight();

    assert.dom('.ember-primitives__zoetrope__scroller').hasProperty('scrollLeft', 208);
  });

  test('can scroll left', async function (assert) {
    await render(
      <template>
        {{! template-lint-disable no-forbidden-elements}}
        <style>
          .ember-primitives__zoetrope {width: 400px;} a {width: 200px; display: block;}
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
    await zoetrope.scrollRight();
    // now scroll left
    await zoetrope.scrollLeft();

    assert.dom('.ember-primitives__zoetrope__scroller').hasProperty('scrollLeft', 0);
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

  test('can navigate with custom controls', async function (assert) {
    await render(
      <template>
        {{! template-lint-disable no-forbidden-elements}}
        <style>
          .ember-primitives__zoetrope {width: 400px;} a {width: 200px; display: block;}
        </style>

        <Zoetrope>
          <:controls as |z|>
            <div class="my-controls">
              <button type="button" {{on "click" z.scrollLeft}}>Left</button>
              <button type="button" {{on "click" z.scrollRight}}>Right</button>
            </div>
          </:controls>
          <:content>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
            <a href="#">Card</a>
          </:content>
        </Zoetrope>
      </template>
    );

    await click('.my-controls button:last-child');

    assert.dom('.ember-primitives__zoetrope__scroller').hasProperty('scrollLeft', 208);

    await click('.my-controls button:first-child');

    assert.dom('.ember-primitives__zoetrope__scroller').hasProperty('scrollLeft', 0);
  });
});
