import { tracked } from '@glimmer/tracking';
import { render, settled, triggerEvent, triggerKeyEvent } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Resizable } from 'ember-primitives';

/**
 * The #ember-testing container is scaled, so assertions are made in
 * "visual" pixels (getBoundingClientRect) relative to other measurements,
 * never against hard-coded layout sizes.
 */
function widthOf(selector: string): number {
  const element = document.querySelector(selector);

  if (!element) throw new Error(`Could not find ${selector}`);

  return element.getBoundingClientRect().width;
}

function heightOf(selector: string): number {
  const element = document.querySelector(selector);

  if (!element) throw new Error(`Could not find ${selector}`);

  return element.getBoundingClientRect().height;
}

async function drag(selector: string, options: { from: number; to: number; axis?: 'x' | 'y' }) {
  const axis = options.axis ?? 'x';
  const start =
    axis === 'x' ? { clientX: options.from, clientY: 0 } : { clientX: 0, clientY: options.from };
  const end =
    axis === 'x' ? { clientX: options.to, clientY: 0 } : { clientX: 0, clientY: options.to };

  await triggerEvent(selector, 'pointerdown', { button: 0, pointerId: 1, ...start });
  await triggerEvent(selector, 'pointermove', { pointerId: 1, ...end });
  await triggerEvent(selector, 'pointerup', { pointerId: 1, ...end });
}

const TOLERANCE = 3;

function closeTo(actual: number, expected: number): boolean {
  return Math.abs(actual - expected) < TOLERANCE;
}

module('Rendering | <Resizable>', function (hooks) {
  setupRenderingTest(hooks);

  module('two panels, default sizes', function (hooks) {
    hooks.beforeEach(async function () {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );
    });

    test('panels split the space evenly', async function (assert) {
      const a = widthOf('[data-test-a]');
      const b = widthOf('[data-test-b]');

      assert.ok(a > 0, `a (${a}px) is visible`);
      assert.ok(closeTo(a, b), `a (${a}px) and b (${b}px) are the same size`);
    });

    test('the handle implements the window-splitter pattern', async function (assert) {
      assert.dom('[data-test-handle]').hasAttribute('role', 'separator');
      assert.dom('[data-test-handle]').hasAttribute('tabindex', '0');
      assert.dom('[data-test-handle]').hasAria('orientation', 'vertical');
      assert.dom('[data-test-handle]').hasAria('valuenow', '50');
      assert.dom('[data-test-handle]').hasAria('valuemin', '0');
      assert.dom('[data-test-handle]').hasAria('valuemax', '100');

      const controls = document.querySelector('[data-test-handle]')?.getAttribute('aria-controls');
      const panelId = document.querySelector('[data-test-a]')?.getAttribute('id');

      assert.ok(panelId, 'the panel has an id');
      assert.strictEqual(controls, panelId, 'aria-controls references the preceding panel');
    });

    test('dragging the handle resizes both panels', async function (assert) {
      const aBefore = widthOf('[data-test-a]');
      const bBefore = widthOf('[data-test-b]');

      await drag('[data-test-handle]', { from: 200, to: 250 });

      const a = widthOf('[data-test-a]');
      const b = widthOf('[data-test-b]');

      assert.ok(closeTo(a, aBefore + 50), `a grew by 50px (${aBefore}px -> ${a}px)`);
      assert.ok(closeTo(b, bBefore - 50), `b shrank by 50px (${bBefore}px -> ${b}px)`);
    });

    test('arrow keys resize the panels', async function (assert) {
      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowRight');

      assert.dom('[data-test-handle]').hasAria('valuenow', '51');

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowLeft');
      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowLeft');

      assert.dom('[data-test-handle]').hasAria('valuenow', '49');
    });

    test('shift+arrow resizes in coarse steps', async function (assert) {
      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowRight', { shiftKey: true });

      assert.dom('[data-test-handle]').hasAria('valuenow', '60');
    });

    test('up/down arrows do nothing in a horizontal group', async function (assert) {
      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowUp');
      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowDown');

      assert.dom('[data-test-handle]').hasAria('valuenow', '50');
    });

    test('Home and End move the boundary to the extremes', async function (assert) {
      await triggerKeyEvent('[data-test-handle]', 'keydown', 'Home');

      assert.dom('[data-test-handle]').hasAria('valuenow', '0');

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'End');

      assert.dom('[data-test-handle]').hasAria('valuenow', '100');
    });
  });

  module('three panels', function (hooks) {
    hooks.beforeEach(async function () {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
              <r.Handle data-test-handle-2 />
              <r.Panel data-test-c>c</r.Panel>
            </Resizable>
          </div>
        </template>
      );
    });

    test('each handle describes the panel immediately before it', async function (assert) {
      const handle2 = document.querySelector('[data-test-handle-2]');
      const panelB = document.querySelector('[data-test-b]');

      assert.strictEqual(
        handle2?.getAttribute('aria-controls'),
        panelB?.getAttribute('id'),
        'the second handle controls the middle panel'
      );
    });

    test('dragging a handle only affects its two adjacent panels', async function (assert) {
      const aBefore = widthOf('[data-test-a]');
      const bBefore = widthOf('[data-test-b]');
      const cBefore = widthOf('[data-test-c]');

      await drag('[data-test-handle-2]', { from: 300, to: 250 });

      assert.strictEqual(widthOf('[data-test-a]'), aBefore, 'a is untouched');
      assert.ok(closeTo(widthOf('[data-test-b]'), bBefore - 50), 'b shrank');
      assert.ok(closeTo(widthOf('[data-test-c]'), cBefore + 50), 'c grew');
    });
  });

  module('drag lifecycle', function () {
    test('drag state is set while dragging and cleaned up afterwards', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      await triggerEvent('[data-test-handle]', 'pointerdown', {
        button: 0,
        pointerId: 1,
        clientX: 250,
        clientY: 0,
      });

      assert.dom('[data-test-handle]').hasAttribute('data-resizing');
      assert.strictEqual(document.body.style.cursor, 'col-resize', 'body cursor is set');

      await triggerEvent('[data-test-handle]', 'pointerup', { pointerId: 1 });

      assert.dom('[data-test-handle]').doesNotHaveAttribute('data-resizing');
      assert.strictEqual(document.body.style.cursor, '', 'body cursor is restored');
    });

    test('pointercancel also ends the drag', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      await triggerEvent('[data-test-handle]', 'pointerdown', {
        button: 0,
        pointerId: 1,
        clientX: 250,
        clientY: 0,
      });
      await triggerEvent('[data-test-handle]', 'pointercancel', { pointerId: 1 });

      assert.dom('[data-test-handle]').doesNotHaveAttribute('data-resizing');
      assert.strictEqual(document.body.style.cursor, '', 'body cursor is restored');

      // pointermove after cancel does nothing
      const before = widthOf('[data-test-a]');

      await triggerEvent('[data-test-handle]', 'pointermove', {
        pointerId: 1,
        clientX: 400,
        clientY: 0,
      });

      assert.strictEqual(widthOf('[data-test-a]'), before, 'no resize after cancel');
    });

    test('non-primary buttons do not start a drag', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      await triggerEvent('[data-test-handle]', 'pointerdown', {
        button: 2,
        pointerId: 1,
        clientX: 250,
        clientY: 0,
      });

      assert.dom('[data-test-handle]').doesNotHaveAttribute('data-resizing');
    });
  });

  module('constraints', function () {
    test('minSize and maxSize are respected while dragging', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel @minSize={{20}} @maxSize={{60}} data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      const total = widthOf('[data-test-a]') + widthOf('[data-test-b]');

      await drag('[data-test-handle]', { from: 300, to: -1000 });

      let a = widthOf('[data-test-a]');

      assert.ok(closeTo(a, total * 0.2), `a stopped at its minSize (${a}px of ${total}px)`);
      assert.dom('[data-test-handle]').hasAria('valuenow', '20');

      await drag('[data-test-handle]', { from: 0, to: 1000 });

      a = widthOf('[data-test-a]');

      assert.ok(closeTo(a, total * 0.6), `a stopped at its maxSize (${a}px of ${total}px)`);
      assert.dom('[data-test-handle]').hasAria('valuenow', '60');
    });

    test('defaultSizes that do not sum to 100 are normalized', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel @defaultSize={{40}} data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel @defaultSize={{40}} data-test-b>b</r.Panel>
              <r.Handle data-test-handle-2 />
              <r.Panel @defaultSize={{40}} data-test-c>c</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      assert.dom('[data-test-handle]').hasAria('valuenow', '33');
      assert.dom('[data-test-handle-2]').hasAria('valuenow', '33');
    });

    test('End respects the following panel’s minSize', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel @minSize={{30}} data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'End');

      assert.dom('[data-test-handle]').hasAria('valuenow', '70');
    });

    test('defaultSize sets the initial layout', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel @defaultSize={{30}} data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      assert.dom('[data-test-handle]').hasAria('valuenow', '30');
    });
  });

  module('collapsible', function () {
    test('Enter collapses and restores the preceding panel', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel @collapsible={{true}} data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'Enter');

      assert.dom('[data-test-handle]').hasAria('valuenow', '0');
      assert.dom('[data-test-a]').hasAttribute('data-collapsed');
      assert.ok(widthOf('[data-test-a]') < TOLERANCE, 'panel is visually collapsed');

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'Enter');

      assert.dom('[data-test-handle]').hasAria('valuenow', '50');
      assert.dom('[data-test-a]').doesNotHaveAttribute('data-collapsed');
    });

    test('dragging far past the minSize collapses; a small overshoot holds at minSize', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel @collapsible={{true}} @minSize={{20}} data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      const total = widthOf('[data-test-a]') + widthOf('[data-test-b]');

      // a small overshoot past minSize holds at minSize (20%)
      await drag('[data-test-handle]', { from: total / 2, to: total * 0.15 });

      assert.dom('[data-test-handle]').hasAria('valuenow', '20');
      assert.dom('[data-test-a]').doesNotHaveAttribute('data-collapsed');

      // dragging well past half the minSize snaps closed
      await drag('[data-test-handle]', { from: total * 0.2, to: 0 });

      assert.dom('[data-test-handle]').hasAria('valuenow', '0');
      assert.dom('[data-test-a]').hasAttribute('data-collapsed');

      // dragging further closed keeps it collapsed (no snap back open)
      await drag('[data-test-handle]', { from: 0, to: -50 });

      assert.dom('[data-test-handle]').hasAria('valuenow', '0');
      assert.dom('[data-test-a]').hasAttribute('data-collapsed');

      // dragging back open past the minSize expands again
      await drag('[data-test-handle]', { from: 0, to: total * 0.4 });

      assert.dom('[data-test-handle]').hasAria('valuenow', '40');
      assert.dom('[data-test-a]').doesNotHaveAttribute('data-collapsed');
    });

    test('Enter does nothing when the panel is not collapsible', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'Enter');

      assert.dom('[data-test-handle]').hasAria('valuenow', '50');
    });
  });

  module('vertical orientation', function () {
    test('panels stack and resize along the y-axis', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 200px; height: 408px;">
            <Resizable @orientation="vertical" as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      assert.dom('[data-test-handle]').hasAria('orientation', 'horizontal');

      const aBefore = heightOf('[data-test-a]');
      const bBefore = heightOf('[data-test-b]');

      assert.ok(closeTo(aBefore, bBefore), `a (${aBefore}px) and b (${bBefore}px) split evenly`);

      await drag('[data-test-handle]', { from: 200, to: 250, axis: 'y' });

      const a = heightOf('[data-test-a]');

      assert.ok(closeTo(a, aBefore + 50), `a grew by 50px (${aBefore}px -> ${a}px)`);
    });
  });

  module('nesting', function () {
    test('an inner group resizes independently of the outer group', async function (assert) {
      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 408px;">
            <Resizable as |outer|>
              <outer.Panel data-test-left>left</outer.Panel>
              <outer.Handle data-test-outer-handle />
              <outer.Panel data-test-right>
                <Resizable @orientation="vertical" as |inner|>
                  <inner.Panel data-test-top>top</inner.Panel>
                  <inner.Handle data-test-inner-handle />
                  <inner.Panel data-test-bottom>bottom</inner.Panel>
                </Resizable>
              </outer.Panel>
            </Resizable>
          </div>
        </template>
      );

      const topBefore = heightOf('[data-test-top]');
      const bottomBefore = heightOf('[data-test-bottom]');
      const leftBefore = widthOf('[data-test-left]');

      assert.ok(
        closeTo(topBefore, bottomBefore),
        `top (${topBefore}px) and bottom (${bottomBefore}px) split evenly`
      );

      await drag('[data-test-inner-handle]', { from: 200, to: 150, axis: 'y' });

      const top = heightOf('[data-test-top]');

      assert.ok(closeTo(top, topBefore - 50), `top shrank by 50px (${topBefore}px -> ${top}px)`);
      assert.strictEqual(
        widthOf('[data-test-left]'),
        leftBefore,
        'the outer group was not affected'
      );
    });
  });

  module('dynamic panels', function () {
    test('a panel added to a full group takes an equal share', async function (assert) {
      class State {
        @tracked showThird = false;
      }

      const state = new State();

      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
              {{#if state.showThird}}
                <r.Handle data-test-handle-2 />
                <r.Panel data-test-c>c</r.Panel>
              {{/if}}
            </Resizable>
          </div>
        </template>
      );

      assert.dom('[data-test-handle]').hasAria('valuenow', '50');

      state.showThird = true;
      await settled();

      assert.dom('[data-test-handle]').hasAria('valuenow', '33');
      assert.dom('[data-test-handle-2]').hasAria('valuenow', '33');

      const a = widthOf('[data-test-a]');
      const c = widthOf('[data-test-c]');

      assert.ok(closeTo(a, c), `a (${a}px) and c (${c}px) are the same size`);
    });

    test('removing a panel gives its space back proportionally', async function (assert) {
      class State {
        @tracked showThird = true;
      }

      const state = new State();

      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
              {{#if state.showThird}}
                <r.Handle data-test-handle-2 />
                <r.Panel data-test-c>c</r.Panel>
              {{/if}}
            </Resizable>
          </div>
        </template>
      );

      assert.dom('[data-test-handle]').hasAria('valuenow', '33');

      state.showThird = false;
      await settled();

      assert.dom('[data-test-c]').doesNotExist();
      assert.dom('[data-test-handle]').hasAria('valuenow', '50');

      const a = widthOf('[data-test-a]');
      const b = widthOf('[data-test-b]');

      assert.ok(closeTo(a, b), `a (${a}px) and b (${b}px) split the space again`);
    });
  });

  module('@onLayoutChange', function () {
    test('reports sizes when the layout changes', async function (assert) {
      let latest: number[] = [];
      const onLayoutChange = (sizes: number[]) => {
        latest = sizes;
        assert.step('layout-changed');
      };

      await render(
        <template>
          {{! template-lint-disable no-inline-styles }}
          <div style="width: 508px; height: 200px;">
            <Resizable @onLayoutChange={{onLayoutChange}} as |r|>
              <r.Panel data-test-a>a</r.Panel>
              <r.Handle data-test-handle />
              <r.Panel data-test-b>b</r.Panel>
            </Resizable>
          </div>
        </template>
      );

      assert.verifySteps(['layout-changed'], 'initial layout is reported');

      await triggerKeyEvent('[data-test-handle]', 'keydown', 'ArrowRight');

      assert.verifySteps(['layout-changed'], 'keyboard resize is reported');
      assert.deepEqual(
        latest.map((size) => Math.round(size)),
        [51, 49]
      );
    });
  });
});
