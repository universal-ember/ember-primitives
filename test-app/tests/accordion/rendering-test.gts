import { array } from '@ember/helper';
import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Accordion } from 'ember-primitives';

module('Rendering | <Accordion>', function (hooks) {
  setupRenderingTest(hooks);

  module('single accordion', function () {
    module('clicking a trigger', function (hooks) {
      hooks.beforeEach(async function () {
        await render(<template>
          <Accordion @type='single' as |A|>
            <A.Item @value='item-1' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value='item-2' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);
      });

      test('it shows the content', async function (assert) {
        assert.dom('[data-test-content-1]').isNotVisible();
        await click('[data-test-trigger-1]');
        assert.dom('[data-test-content-1]').isVisible();
      });

      module('clicking the trigger again', function () {
        test('it does not hide the content', async function (assert) {
          assert.dom('[data-test-content-1]').isNotVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
        });
      });

      module('clicking a different trigger', function () {
        test('it hides the previous content', async function (assert) {
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });

        test('it shows the new content', async function (assert) {
          await click('[data-test-trigger-1]');
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-2]').isVisible();
        });
      });
    });

    module('with a defaultValue', function (hooks) {
      hooks.beforeEach(async function () {
        await render(<template>
          <Accordion @type='single' @defaultValue='item-1' as |A|>
            <A.Item @value='item-1' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value='item-2' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);
      });

      test('it shows the defaultValue', async function (assert) {
        assert.dom('[data-test-content-1]').isVisible();
      });

      module("clicking the defaultValue's trigger", function () {
        test("does not hide the defaultValue's content", async function (assert) {
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
        });
      });

      module("clicking a non-defaultValue's trigger", function () {
        test('shows the new content', async function (assert) {
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-2]').isVisible();
        });

        test("hides the defaultValue's content", async function (assert) {
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });
      });
    });

    module('collapsible', function (hooks) {
      hooks.beforeEach(async function () {
        await render(<template>
          <Accordion @type='single' @collapsible={{true}} as |A|>
            <A.Item @value='item-1' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value='item-2' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);
      });

      module('clicking a trigger', function () {
        test('it shows the content', async function (assert) {
          assert.dom('[data-test-content-1]').isNotVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
        });

        module('clicking the trigger again', function () {
          test('it hides the content', async function (assert) {
            assert.dom('[data-test-content-1]').isNotVisible();
            await click('[data-test-trigger-1]');
            assert.dom('[data-test-content-1]').isVisible();
            await click('[data-test-trigger-1]');
            assert.dom('[data-test-content-1]').isNotVisible();
          });
        });
      });

      module('with a defaultValue', function (hooks) {
        hooks.beforeEach(async function () {
          await render(<template>
            <Accordion @type='single' @defaultValue='item-1' @collapsible={{true}} as |A|>
              <A.Item @value='item-1' as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
                </I.Header>
                <I.Content data-test-content-1>Content 1</I.Content>
              </A.Item>
              <A.Item @value='item-2' as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
                </I.Header>
                <I.Content data-test-content-2>Content 2</I.Content>
              </A.Item>
            </Accordion>
          </template>);
        });

        test('clicking the defaultValue hides the content', async function (assert) {
          assert.dom('[data-test-content-1]').isVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });
      });
    });
  });

  module('multiple accordion', function () {
    module('clicking a trigger', function (hooks) {
      hooks.beforeEach(async function () {
        await render(<template>
          <Accordion @type='multiple' as |A|>
            <A.Item @value='item-1' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value='item-2' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);
      });

      test('it shows the content', async function (assert) {
        assert.dom('[data-test-content-1]').isNotVisible();
        await click('[data-test-trigger-1]');
        assert.dom('[data-test-content-1]').isVisible();
      });

      module('clicking the trigger again', function () {
        test('it hides the content', async function (assert) {
          assert.dom('[data-test-content-1]').isNotVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });
      });

      module('clicking a different trigger', function () {
        test('it shows the new content', async function (assert) {
          await click('[data-test-trigger-1]');
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-2]').isVisible();
        });

        test('it does not hide the previous content', async function (assert) {
          await click('[data-test-trigger-1]');
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-1]').isVisible();
        });
      });
    });

    module('with a defaultValue', function (hooks) {
      hooks.beforeEach(async function () {
        await render(<template>
          <Accordion @type='multiple' @defaultValue={{array 'item-1' 'item-2'}} as |A|>
            <A.Item @value='item-1' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value='item-2' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
            <A.Item @value='item-3' as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-3>Trigger 3</H.Trigger>
              </I.Header>
              <I.Content data-test-content-3>Content 3</I.Content>
            </A.Item>
          </Accordion>
        </template>);
      });

      test('it shows the defaultValue', async function (assert) {
        assert.dom('[data-test-content-1]').isVisible();
        assert.dom('[data-test-content-2]').isVisible();
      });

      module("clicking one of the defaultValue's triggers", function () {
        test("hides the defaultValue's content", async function (assert) {
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isNotVisible();
          assert.dom('[data-test-content-2]').isVisible();
        });
      });

      module("clicking a non-defaultValue's trigger", function () {
        test('shows the new content', async function (assert) {
          await click('[data-test-trigger-3]');
          assert.dom('[data-test-content-3]').isVisible();
        });

        test("does not hide the defaultValue's content", async function (assert) {
          await click('[data-test-trigger-3]');
          assert.dom('[data-test-content-1]').isVisible();
          assert.dom('[data-test-content-2]').isVisible();
        });
      });
    });
  });
});
