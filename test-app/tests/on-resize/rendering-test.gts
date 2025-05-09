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

function setStyle(el, key, value) {
  el.style[key] = value;

  return delay(50);
}

function setSize(el, { width, height }) {
  if (width !== undefined) {
    el.style.width = `${width}px`;
  }

  if (height !== undefined) {
    el.style.height = `${height}px`;
  }

  return delay(50);
}

module('{{onResize}}', function (hooks) {
  setupRenderingTest(hooks);

  test('has initial callback on render', async function (assert) {
    let element: Element = undefined;

    function handleResize(entry: ResizeObserverEntry) {
      assert.step('called');
      assert.ok(entry instanceof ResizeObserverEntry, 'is expected type');
      assert.strictEqual(element, entry.target.element, 'element is correct');
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

    element = find('[data-test]');

    await delay();
    assert.verifySteps(['called']);
  });

  test('callback is called on resize events', async function (assert) {
    let element: Element = undefined;

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

    element = find('[data-test]');

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
    let element: Element = undefined;

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

    element = find('[data-test]');

    await delay();
    assert.verifySteps(['called: 100 x 100']);

    await setStyle(element, 'display', 'none');
    assert.verifySteps(['called: 0 x 0']);
  });

  test('using multiple modifiers for the same element', async function (assert) {
    let element: Element = undefined;
    const createCallback = (id) => (entry: ResizeObserverEntry) => {
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

    element = find('[data-test]');

    await delay();
    assert.verifySteps(['1 called: 100 x 100', '2 called: 100 x 100']);

    await setSize(element, { width: 50 });
    assert.verifySteps(['1 called: 50 x 100', '2 called: 50 x 100']);

    state.handleResize1 = createCallback(3);
    await setSize(element, { width: 20 });
    assert.verifySteps(['3 called: 20 x 100', '2 called: 20 x 100']);
  });

  test('changing the callback', async function (assert) {
    const callback1 = sinon.spy().named('callback1');
    const callback2 = sinon.spy().named('callback2');

    this.onResize = callback1;

    await render(hbs`
      <div
        style="width: 100px;"
        data-test
        {{on-resize this.onResize}}
      >
        Resize me
      </div>
    `);

    const element = find('[data-test]');

    await delay();

    assert.spy(callback1).calledOnce();
    assert.spy(callback2).notCalled();

    callback1.resetHistory();
    this.set('onResize', callback2);
    await delay();

    assert.spy(callback1).notCalled();
    assert.spy(callback2).notCalled();

    await setSize(element, { width: 50 });

    assert.spy(callback1).notCalled();
    assert.spy(callback2).calledOnce();
  });

  module('handling errors', function (hooks) {
    hooks.afterEach(function () {
      resetOnerror();
    });

    test('throws if a callback is not a function', async function (assert) {
      assert.expect(1);

      setupOnerror((error) => {
        assert.equal(
          error.message,
          'Assertion Failed: on-resize-modifier: callback must be a function, but was [object Object]'
        );
      });

      this.callback = {};

      await render(hbs`
        <div data-test {{on-resize this.callback}}>
          Resize me
        </div>
      `);
    });

    test('throws if a callback is not provided', async function (assert) {
      assert.expect(1);

      setupOnerror((error) => {
        assert.equal(
          error.message,
          'Assertion Failed: on-resize-modifier: callback must be a function, but was undefined'
        );
      });

      await render(hbs`
        <div data-test {{on-resize}}>
          Resize me
        </div>
      `);
    });
  });

  test('prevents ResizeObserver loop limit related errors', async function (assert) {
    assert.expect(0);
    this.onResize = () => this.set('showText', true);

    await render(hbs`
      <div {{on-resize this.onResize}}>
        {{if this.showText "Trigger ResizeObserver again"}}
      </div>
    `);

    delay();
  });
});
