/** eslint-disable @typescript-eslint/ban-ts-comment */
import { assert as debugAssert } from '@ember/debug';
import { find, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { PORTALS, PortalTargets } from 'ember-primitives';
import { findNearestTarget } from 'ember-primitives/components/portal-targets';

module('Rendering | <PortalTargets>', function (hooks) {
  setupRenderingTest(hooks);

  test('just divs', async function (assert) {
    await render(<template><PortalTargets /></template>);

    for (const name of Object.values(PORTALS)) {
      assert.dom(`[data-portal-name="${name}"]`).exists();
    }
  });
});

module('Rendering | findNearestTarget', function (hooks) {
  setupRenderingTest(hooks);

  module('Incorrect usages', function () {
    test('no args are passed', async function (assert) {
      assert.throws(() => {
        // @ts-expect-error intentionally incorrect for js usage simulation
        findNearestTarget();
      }, /first argument to/);
    });

    test('first arg is not an element', async function (assert) {
      assert.throws(() => {
        // @ts-expect-error intentionally incorrect for js usage simulation
        findNearestTarget(2);
      }, /first argument to/);
    });

    test('second arg is missing', async function (assert) {
      assert.throws(() => {
        // @ts-expect-error intentionally incorrect for js usage simulation
        findNearestTarget(document.body);
      }, /second argument to/);
    });

    test('second arg is not a string', async function (assert) {
      assert.throws(() => {
        // @ts-expect-error intentionally incorrect for js usage simulation
        findNearestTarget(document.body, 2);
      }, /second argument to/);
    });

    test('second arg, representing the target name, is not in the DOM', async function (assert) {
      await render(
        <template>
          <div id="origin"></div>
        </template>
      );

      const origin = find('#origin');

      assert.throws(() => {
        debugAssert(`[BUG]`, origin);
        findNearestTarget(origin, PORTALS.popover);
      }, /Could not find element by the given name/);
    });
  });

  test('finds root targets', async function (assert) {
    await render(
      <template>
        <PortalTargets />

        <div id="origin"></div>
      </template>
    );

    const origin = find('#origin');

    debugAssert(`[BUG]`, origin);
    assert.ok(findNearestTarget(origin, PORTALS.popover));
  });

  test('finds nested targets', async function (assert) {
    await render(
      <template>
        <div id="root">
          <PortalTargets />
        </div>

        <div id="pretend-modal">
          <PortalTargets />
          <div id="origin"></div>
        </div>
      </template>
    );

    const origin = find('#origin');
    const nestedTarget = find(`#pretend-modal [data-portal-name=${PORTALS.popover}]`);

    debugAssert(`[BUG]: origin`, origin);
    debugAssert(`[BUG]: nestedTarget`, nestedTarget);
    assert.strictEqual(findNearestTarget(origin, PORTALS.popover), nestedTarget);
  });

  test('not fooled by siling portal targets 1', async function (assert) {
    await render(
      <template>
        <div id="root">
          <PortalTargets />
        </div>

        <div id="pretend-modal">
          <PortalTargets />
          <div id="origin"></div>
        </div>

        <div>
          <PortalTargets />
          <div></div>
        </div>
      </template>
    );

    const origin = find('#origin');
    const nestedTarget = find(`#pretend-modal [data-portal-name=${PORTALS.popover}]`);

    debugAssert(`[BUG]: origin`, origin);
    debugAssert(`[BUG]: nestedTarget`, nestedTarget);
    assert.strictEqual(findNearestTarget(origin, PORTALS.popover), nestedTarget);
  });

  test('not fooled by siling portal targets 2', async function (assert) {
    await render(
      <template>
        <div id="root">
          <PortalTargets />
        </div>

        <div>
          <PortalTargets />
          <div></div>
        </div>

        <div id="pretend-modal">
          <PortalTargets />
          <div id="origin"></div>
        </div>
      </template>
    );

    const origin = find('#origin');
    const nestedTarget = find(`#pretend-modal [data-portal-name=${PORTALS.popover}]`);

    debugAssert(`[BUG]: origin`, origin);
    debugAssert(`[BUG]: nestedTarget`, nestedTarget);
    assert.strictEqual(findNearestTarget(origin, PORTALS.popover), nestedTarget);
  });

  test('nested modals, the worst UX', async function (assert) {
    await render(
      <template>
        <div id="root">
          <PortalTargets />
        </div>

        <div>
          <PortalTargets />
          <div id="pretend-modal">
            <PortalTargets />
            <div id="origin"></div>
          </div>
        </div>
      </template>
    );

    const origin = find('#origin');
    const nestedTarget = find(`#pretend-modal [data-portal-name=${PORTALS.popover}]`);

    debugAssert(`[BUG]: origin`, origin);
    debugAssert(`[BUG]: nestedTarget`, nestedTarget);
    assert.strictEqual(findNearestTarget(origin, PORTALS.popover), nestedTarget);
  });
});
