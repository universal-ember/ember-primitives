import { assert as debugAssert } from '@ember/debug';
import { hash } from '@ember/helper';
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

/**
 * Positioning is async, and test waiters do not track it.
 */
async function positioned() {
  await new Promise(requestAnimationFrame);
  await new Promise(requestAnimationFrame);
  await settled();
}

async function scrollTo(selector: string, top: number) {
  const element = body.querySelector(selector);

  debugAssert(`Could not find element with '${selector}'`, element);

  await new Promise((resolve) => {
    element.addEventListener('scroll', resolve, { once: true });
    element.scrollTop = top;
  });
  await positioned();
  await positioned();
}

function rectOf(selector: string) {
  const element = body.querySelector(selector);

  debugAssert(`Could not find element with '${selector}'`, element);

  return element.getBoundingClientRect();
}

function side() {
  const content = rectOf('#content');
  const anchor = rectOf('#anchor');

  if (content.bottom <= anchor.top) return 'above';
  if (content.top >= anchor.bottom) return 'below';

  return 'overlap';
}

module('<Popover> flipping', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  test('stays in place when nothing overflows', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'above');
  });

  test('flips when a scroll container clips the anchor', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div
            id="scroller"
            style="position: absolute; top: 200px; left: 200px; width: 200px; height: 100px; overflow: auto;"
          >
            <div style="height: 100px;"></div>
            <Popover @placement="top" as |p|>
              <div id="anchor" style="width: 100px; height: 40px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >content</p.Content>
            </Popover>
            <div style="height: 200px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'above', 'the anchor is not clipped yet');

    await scrollTo('#scroller', 110);

    assert.strictEqual(side(), 'below', 'the anchor is clipped at the top');
  });

  test('elementContext can opt out of the anchor check', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div
            id="scroller"
            style="position: absolute; top: 200px; left: 200px; width: 200px; height: 100px; overflow: auto;"
          >
            <div style="height: 100px;"></div>
            <Popover @placement="top" @flipOptions={{hash elementContext="floating"}} as |p|>
              <div id="anchor" style="width: 100px; height: 40px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >content</p.Content>
            </Popover>
            <div style="height: 200px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    await scrollTo('#scroller', 110);

    assert.strictEqual(side(), 'above');
  });

  test('elementContext can opt out of the popover check', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" @flipOptions={{hash elementContext="reference"}} as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 4px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.notStrictEqual(side(), 'below');
  });

  test('flips when a page scroll pushes the popover out of the viewport', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 200px;"></div>
            <Popover @placement="top" @flipOptions={{hash elementContext="floating"}} as |p|>
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

    assert.strictEqual(side(), 'above');

    await scrollTo('#scroller', 195);

    assert.strictEqual(side(), 'below');
  });

  test('stays on the same side when a scroll moves it past the edge', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 300px;"></div>
            <Popover @placement="right" as |p|>
              <div id="anchor" style="width: 100px; height: 20px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 200px;"
              >content</p.Content>
            </Popover>
            <div style="height: 3000px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();
    await scrollTo('#scroller', 290);

    const content = rectOf('#content');
    const anchor = rectOf('#anchor');

    assert.strictEqual(content.left, anchor.right, 'the popover is on the right');
    assert.ok(content.top >= 0, 'the popover is inside of the viewport');
  });

  test('leaves a flipped side when that side has no room', async function (assert) {
    const viewport = window.innerHeight;

    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 300px;"></div>
            <Popover @placement="top" @flipOptions={{hash elementContext="floating"}} as |p|>
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
    await scrollTo('#scroller', 295);

    assert.strictEqual(side(), 'below', 'flips at the top of the viewport');

    const spacer = body.querySelector('#scroller > div') as HTMLElement;

    spacer.style.height = `${viewport - 25}px`;
    await positioned();
    await scrollTo('#scroller', 1);

    assert.strictEqual(side(), 'above', 'flips back at the bottom of the viewport');
  });

  test('moves along the reference to stay in the viewport', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 2px; width: 20px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 200px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(rectOf('#content').left, 0);
    assert.strictEqual(side(), 'above');
  });

  test('a popover that is wider than its reference does not wrap', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 300px; width: 20px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content id="content" style="margin: 0; padding: 0; border: none;">
              a line of text that is much wider than the reference
            </p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.ok(rectOf('#content').width > 100);
    assert.ok(rectOf('#content').height < 40);
  });

  test('flips to the other alignment at a viewport edge', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top-start" @flipOptions={{hash elementContext="floating"}} as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; right: 20px; width: 40px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 200px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(rectOf('#content').right, rectOf('#anchor').right);
  });

  test('the offset is on the side of the reference after a flip', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover
            @placement="top"
            @offsetOptions={{8}}
            @flipOptions={{hash elementContext="floating"}}
            as |p|
          >
            <div
              id="anchor"
              style="position: fixed; top: 4px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(rectOf('#content').top, rectOf('#anchor').bottom + 8);
  });

  test('flipOptions.padding reserves space for a sticky header', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover
            @placement="top"
            @flipOptions={{hash elementContext="floating" padding=(hash top=64)}}
            as |p|
          >
            <div
              id="anchor"
              style="position: fixed; top: 80px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
            >content</p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'below');
  });

  test('hides when a scroll container clips all of the anchor', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div
            id="scroller"
            style="position: absolute; top: 200px; left: 200px; width: 200px; height: 100px; overflow: auto;"
          >
            <div style="height: 10px;"></div>
            <Popover as |p|>
              <div id="anchor" style="width: 100px; height: 40px;" {{p.reference}}></div>
              <p.Content
                id="content"
                style="margin: 0; padding: 0; border: none; width: 80px; height: 30px;"
              >content</p.Content>
            </Popover>
            <div style="height: 300px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.dom('#content', body).isVisible();

    await scrollTo('#scroller', 100);

    assert.dom('#content', body).hasStyle({ visibility: 'hidden' });

    await scrollTo('#scroller', 0);

    assert.dom('#content', body).hasStyle({ visibility: 'visible' });
  });
});

module('<Popover> arrow', function (hooks) {
  setupRenderingTest(hooks);

  hooks.beforeEach(function () {
    resetTestingContainerDimensions();
  });

  function arrowCenter() {
    const arrow = rectOf('#arrow');

    return { x: arrow.left + arrow.width / 2, y: arrow.top + arrow.height / 2 };
  }

  function anchorCenter() {
    const anchor = rectOf('#anchor');

    return { x: anchor.left + anchor.width / 2, y: anchor.top + anchor.height / 2 };
  }

  test('points at the reference from the side of the placement', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" @offsetOptions={{8}} as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
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
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(arrowCenter().x, anchorCenter().x);
    assert.strictEqual(arrowCenter().y, rectOf('#content').bottom);
  });

  test('moves to the other edge after a flip', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover
            @placement="top"
            @offsetOptions={{8}}
            @flipOptions={{hash elementContext="floating"}}
            as |p|
          >
            <div
              id="anchor"
              style="position: fixed; top: 4px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
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
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(side(), 'below');
    assert.strictEqual(arrowCenter().x, anchorCenter().x);
    assert.strictEqual(arrowCenter().y, rectOf('#content').top);
  });

  test('stays on the reference during a scroll', async function (assert) {
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
    await scrollTo('#scroller', 100);

    assert.strictEqual(side(), 'above');
    assert.strictEqual(arrowCenter().x, anchorCenter().x);
    assert.strictEqual(arrowCenter().y, rectOf('#content').bottom);
  });

  test('moves to the other edge after a flip from a scroll', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div id="scroller" style="position: fixed; inset: 0; overflow: auto; background: white;">
            <div style="height: 300px;"></div>
            <Popover
              @placement="top"
              @offsetOptions={{8}}
              @flipOptions={{hash elementContext="floating"}}
              as |p|
            >
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
    await scrollTo('#scroller', 295);

    assert.strictEqual(side(), 'below');
    assert.strictEqual(arrowCenter().x, anchorCenter().x);
    assert.strictEqual(arrowCenter().y, rectOf('#content').top);
  });

  test('flips with the popover for a clipped reference', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <div
            id="scroller"
            style="position: absolute; top: 200px; left: 200px; width: 200px; height: 100px; overflow: auto;"
          >
            <div style="height: 100px;"></div>
            <Popover @placement="top" @offsetOptions={{8}} as |p|>
              <div id="anchor" style="width: 100px; height: 40px;" {{p.reference}}></div>
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
            <div style="height: 200px;"></div>
          </div>
        {{/in-element}}
      </template>
    );
    await positioned();
    await scrollTo('#scroller', 110);

    assert.strictEqual(side(), 'below');
    assert.strictEqual(arrowCenter().y, rectOf('#content').top);
  });

  test('follows the reference when the popover shifts', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="top" as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 2px; width: 20px; height: 20px;"
              {{p.reference}}
            ></div>
            <p.Content
              id="content"
              style="margin: 0; padding: 0; border: none; width: 200px; height: 30px;"
            >
              <div
                id="arrow"
                style="position: absolute; width: 8px; height: 8px; background: red;"
                {{p.arrow}}
              ></div>
            </p.Content>
          </Popover>
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(rectOf('#content').left, 0);
    assert.strictEqual(arrowCenter().x, anchorCenter().x);
  });

  test('is on the facing edge for side placements', async function (assert) {
    await render(
      <template>
        {{#in-element body insertBefore=null}}
          <Popover @placement="right" @offsetOptions={{8}} as |p|>
            <div
              id="anchor"
              style="position: fixed; top: 200px; left: 200px; width: 100px; height: 20px;"
              {{p.reference}}
            ></div>
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
        {{/in-element}}
      </template>
    );
    await positioned();

    assert.strictEqual(arrowCenter().x, rectOf('#content').left);
    assert.strictEqual(arrowCenter().y, anchorCenter().y);
  });
});
