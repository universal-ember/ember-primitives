import { tracked } from '@glimmer/tracking';
import { find, render, resetOnerror, settled, setupOnerror } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { onResize } from 'ember-primitives/on-resize';

/**
 * Waits for a full frame boundary to pass.
 *
 * ResizeObserver notifications are delivered during frame rendering,
 * after that frame's requestAnimationFrame callbacks run (and after
 * style/layout are recalculated). So a mutation made before this call
 * is captured by the first frame's delivery step, and by the time a
 * second, consecutive requestAnimationFrame callback runs, that
 * delivery is guaranteed to have happened.
 */
async function waitForFrame() {
  await new Promise<void>((resolve) => {
    requestAnimationFrame(() => {
      requestAnimationFrame(() => resolve());
    });
  });
}

/**
 * Deterministically flushes {{onResize}} activity:
 * - settled(): any pending render (e.g. a modifier re-run) completes,
 *   so observations are installed before we count frames
 * - waitForFrame(): the ResizeObserver delivery for anything mutated
 *   so far has happened
 * - settled(): anything the callback scheduled has flushed
 *
 * This is also safe for negative assertions: if a mutation was going
 * to trigger a notification, it has been delivered by now.
 */
async function flushResizeObserver() {
  await settled();
  await waitForFrame();
  await settled();
}

function setStyle(el: Element | null, key: string, value: string | number) {
  if (el instanceof HTMLElement) {
    Object.assign(el.style, { [key]: value });
  }
}

function setSize(el: Element | null, { width, height }: { width?: number; height?: number }) {
  if (el instanceof HTMLElement) {
    if (width !== undefined) {
      el.style.width = `${width}px`;
    }

    if (height !== undefined) {
      el.style.height = `${height}px`;
    }
  }
}

module('{{onResize}}', function (hooks) {
  setupRenderingTest(hooks);

  test('has initial callback on render', async function (assert) {
    function handleResize(entry: ResizeObserverEntry) {
      assert.step('called');
      assert.ok(entry instanceof ResizeObserverEntry, 'is expected type');

      const element = find('[data-test]');

      assert.ok(element, 'element exists');
      assert.ok(entry.target, 'entry.target is set');
      assert.strictEqual(element, entry.target, 'element is correct');
      assert.strictEqual(entry.contentRect.height, 100);
      assert.strictEqual(entry.contentRect.width, 100);
    }

    await render(
      <template>
        <div style="width: 100px; height: 100px;" data-test {{onResize handleResize}}>
          Resize me
        </div>
      </template>
    );

    await flushResizeObserver();
    assert.verifySteps(['called']);
  });

  test('callback is called on resize events', async function (assert) {
    function handleResize(entry: ResizeObserverEntry) {
      const { height, width } = entry.contentRect;

      assert.step(`called: ${width} x ${height}`);
    }

    await render(
      <template>
        <div style="width: 100px; height: 100px;" data-test {{onResize handleResize}}>
          Resize me
        </div>
      </template>
    );

    const element = find('[data-test]');

    await flushResizeObserver();
    assert.verifySteps(['called: 100 x 100']);

    setSize(element, { width: 50 });
    await flushResizeObserver();
    assert.verifySteps(['called: 50 x 100']);

    setSize(element, { height: 50 });
    await flushResizeObserver();
    assert.verifySteps(['called: 50 x 50']);

    setSize(element, { width: 50 });
    await flushResizeObserver();
    assert.verifySteps([], 'did not call onResize when size is not changed');
  });

  test('setting element `display` to `none`', async function (assert) {
    function handleResize(entry: ResizeObserverEntry) {
      const { height, width } = entry.contentRect;

      assert.step(`called: ${width} x ${height}`);
    }

    await render(
      <template>
        <div style="width: 100px; height: 100px;" data-test {{onResize handleResize}}>
          Resize me
        </div>
      </template>
    );

    const element = find('[data-test]');

    await flushResizeObserver();
    assert.verifySteps(['called: 100 x 100']);

    setStyle(element, 'display', 'none');
    await flushResizeObserver();
    assert.verifySteps(['called: 0 x 0']);
  });

  test('changing the callback', async function (assert) {
    const createCallback = (id: number) => (entry: ResizeObserverEntry) => {
      const { height, width } = entry.contentRect;

      assert.step(`${id} called: ${width} x ${height}`);
    };

    class State {
      @tracked handleResize1 = createCallback(1);
    }

    const state = new State();

    await render(
      <template>
        <div style="width: 100px; height: 100px;" data-test {{onResize state.handleResize1}}>
          Resize me
        </div>
      </template>
    );

    const element = find('[data-test]');

    await flushResizeObserver();
    assert.verifySteps(['1 called: 100 x 100']);

    setSize(element, { width: 50 });
    await flushResizeObserver();
    assert.verifySteps(['1 called: 50 x 100']);

    state.handleResize1 = createCallback(2);

    // flushResizeObserver settles first, so the modifier re-runs
    // (installing the new callback) before any frames are counted.
    // Since this element only has one {{onResize}}, swapping the
    // callback unobserves and re-observes the element, which triggers
    // a fresh "initial" notification for the new callback.
    await flushResizeObserver();
    assert.verifySteps(['2 called: 50 x 100'], 'new callback receives an initial notification');

    setSize(element, { width: 20 });
    await flushResizeObserver();
    assert.verifySteps(['2 called: 20 x 100']);
  });

  test('using multiple modifiers for the same element', async function (assert) {
    const createCallback = (id: number) => (entry: ResizeObserverEntry) => {
      const { height, width } = entry.contentRect;

      assert.step(`${id} called: ${width} x ${height}`);
    };

    class State {
      @tracked handleResize1 = createCallback(1);
      @tracked handleResize2 = createCallback(2);
    }

    const state = new State();

    await render(
      <template>
        <div
          style="width: 100px; height: 100px;"
          data-test
          {{onResize state.handleResize1}}
          {{onResize state.handleResize2}}
        >
          Resize me
        </div>
      </template>
    );

    const element = find('[data-test]');

    await flushResizeObserver();
    assert.verifySteps(['1 called: 100 x 100', '2 called: 100 x 100']);

    setSize(element, { width: 50 });
    await flushResizeObserver();
    assert.verifySteps(['1 called: 50 x 100', '2 called: 50 x 100']);

    state.handleResize1 = createCallback(3);

    // flushResizeObserver settles first, so the modifier re-runs
    // (installing the new callback) before resizing below. Because the
    // element still has another observed callback, no "initial"
    // notification fires for the swapped-in callback.
    await flushResizeObserver();
    assert.verifySteps([]);

    setSize(element, { width: 20 });
    await flushResizeObserver();
    assert.verifySteps(['2 called: 20 x 100', '3 called: 20 x 100']);
  });

  module('handling errors', function (hooks) {
    hooks.afterEach(function () {
      resetOnerror();
    });

    test('throws if a callback is not a function', async function (assert) {
      setupOnerror((error) => {
        assert.strictEqual(
          error.message,
          'Assertion Failed: {{onResize}}: callback must be a function, but was [object Object]'
        );
      });

      const callback = {};

      await render(
        <template>
          {{! @glint-expect-error - deliberate incorrect type }}
          <div data-test {{onResize callback}}>
            Resize me
          </div>
        </template>
      );
    });

    test('throws if a callback is not provided', async function (assert) {
      setupOnerror((error) => {
        assert.strictEqual(
          error.message,
          'Assertion Failed: {{onResize}}: callback must be a function, but was undefined'
        );
      });

      await render(
        <template>
          {{! @glint-expect-error - deliberate missing args}}
          <div data-test {{onResize}}>
            Resize me
          </div>
        </template>
      );
    });
  });

  test('prevents ResizeObserver loop limit related errors', async function (assert) {
    assert.expect(0);

    class State {
      @tracked showText = true;
    }

    const state = new State();

    const handleResize = () => (state.showText = true);

    await render(
      <template>
        <div {{onResize handleResize}}>
          {{if state.showText "Trigger ResizeObserver again"}}
        </div>
      </template>
    );

    // Give the ResizeObserver a chance to loop (and would-be errors a
    // chance to be reported) before the test tears down.
    await flushResizeObserver();
  });
});
