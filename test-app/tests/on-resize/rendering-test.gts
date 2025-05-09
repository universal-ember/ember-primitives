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
    this.onResize = sinon.spy().named('onResize');

    await render(hbs`
      <div
        style="width: 100px"
        data-test
        {{on-resize this.onResize}}
      >
        Resize me
      </div>
    `);

    const element = find('[data-test]');

    await delay();

    assert.spy(this.onResize).called();

    this.onResize.resetHistory();
    await setStyle(element, 'display', 'none');

    assert
      .spy(this.onResize)
      .calledOnce()
      .calledWithExactly([sinon.match({ target: element })])
      .calledWithExactly([sinon.match({ contentRect: sinon.match({ height: 0, width: 0 }) })]);
  });

  test('using multiple modifiers for the same element', async function (assert) {
    const callback1 = sinon.spy().named('callback1');
    const callback2 = sinon.spy().named('callback2');
    const callback3 = sinon.spy().named('callback3');

    this.onResize1 = callback1;
    this.onResize2 = callback2;

    await render(hbs`
      <div
        style="width: 100px;"
        data-test
        {{on-resize this.onResize1}}
        {{on-resize this.onResize2}}
      >
        Resize me
      </div>
    `);

    const element = find('[data-test]');

    await delay();

    assert.spy(callback1).calledOnce();
    assert.spy(callback2).calledOnce();

    callback1.resetHistory();
    callback2.resetHistory();
    await setSize(element, { width: 50 });

    assert.spy(callback1).calledOnce();
    assert.spy(callback2).calledOnce();

    this.set('onResize1', callback3);
    callback1.resetHistory();
    callback2.resetHistory();
    await setSize(element, { width: 20 });

    assert.spy(callback1).notCalled();
    assert.spy(callback2).calledOnce();
    assert.spy(callback3).calledOnce();
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
