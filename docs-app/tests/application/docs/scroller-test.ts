import { assert } from '@ember/debug';
import { click, find, findAll, settled, visit, waitUntil } from '@ember/test-helpers';
import QUnit, { module, test } from 'qunit';
import { setupApplicationTest } from 'ember-qunit';

function buttonByText(text: string) {
  const searchFor = text.trim();
  const allButtons = findAll('button');
  const found = allButtons.find((button) => button.innerText.includes(searchFor));

  assert(`Did not find button with text ${text}`, found);

  return found;
}

function getScrollPosition(element?: Element | null) {
  assert('Could not find scroller', element);

  return {
    x: element.scrollLeft,
    y: element.scrollTop,
  };
}

function getLeft(element?: Element | null) {
  assert('Could not find scroller', element);

  return element.scrollWidth - element.clientWidth;
}

function getTop(element?: Element | null) {
  assert('Could not find scroller', element);

  return element.scrollHeight - element.clientHeight;
}

async function rafSettled() {
  // because of behavior: smooth
  await new Promise((resolve) => setTimeout(resolve, 100));
  await new Promise(requestAnimationFrame);
  await settled();
}

function isCloseEnough(actual: { x: number; y: number }, expected: { x: number; y: number }) {
  const xDelta = actual.x - expected.x;
  const yDelta = actual.y - expected.y;

  QUnit.assert.ok(xDelta < 5 || xDelta > -5, `|x| delta is < 5`);
  QUnit.assert.ok(yDelta < 5 || yDelta > -5, `|y| delta is < 5`);
}

module('Docs: Scroller', function (hooks) {
  setupApplicationTest(hooks);

  test('the 4 buttons work as expected', async function (assert) {
    await visit('/6-utils/scroller');
    await waitUntil(() => find('.glimdown-render'));

    const left = buttonByText('⬅️ ');
    const down = buttonByText('⬇️ ');
    const up = buttonByText('⬆️ ');
    const right = buttonByText('➡️ ');

    const scroller = find('.demo .container');

    assert.deepEqual(getScrollPosition(scroller), { x: 0, y: 0 });

    const maxLeft = getLeft(scroller);
    const maxTop = getTop(scroller);

    await click(right);
    await rafSettled();
    isCloseEnough(getScrollPosition(scroller), { x: maxLeft, y: 0 });

    await click(left);
    await rafSettled();
    isCloseEnough(getScrollPosition(scroller), { x: 0, y: 0 });

    await click(down);
    await rafSettled();
    isCloseEnough(getScrollPosition(scroller), { x: 0, y: maxTop });

    await click(right);
    await rafSettled();
    isCloseEnough(getScrollPosition(scroller), { x: maxLeft, y: maxTop });

    await click(up);
    await rafSettled();
    isCloseEnough(getScrollPosition(scroller), { x: maxLeft, y: 0 });

    await click(down);
    await rafSettled();
    isCloseEnough(getScrollPosition(scroller), { x: maxLeft, y: maxTop });
  });
});
