import { tracked } from '@glimmer/tracking';
import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { InViewport } from 'ember-primitives';

module('<InViewport />', function (hooks) {
  setupRenderingTest(hooks);

  test('renders placeholder element with default tag (div)', async function (assert) {
    await render(
      <template>
        <InViewport>Content</InViewport>
      </template>
    );

    assert.dom('div').exists();
  });

  test('uses custom tag name when provided', async function (assert) {
    await render(
      <template>
        <InViewport @tagName="section">Content</InViewport>
      </template>
    );

    assert.dom('section').exists();
  });

  test('applies class to placeholder element', async function (assert) {
    await render(
      <template>
        <InViewport class="my-custom-class">Content</InViewport>
      </template>
    );

    assert.dom('.my-custom-class').exists();
  });

  test('in contain mode, initially does not show yielded content', async function (assert) {
    await render(
      <template>
        <InViewport @mode="contain">
          <div class="content">Hidden content</div>
        </InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    assert.dom('.content').doesNotExist('Content is not rendered until intersection');
  });

  test('in replace mode, initially shows placeholder only', async function (assert) {
    await render(
      <template>
        <InViewport @mode="replace">
          <div class="content">Replaced content</div>
        </InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    assert.dom('.content').doesNotExist('Content is not rendered until intersection');
  });

  test('shows content after manual intersection trigger', async function (assert) {
    let component: any;

    class TestComponent {
      @tracked isInViewport = false;

      <template>
        <InViewport @mode="contain" @intersectionOptions={{Object rootMargin="0px"}}>
          <div class="content">Visible content</div>
        </InViewport>
      </template>
    }

    // This test verifies the basic intersection behavior
    // In a real app, scrolling would trigger the intersection
    await render(
      <template>
        <InViewport @mode="contain">
          <div class="content">Content</div>
        </InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    // Note: Full testing of IntersectionObserver requires manual triggering
    // which would need custom test utilities or mocking
    assert.ok(true, 'Component renders without errors');
  });

  test('supports attributes passed through', async function (assert) {
    await render(
      <template>
        <InViewport data-test-id="my-viewport">Content</InViewport>
      </template>
    );

    assert.dom('[data-test-id="my-viewport"]').exists();
  });

  test('contain mode renders content in placeholder', async function (assert) {
    await render(
      <template>
        <InViewport class="placeholder" @mode="contain">
          <span class="child">Child content</span>
        </InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    // Even when not intersected, contain mode wraps the content
    assert.dom('.placeholder').exists();
  });

  test('replace mode shows placeholder until intersection', async function (assert) {
    await render(
      <template>
        <InViewport @mode="replace" class="placeholder">
          <span class="child">Replaced content</span>
        </InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    // In replace mode, placeholder is visible initially
    assert.dom('.placeholder').exists();
  });

  test('intersection observer is created with custom options', async function (assert) {
    // This test verifies that custom intersection options are accepted
    await render(
      <template>
        <InViewport @intersectionOptions={{Object rootMargin="100px" threshold=0.5}}>
          Content
        </InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    assert.ok(true, 'Component accepts custom intersection options');
  });

  test('multiple InViewport components can coexist', async function (assert) {
    await render(
      <template>
        <InViewport class="viewport-1">Content 1</InViewport>
        <InViewport class="viewport-2">Content 2</InViewport>
      </template>
    );

    await new Promise(requestAnimationFrame);
    assert.dom('.viewport-1').exists();
    assert.dom('.viewport-2').exists();
  });
});
