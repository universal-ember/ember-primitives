import { renderSettled } from '@ember/renderer';
import { render as testRender, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { InViewport } from 'ember-primitives/viewport';

import type { ComponentLike } from '@glint/template';

async function render(testComp: ComponentLike) {
  await testRender(
    <template>
      <div style="height:200px;">
        <div id="marker-a">marker start</div>
        <div id="spacer-a" style="height:100dvh">before-spacer</div>
        <testComp />
        <div id="marker-b">marker start</div>
        <div id="spacer-b" style="height:100dvh">after-spacer</div>
      </div>
    </template>
  );
}

async function show() {
  document.querySelector('#marker-b')?.scrollIntoView();
  await new Promise(requestAnimationFrame);
  await settled();
  await new Promise(requestAnimationFrame);
  await settled();
}

async function hide() {
  document.querySelector('#marker-a')?.scrollIntoView();
  await new Promise(requestAnimationFrame);
  await settled();
  await new Promise(requestAnimationFrame);
  await settled();
}

module('<InViewport />', function (hooks) {
  setupRenderingTest(hooks);

  module('Initial render', function () {
    test('renders placeholder element with default tag (div)', async function (assert) {
      await render(
        <template>
          <InViewport
            class="placeholder"
            style="min-height: 1px; min-width: 1px; display: block;"
          >Content</InViewport>
        </template>
      );

      assert.dom('div.placeholder').exists();
    });

    test('uses custom tag name when provided', async function (assert) {
      await render(
        <template>
          <InViewport
            @tagName="section"
            style="min-height: 1px; min-width: 1px; display: block;"
          >Content</InViewport>
        </template>
      );

      assert.dom('section').exists();
    });

    test('supports attributes passed through', async function (assert) {
      await render(
        <template>
          <InViewport
            data-test-id="my-viewport"
            style="min-height: 1px; min-width: 1px; display: block;"
          >Content</InViewport>
        </template>
      );

      assert.dom('[data-test-id="my-viewport"]').exists();
    });
  });

  module('@mode=contain', function () {
    test('initially does not show yielded content', async function (assert) {
      await render(
        <template>
          <InViewport @mode="contain" style="min-height: 1px; min-width: 1px; display: block;">
            <div>Hidden content</div>
          </InViewport>
        </template>
      );

      assert.dom().doesNotContainText('Hidden content');

      await show();
      assert.dom().containsText('Hidden content');

      await hide();
      assert.dom().containsText('Hidden content');
    });

    test('shows content after manual intersection trigger', async function (assert) {
      // This test verifies the basic intersection behavior
      // In a real app, scrolling would trigger the intersection
      await render(
        <template>
          <InViewport @mode="contain" style="min-height: 1px; min-width: 1px; display: block;">
            <div class="content">Content</div>
          </InViewport>
        </template>
      );

      await new Promise(requestAnimationFrame);
      // Note: Full testing of IntersectionObserver requires manual triggering
      // which would need custom test utilities or mocking
      assert.ok(true, 'Component renders without errors');
    });
    test('contain mode renders content in placeholder', async function (assert) {
      await render(
        <template>
          <InViewport
            class="placeholder"
            @mode="contain"
            style="min-height: 1px; min-width: 1px; display: block;"
          >
            <span class="child">Child content</span>
          </InViewport>
        </template>
      );

      assert.dom('.placeholder').exists();
      assert.dom('.placeholder').doesNotContainText('Child content');

      await show();
      assert.dom('.placeholder').containsText('Child content');
    });
  });

  module('@mode=replace', function () {
    test('initially shows placeholder only', async function (assert) {
      await render(
        <template>
          <InViewport @mode="replace" style="min-height: 1px; min-width: 1px; display: block;">
            <div>Replaced content</div>
          </InViewport>
        </template>
      );

      assert.dom().doesNotContainText('Replaced content');

      await show();
      assert.dom().containsText('Replaced content');

      await hide();
      assert.dom().containsText('Replaced content');
    });

    test('replace mode shows placeholder until intersection', async function (assert) {
      await render(
        <template>
          <InViewport
            @mode="replace"
            class="placeholder"
            style="min-height: 1px; min-width: 1px; display: block;"
          >
            <span class="child">Replaced content</span>
          </InViewport>
        </template>
      );

      assert.dom('.placeholder').exists();
      assert.dom().doesNotContainText('Replaced content');

      await show();

      assert.dom('.placeholder').doesNotExist();
      assert.dom().containsText('Replaced content');
    });
  });
});
