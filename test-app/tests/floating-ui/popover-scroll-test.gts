import { assert as debugAssert } from '@ember/debug';
import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Popover } from 'ember-primitives';

import { resetTestingContainerDimensions } from './test-helpers';

/**
 * #ember-testing has a transform, which makes it the containing block
 * for fixed elements. The body is what is relative to the viewport.
 */
const body = document.body;

const SCROLLS = [12, 24, 36, 48];

/**
 * Positioning is async, and test waiters do not track it.
 */
async function positioned() {
  await new Promise(requestAnimationFrame);
  await new Promise(requestAnimationFrame);
  await settled();
}

function elementOf(selector: string) {
  const element = body.querySelector(selector);

  debugAssert(`Could not find element with '${selector}'`, element);

  return element;
}

function rectOf(selector: string) {
  return elementOf(selector).getBoundingClientRect();
}

/**
 * Waits for one frame only, so that a late correction fails the test.
 */
async function scrollFrame(selector: string, position: { top?: number; left?: number }) {
  const element = elementOf(selector);

  element.scrollTop = position.top ?? element.scrollTop;
  element.scrollLeft = position.left ?? element.scrollLeft;

  await new Promise(requestAnimationFrame);
  await new Promise(requestAnimationFrame);
}

async function scrollSettled(selector: string, position: { top?: number; left?: number }) {
  await scrollFrame(selector, position);
  await positioned();
  await positioned();
}

function centerOf(selector: string) {
  const rect = rectOf(selector);

  return { x: rect.left + rect.width / 2, y: rect.top + rect.height / 2 };
}

module('<Popover> during a scroll', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('stays on its reference', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 300px;"></div>
            <Popover @placement="top" @offsetOptions={{8}} as |p|>
              <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >content</p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const top of SCROLLS) {
      await scrollFrame('#scroller', { top });

      assert.strictEqual(rectOf('#anchor').top - rectOf('#content').bottom, 8, `at ${top}`);
    }
  });

  test('stays on its reference for a horizontal scroll', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="width: 5000px; height: 300px;"></div>
            <div style="margin-left: 500px;">
              <Popover as |p|>
                <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
                <p.Content
                  id="content"
                  style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                >content</p.Content>
              </Popover>
            </div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const left of SCROLLS) {
      await scrollFrame('#scroller', { left });

      assert.strictEqual(centerOf('#content').x, centerOf('#anchor').x, `at ${left}`);
    }
  });

  test('stays on a sticky reference', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div
            id="scroller"
            style="position: fixed; top: 100px; left: 100px; width: 400px; height: 300px; overflow: auto; background: white;"
          >
            <Popover @offsetOptions={{8}} as |p|>
              <header style="position: sticky; top: 0; height: 40px;">
                <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              </header>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >content</p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const top of SCROLLS) {
      await scrollFrame('#scroller', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').bottom, 8, `at ${top}`);
    }
  });

  test('stays on a reference in two scrollers', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 200px;"></div>
            <div id="inner" style="height: 300px; overflow: auto;">
              <div style="height: 100px;"></div>
              <Popover @offsetOptions={{8}} as |p|>
                <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
                <p.Content
                  id="content"
                  style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                >content</p.Content>
              </Popover>
              <div style="height: 1000px;"></div>
            </div>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const top of SCROLLS) {
      await scrollFrame('#inner', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').bottom, 8, `inner at ${top}`);

      await scrollFrame('#scroller', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').bottom, 8, `outer at ${top}`);
    }
  });

  test('the arrow stays on the popover', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 300px;"></div>
            <Popover @placement="top" @offsetOptions={{8}} as |p|>
              <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >
                <div
                  id="arrow"
                  style="position: absolute; width: 8px; height: 8px; background: red;"
                  {{p.arrow}}
                ></div>
              </p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const top of SCROLLS) {
      await scrollFrame('#scroller', { top });

      assert.strictEqual(centerOf('#arrow').y, rectOf('#content').bottom, `edge at ${top}`);
      assert.strictEqual(centerOf('#arrow').x, centerOf('#anchor').x, `center at ${top}`);
    }
  });

  test('the arrow stays on a popover at the side', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 300px;"></div>
            <Popover @placement="right" @offsetOptions={{8}} as |p|>
              <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >
                <div
                  id="arrow"
                  style="position: absolute; width: 8px; height: 8px; background: red;"
                  {{p.arrow}}
                ></div>
              </p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const top of SCROLLS) {
      await scrollFrame('#scroller', { top });

      assert.strictEqual(centerOf('#arrow').x, rectOf('#content').left, `edge at ${top}`);
      assert.strictEqual(centerOf('#arrow').y, centerOf('#anchor').y, `center at ${top}`);
    }
  });
});

module('nested <Popover>', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('only the outer popover is in the top layer', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover as |p|>
            <div
              id="outer-anchor"
              style="position: fixed; top: 100px; left: 300px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content id="outer" style="margin: 0; padding: 0; border: none; width: 200px;">
              <Popover as |pp|>
                <div id="anchor" style="width: 40px; height: 20px;" {{pp.reference}}></div>
                <pp.Content id="content" style="margin: 0; padding: 0; border: none;">
                  content
                </pp.Content>
              </Popover>
            </p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.dom('#outer', body).hasAttribute('popover');
    assert.dom('#content', body).doesNotHaveAttribute('popover');
  });

  test('sits on its own reference', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover as |p|>
            <div
              id="outer-anchor"
              style="position: fixed; top: 100px; left: 300px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="outer"
              style="margin: 0; padding: 0; border: none; width: 200px; height: 100px;"
            >
              <Popover @placement="right" @offsetOptions={{16}} as |pp|>
                <div id="anchor" style="width: 40px; height: 20px;" {{pp.reference}}></div>
                <pp.Content
                  id="content"
                  style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                >content</pp.Content>
              </Popover>
            </p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(rectOf('#content').left, rectOf('#anchor').right + 16);
    assert.strictEqual(centerOf('#content').y, centerOf('#anchor').y);
  });

  test('stays on its reference during a scroll', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 100px;"></div>
            <Popover as |p|>
              <div id="outer-anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content
                id="outer"
                style="margin: 0; padding: 0; border: none; width: 200px; height: 100px;"
              >
                <Popover @placement="right" as |pp|>
                  <div id="anchor" style="width: 40px; height: 20px;" {{pp.reference}}></div>
                  <pp.Content
                    id="content"
                    style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                  >content</pp.Content>
                </Popover>
              </p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    const start = rectOf('#content').top - rectOf('#anchor').top;

    for (const top of SCROLLS) {
      await scrollSettled('#scroller', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').top, start, `at ${top}`);
      assert.strictEqual(rectOf('#outer').top, rectOf('#outer-anchor').bottom, `outer at ${top}`);
    }
  });

  test('stays on its reference when the outer reference is sticky', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="page" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 100px;"></div>
            <div id="scroller" style="height: 300px; width: 500px; overflow: auto;">
              <Popover as |p|>
                <header style="position: sticky; top: 0; height: 40px;">
                  <div id="outer-anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
                </header>
                <p.Content
                  id="outer"
                  style="margin: 0; padding: 0; border: none; width: 200px; height: 100px;"
                >
                  <Popover @placement="right" as |pp|>
                    <div id="anchor" style="width: 40px; height: 20px;" {{pp.reference}}></div>
                    <pp.Content
                      id="content"
                      style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                    >content</pp.Content>
                  </Popover>
                </p.Content>
              </Popover>
              <div style="height: 3000px;"></div>
            </div>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    const start = rectOf('#content').top - rectOf('#anchor').top;

    for (const top of SCROLLS) {
      await scrollSettled('#scroller', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').top, start, `inner at ${top}`);

      await scrollSettled('#page', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').top, start, `page at ${top}`);
    }
  });

  test('stays on its reference three levels deep', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 100px;"></div>
            <Popover as |p|>
              <div id="first-anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content style="margin: 0; padding: 0; border: none; width: 200px; height: 60px;">
                <Popover @placement="right" as |pp|>
                  <div id="second-anchor" style="width: 40px; height: 20px;" {{pp.reference}}></div>
                  <pp.Content
                    style="margin: 0; padding: 0; border: none; width: 100px; height: 60px;"
                  >
                    <Popover @placement="right" as |ppp|>
                      <div id="anchor" style="width: 40px; height: 20px;" {{ppp.reference}}></div>
                      <ppp.Content
                        id="content"
                        style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                      >content</ppp.Content>
                    </Popover>
                  </pp.Content>
                </Popover>
              </p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    const start = rectOf('#content').top - rectOf('#anchor').top;

    for (const top of SCROLLS) {
      await scrollSettled('#scroller', { top });

      assert.strictEqual(rectOf('#content').top - rectOf('#anchor').top, start, `at ${top}`);
    }
  });

  test('its arrow stays on it during a scroll', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 100px;"></div>
            <Popover as |p|>
              <div id="outer-anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content
                id="outer"
                style="margin: 0; padding: 0; border: none; width: 200px; height: 100px;"
              >
                <Popover @placement="right" @offsetOptions={{8}} as |pp|>
                  <div id="anchor" style="width: 40px; height: 20px;" {{pp.reference}}></div>
                  <pp.Content
                    id="content"
                    style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
                  >
                    <div
                      id="arrow"
                      style="position: absolute; width: 8px; height: 8px; background: red;"
                      {{pp.arrow}}
                    ></div>
                  </pp.Content>
                </Popover>
              </p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    for (const top of SCROLLS) {
      await scrollSettled('#scroller', { top });

      assert.strictEqual(centerOf('#arrow').x, rectOf('#content').left, `edge at ${top}`);
      assert.strictEqual(centerOf('#arrow').y, centerOf('#anchor').y, `center at ${top}`);
    }
  });
});
