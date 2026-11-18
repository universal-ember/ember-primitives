import { clearRender, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { LightRays } from 'docs-app/components/light-rays';
import { createFrameLoop } from 'docs-app/components/light-rays/frame-loop';
import { createLightRays } from 'docs-app/components/light-rays/renderer';

/**
 * Replaces a property on an object for one test and puts the original back afterwards.
 */
function replace<T extends object, K extends keyof T>(
  hooks: NestedHooks,
  target: T,
  key: K,
  value: () => T[K]
) {
  let original: T[K];

  hooks.beforeEach(function () {
    original = target[key];
    target[key] = value();
  });

  hooks.afterEach(function () {
    target[key] = original;
  });
}

function reducedMotion(matches: boolean) {
  const original = window.matchMedia.bind(window);

  return (query: string) => {
    const result = original(query);

    if (!query.includes('prefers-reduced-motion')) return result;

    return new Proxy(result, {
      get(target, property) {
        if (property === 'matches') return matches;

        const value: unknown = Reflect.get(target, property);

        return typeof value === 'function' ? (value.bind(target) as unknown) : value;
      },
    });
  };
}

module('Rendering | LightRays', function (hooks) {
  setupRenderingTest(hooks);

  test('renders a canvas that assistive technology ignores', async function (assert) {
    await render(<template><LightRays /></template>);

    assert.dom('canvas.light-rays').exists({ count: 1 });
    assert.dom('canvas.light-rays').hasAttribute('aria-hidden', 'true');
  });

  test('can be removed again without errors', async function (assert) {
    await render(<template><LightRays /></template>);
    await clearRender();

    assert.dom('canvas.light-rays').doesNotExist();
  });

  module('without WebGL', function (hooks) {
    replace(hooks, HTMLCanvasElement.prototype, 'getContext', () => () => null);

    test('still renders the canvas', async function (assert) {
      await render(<template><LightRays /></template>);

      assert.dom('canvas.light-rays').exists({ count: 1 });
    });

    test('createLightRays returns null', function (assert) {
      assert.strictEqual(createLightRays(document.createElement('canvas')), null);
    });
  });

  module('frame loop', function (hooks) {
    let requested: number[] = [];
    let cancelled: number[] = [];

    hooks.beforeEach(function () {
      requested = [];
      cancelled = [];
    });

    replace(hooks, window, 'requestAnimationFrame', () => {
      const original = window.requestAnimationFrame.bind(window);

      return (callback: FrameRequestCallback) => {
        const id = original(callback);

        requested.push(id);

        return id;
      };
    });

    replace(hooks, window, 'cancelAnimationFrame', () => {
      const original = window.cancelAnimationFrame.bind(window);

      return (id: number) => {
        cancelled.push(id);
        original(id);
      };
    });

    function create() {
      const element = document.createElement('div');
      const draws: boolean[] = [];

      document.querySelector('#ember-testing')?.append(element);

      const frameLoop = createFrameLoop(element, (isStill) => draws.push(isStill));

      return { frameLoop, draws };
    }

    test('draws straight away and requests the next frame', function (assert) {
      const { frameLoop, draws } = create();

      assert.deepEqual(draws, [false], 'draws once with motion');
      assert.strictEqual(requested.length, 1, 'requests one frame');

      frameLoop.destroy();
    });

    test('destroy cancels the frame it requested', function (assert) {
      const { frameLoop } = create();

      frameLoop.destroy();

      assert.deepEqual(cancelled, requested);
    });

    module('with reduced motion', function (hooks) {
      replace(hooks, window, 'matchMedia', () => reducedMotion(true));

      test('draws one still image and does not request a frame', function (assert) {
        const { frameLoop, draws } = create();

        assert.deepEqual(draws, [true], 'draws once without motion');
        assert.strictEqual(requested.length, 0, 'requests no frame');

        frameLoop.destroy();
      });
    });
  });
});
