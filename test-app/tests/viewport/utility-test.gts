import { tracked } from '@glimmer/tracking';
import { assert as debugAssert } from '@ember/debug';
import { destroy } from '@ember/destroyable';
import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { viewport } from 'ember-primitives/viewport';

import type Owner from '@ember/owner';

function assertDefined<T>(
  value: T | null | undefined
): asserts value is Exclude<T, null | undefined> {
  debugAssert('Value must be defined', value != null);
}

async function delay(ms = 50) {
  await new Promise((resolve) => {
    setTimeout(resolve, ms);
  });
  await settled();
}

module('viewport', function (hooks) {
  setupRenderingTest(hooks);

  test('observe and unobserve work correctly', async function (assert) {
    let entry: IntersectionObserverEntry | null = null;

    class TestContext {
      element: Element | null = null;

      constructor(public owner: Owner) {}

      get #viewport() {
        return viewport(this);
      }

      handleIntersection = (e: IntersectionObserverEntry) => {
        entry = e;
        assert.step('callback');
      };

      observe(element: Element) {
        this.element = element;
        this.#viewport.observe(element, this.handleIntersection);
      }

      unobserve() {
        this.#viewport.unobserve(this.element, this.handleIntersection);
      }
    }

    const context = new TestContext(this.owner);

    await render(
      <template>
        <div data-test-element style="width: 100px; height: 100px;"></div>
      </template>
    );

    const element = document.querySelector('[data-test-element]');

    assert.ok(element, 'element exists');
    debugAssert('element is defined', element !== null);

    if (element) {
      context.observe(element);
    }

    await delay(100);

    assert.verifySteps(['callback'], 'callback was called initially');
    assert.ok(entry, 'entry was set');

    assertDefined(entry);

    const typedEntry = entry as IntersectionObserverEntry;

    assert.ok(typedEntry instanceof IntersectionObserverEntry, 'entry is correct type');
    assert.strictEqual(typedEntry.target, element, 'entry target is correct');

    context.unobserve();

    entry = null;

    await delay(100);

    assert.verifySteps([], 'callback was not called after unobserve');
  });

  test('multiple callbacks on same element', async function (assert) {
    let entry1: IntersectionObserverEntry | null = null;
    let entry2: IntersectionObserverEntry | null = null;

    class TestContext {
      element: Element | null = null;

      constructor(public owner: Owner) {}

      get #viewport() {
        return viewport(this);
      }

      handleIntersection1 = (e: IntersectionObserverEntry) => {
        entry1 = e;
        assert.step('callback1');
      };

      handleIntersection2 = (e: IntersectionObserverEntry) => {
        entry2 = e;
        assert.step('callback2');
      };

      observe(element: Element) {
        this.element = element;
        this.#viewport.observe(element, this.handleIntersection1);
        this.#viewport.observe(element, this.handleIntersection2);
      }

      unobserve() {
        if (this.element) {
          this.#viewport.unobserve(this.element, this.handleIntersection1);
          this.#viewport.unobserve(this.element, this.handleIntersection2);
        }
      }
    }

    const context = new TestContext(this.owner);

    await render(
      <template>
        <div data-test-element style="width: 100px; height: 100px;"></div>
      </template>
    );

    const element = document.querySelector('[data-test-element]');

    assert.ok(element, 'element exists');
    debugAssert('element is defined', element !== null);

    context.observe(element);

    await delay(100);

    assert.verifySteps(['callback1', 'callback2'], 'both callbacks were called');
    assert.ok(entry1, 'entry1 was set');
    assert.ok(entry2, 'entry2 was set');

    context.unobserve();

    await delay(100);

    assert.verifySteps([], 'callbacks were not called after unobserve');
  });

  test('callback receives intersection data', async function (assert) {
    let entry: IntersectionObserverEntry | null = null;

    class TestContext {
      element: Element | null = null;

      constructor(public owner: Owner) {}

      get #viewport() {
        return viewport(this);
      }

      handleIntersection = (e: IntersectionObserverEntry) => {
        entry = e;
      };

      observe(element: Element) {
        this.element = element;
        this.#viewport.observe(element, this.handleIntersection);
      }

      unobserve() {
        if (this.element) {
          this.#viewport.unobserve(this.element, this.handleIntersection);
        }
      }
    }

    const context = new TestContext(this.owner);

    await render(
      <template>
        <div data-test-element style="width: 100px; height: 100px;"></div>
      </template>
    );

    const element = document.querySelector('[data-test-element]');

    assert.ok(element, 'element exists');

    context.observe(element as Element);

    await delay(100);

    assert.ok(entry, 'entry was set');
    assertDefined(entry);

    const typedEntry = entry as IntersectionObserverEntry;

    assert.ok(typedEntry.boundingClientRect, 'boundingClientRect exists');
    assert.ok(typedEntry.intersectionRect, 'intersectionRect exists');
  });

  test('changing callback reference', async function (assert) {
    class TestContext {
      @tracked callback: ((e: IntersectionObserverEntry) => void) | null = null;
      element: Element | null = null;

      constructor(public owner: Owner) {}

      get #viewport() {
        return viewport(this);
      }

      observe(element: Element) {
        this.element = element;

        if (this.callback) {
          this.#viewport.observe(element, this.callback);
        }
      }

      updateCallback(newCallback: (e: IntersectionObserverEntry) => void) {
        if (this.element && this.callback) {
          this.#viewport.unobserve(this.element, this.callback);
        }

        this.callback = newCallback;

        if (this.element) {
          this.#viewport.observe(this.element, newCallback);
        }
      }

      unobserve() {
        if (this.element && this.callback) {
          this.#viewport.unobserve(this.element, this.callback);
        }
      }
    }

    const context = new TestContext(this.owner);

    const callback1 = () => {
      assert.step('callback1');
    };

    const callback2 = () => {
      assert.step('callback2');
    };

    await render(
      <template>
        <div data-test-element style="width: 100px; height: 100px;"></div>
      </template>
    );

    const element = document.querySelector('[data-test-element]');

    assert.ok(element, 'element exists');
    debugAssert('element is defined', element !== null);

    context.updateCallback(callback1);
    context.observe(element);

    await delay(100);

    assert.verifySteps(['callback1'], 'first callback was called');

    context.updateCallback(callback2);

    await delay(100);

    assert.verifySteps(['callback2'], 'second callback was called after update');

    context.unobserve();
  });

  test('unobserve with no callback removes all callbacks', async function (assert) {
    let called1 = false;
    let called2 = false;

    class TestContext {
      element: Element | null = null;

      constructor(public owner: Owner) {}

      get #viewport() {
        return viewport(this);
      }

      handleIntersection1 = () => {
        called1 = true;
      };

      handleIntersection2 = () => {
        called2 = true;
      };

      observe(element: Element) {
        this.element = element;
        this.#viewport.observe(element, this.handleIntersection1);
        this.#viewport.observe(element, this.handleIntersection2);
      }

      unobserveAll() {
        if (this.element) {
          // @ts-expect-error - testing unobserve without specific callback
          this.#viewport.unobserve(this.element);
        }
      }
    }

    const context = new TestContext(this.owner);

    await render(
      <template>
        <div data-test-element style="width: 100px; height: 100px;"></div>
      </template>
    );

    const element = document.querySelector('[data-test-element]');

    assert.ok(element, 'element exists');
    debugAssert('element is defined', element !== null);

    context.observe(element);

    await delay(100);

    assert.ok(called1, 'callback1 was called');
    assert.ok(called2, 'callback2 was called');

    called1 = false;
    called2 = false;

    context.unobserveAll();

    await delay(100);

    assert.notOk(called1, 'callback1 was not called after unobserveAll');
    assert.notOk(called2, 'callback2 was not called after unobserveAll');
  });

  test('destruction unobserves all observed elements', async function (assert) {
    let calledAfterDestroy = false;

    class TestContext {
      element1: Element | null = null;
      element2: Element | null = null;

      constructor(public owner: Owner) {}

      get #viewport() {
        return viewport(this);
      }

      handleIntersection = () => {
        calledAfterDestroy = true;
        assert.step('callback');
      };

      observe(element: Element) {
        this.#viewport.observe(element, this.handleIntersection);
      }

      observeMultiple(element1: Element, element2: Element) {
        this.element1 = element1;
        this.element2 = element2;
        this.#viewport.observe(element1, this.handleIntersection);
        this.#viewport.observe(element2, this.handleIntersection);
      }
    }

    const context = new TestContext(this.owner);

    await render(
      <template>
        <div data-test-element1 style="width: 100px; height: 100px;"></div>
        <div data-test-element2 style="width: 100px; height: 100px;"></div>
      </template>
    );

    const element1 = document.querySelector('[data-test-element1]');
    const element2 = document.querySelector('[data-test-element2]');

    assert.ok(element1, 'element1 exists');
    assert.ok(element2, 'element2 exists');
    debugAssert('element1 is defined', element1 !== null);
    debugAssert('element2 is defined', element2 !== null);

    context.observeMultiple(element1, element2);

    await delay(100);

    assert.verifySteps(['callback', 'callback'], 'both callbacks were called initially');

    // Destroy the context, which should trigger destruction of the viewport manager
    destroy(context);

    calledAfterDestroy = false;

    await delay(100);

    assert.notOk(calledAfterDestroy, 'callbacks were not called after destruction');
  });
});
