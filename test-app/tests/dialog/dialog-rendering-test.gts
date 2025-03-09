/* global out */
import { tracked } from '@glimmer/tracking';
import { assert as debugAssert } from '@ember/debug';
import { on } from '@ember/modifier';
import { click, find, render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Modal } from 'ember-primitives';

module('Rendering | dialog', function (hooks) {
  setupRenderingTest(hooks);

  async function close() {
    // We don't need to test "escape" because the browser already has
    // tests for that for us. So we can instead call the dialog's close method
    find('dialog')?.close();
    // NOTE: headless chrome has either:
    //       inconsistent timings, or is so fast, we actually do have a timing issue.
    //       TODO: consider how to tie the waiter system to the dialog close status
    await new Promise((resolve) => requestAnimationFrame(resolve));
    await settled();
  }

  function assertFind(selector: string) {
    const el = find(selector);

    debugAssert(`Expected ${selector} to exist`, el);

    return el;
  }

  module('preferred usage', function () {
    test('can be open', async function (assert) {
      await render(
        <template>
          <Modal as |m|>
            <out>{{m.isOpen}}</out>
            <button type="button" {{on "click" m.open}}>Open Dialog</button>
            <m.Dialog>
              content
            </m.Dialog>
          </Modal>
        </template>
      );

      assert.dom('dialog').exists();
      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');

      await click('button');

      // Default display, per dialog spec
      assert.dom('dialog').hasStyle({ display: 'block' });
      assert.dom('out').hasText('true');
    });

    test('can be closed', async function (assert) {
      await render(
        <template>
          <Modal as |m|>
            <out>{{m.isOpen}}</out>
            <button id="open" type="button" {{on "click" m.open}} {{m.focusOnClose}}>Open Dialog</button>
            <m.Dialog>
              content
              <button id="close" type="button" {{on "click" m.close}}>Close Dialog</button>
            </m.Dialog>
          </Modal>
        </template>
      );

      await click('#open');

      // Default display, per dialog spec
      assert.dom('dialog').hasStyle({ display: 'block' });
      assert.dom('out').hasText('true');

      await click('#close');
      await new Promise((resolve) => requestAnimationFrame(resolve));
      await settled();

      assert.strictEqual(document.activeElement, assertFind('#open'));
      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');
    });

    test('can be closed via the ESC key', async function (assert) {
      await render(
        <template>
          <Modal as |m|>
            <out>{{m.isOpen}}</out>
            <button id="open" type="button" {{on "click" m.open}} {{m.focusOnClose}}>Open Dialog</button>
            <m.Dialog>
              content
            </m.Dialog>
          </Modal>
        </template>
      );

      await click('#open');

      // Default display, per dialog spec
      assert.dom('dialog').hasStyle({ display: 'block' });
      assert.dom('out').hasText('true');

      await close();

      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');
      assert.strictEqual(document.activeElement, assertFind('#open'));
    });

    test('@onClose is called', async function (assert) {
      const handleClose = (reason: string) => assert.step(`closed ${reason}`);

      await render(
        <template>
          <Modal @onClose={{handleClose}} as |m|>
            <out>{{m.isOpen}}</out>
            <button id="open" type="button" {{on "click" m.open}} {{m.focusOnClose}}>Open Dialog</button>
            <m.Dialog>
              content
              <form method="dialog">
                <button value="resetBtn" type="submit" {{on "click" m.close}}>Reset</button>
                <button type="submit" value="confirmBtn">Confirm</button>
              </form>
            </m.Dialog>
          </Modal>
        </template>
      );

      await click('#open');
      await close();
      assert.verifySteps(['closed '], 'no reason given');

      await click('#open');
      assert.notEqual(document.activeElement, assertFind('#open'));

      await click('[value=confirmBtn]');
      await new Promise((resolve) => requestAnimationFrame(resolve));
      await settled();
      assert.verifySteps(['closed confirmBtn'], 'a reason given');
      assert.strictEqual(document.activeElement, assertFind('#open'));

      await click('#open');
      assert.notEqual(document.activeElement, assertFind('#open'));

      await close();
      assert.verifySteps(['closed '], 'no reason given');
      assert.strictEqual(document.activeElement, assertFind('#open'));

      await click('#open');
      assert.notEqual(document.activeElement, assertFind('#open'));

      await click('[value=resetBtn]');
      await new Promise((resolve) => requestAnimationFrame(resolve));
      await settled();
      assert.verifySteps(['closed '], 'a reason given');
      assert.strictEqual(document.activeElement, assertFind('#open'));
    });
  });

  module('when setting the initial state', function () {
    test('starts open', async function (assert) {
      await render(
        <template>
          <Modal @open={{true}} as |m|>
            <out>{{m.isOpen}}</out>
            <button id="open" type="button" {{on "click" m.open}} {{m.focusOnClose}}>Open Dialog</button>
            <m.Dialog> content </m.Dialog>
          </Modal>
        </template>
      );

      assert.dom('dialog').hasStyle({ display: 'block' });
      assert.dom('out').hasText('true');
      assert.notEqual(document.activeElement, assertFind('#open'));

      await close();
      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');
      assert.strictEqual(document.activeElement, assertFind('#open'));

      await click('button');
      assert.dom('dialog').hasStyle({ display: 'block' });
      assert.dom('out').hasText('true');
      assert.notEqual(document.activeElement, assertFind('#open'));

      await close();
      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');
      assert.strictEqual(document.activeElement, assertFind('#open'));
    });

    test('@open can change, as will the dialog state', async function (assert) {
      class Controlled {
        @tracked open = false;
      }

      const state = new Controlled();

      await render(
        <template>
          <Modal @open={{state.open}} as |m|>
            <out>{{m.isOpen}}</out>
            <m.Dialog> content </m.Dialog>
          </Modal>
        </template>
      );

      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');

      state.open = true;
      await settled();

      assert.dom('dialog').hasStyle({ display: 'block' });
      assert.dom('out').hasText('true');

      state.open = false;
      await settled();

      assert.dom('dialog').hasStyle({ display: 'none' });
      assert.dom('out').hasText('false');
    });
  });
});
