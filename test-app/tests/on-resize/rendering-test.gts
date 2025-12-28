import { tracked } from '@glimmer/tracking';
import { later } from '@ember/runloop';
import { find, render, resetOnerror, settled, setupOnerror } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { onResize } from 'ember-primitives/on-resize';

async function delay(ms = 50) {
  await new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
  await settled();
}

function setStyle(el: Element | null, key: string, value: string | number) {
  if (el instanceof HTMLElement) {
    Object.assign(el.style, { [key]: value });
  }

  return delay(50);
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

  return delay(50);
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

    await delay();
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

    await delay();
    assert.verifySteps(['called: 100 x 100']);

    await setSize(element, { width: 50 });
    assert.verifySteps(['called: 50 x 100']);

    await setSize(element, { height: 50 });
    assert.verifySteps(['called: 50 x 50']);

    await setSize(element, { width: 50 });
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

    await delay();
    assert.verifySteps(['called: 100 x 100']);

    await setStyle(element, 'display', 'none');
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

    await delay();
    assert.verifySteps(['1 called: 100 x 100']);

    await setSize(element, { width: 50 });
    assert.verifySteps(['1 called: 50 x 100']);

    state.handleResize1 = createCallback(2);
    await setSize(element, { width: 20 });
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

    await delay();
    assert.verifySteps(['1 called: 100 x 100', '2 called: 100 x 100']);

    await setSize(element, { width: 50 });
    assert.verifySteps(['1 called: 50 x 100', '2 called: 50 x 100']);

    state.handleResize1 = createCallback(3);
    await setSize(element, { width: 20 });
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

    delay();
  });
});
