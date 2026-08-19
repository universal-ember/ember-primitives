import { on } from '@ember/modifier';
import { click, find, render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Dialog } from 'ember-primitives';

/**
 * The `close` event is queued as a task, and headless Chrome's timings around
 * it are inconsistent -- the same wait `<Modal>`'s own tests use.
 */
async function closeNatively() {
  find('dialog')?.close();
  await new Promise((resolve) => requestAnimationFrame(resolve));
  await settled();
}

module('Rendering | <Dialog>', function (hooks) {
  setupRenderingTest(hooks);

  test('it renders a closed dialog around its block', async function (assert) {
    await render(
      <template>
        <Dialog>
          content
        </Dialog>
      </template>
    );

    assert.dom('dialog').exists({ count: 1 });
    assert.dom('dialog').doesNotHaveAttribute('open');
    assert.dom('dialog').hasText('content');
  });

  test('closedby is the browser default until a caller says otherwise', async function (assert) {
    await render(
      <template>
        <Dialog>x</Dialog>
        <Dialog closedby="any">y</Dialog>
      </template>
    );

    const dialogs = document.querySelectorAll('dialog');

    assert.dom(dialogs[0]).doesNotHaveAttribute('closedby');
    assert.dom(dialogs[1]).hasAttribute('closedby', 'any');
  });

  test('open and close drive it', async function (assert) {
    await render(
      <template>
        <Dialog as |d|>
          <button id="close" type="button" {{on "click" d.close}}>Close</button>

          <button id="open" type="button" {{on "click" d.open}}>Open</button>
        </Dialog>
      </template>
    );

    assert.dom('dialog').doesNotHaveAttribute('open');

    await click('#open');
    assert.dom('dialog').hasAttribute('open');
    assert.dom('dialog').hasStyle({ display: 'block' }, 'it is modal, not inline');

    await click('#close');
    assert.dom('dialog').doesNotHaveAttribute('open');
  });

  test('opening twice and closing twice is not an error', async function (assert) {
    await render(
      <template>
        <Dialog as |d|>
          <button id="close" type="button" {{on "click" d.close}}>Close</button>

          <button id="open" type="button" {{on "click" d.open}}>Open</button>
        </Dialog>
      </template>
    );

    // `close` on a closed dialog, before it has ever opened
    await click('#close');
    assert.dom('dialog').doesNotHaveAttribute('open');

    await click('#open');
    await click('#open');
    assert.dom('dialog').hasAttribute('open');

    await click('#close');
    await click('#close');
    assert.dom('dialog').doesNotHaveAttribute('open');
  });

  test('closing without us, then opening again', async function (assert) {
    await render(
      <template>
        <Dialog as |d|>
          <button id="open" type="button" {{on "click" d.open}}>Open</button>
        </Dialog>
      </template>
    );

    await click('#open');
    assert.dom('dialog').hasAttribute('open');

    // Escape and a click on the backdrop are the browser's; both end here
    await closeNatively();
    assert.dom('dialog').doesNotHaveAttribute('open');

    await click('#open');
    assert.dom('dialog').hasAttribute('open');
  });

  test('attributes reach the dialog element', async function (assert) {
    await render(
      <template>
        <Dialog class="mine" data-thing="x">content</Dialog>
      </template>
    );

    assert.dom('dialog').hasClass('mine');
    assert.dom('dialog').hasAttribute('data-thing', 'x');
  });
});
