import { click, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Accordion } from 'ember-primitives';

module('Rendering | <Accordion>', function(hooks) {
  setupRenderingTest(hooks);

  module('single accordion', function () {
    module('clicking a trigger', function () {
      test('it shows the content', async function(assert) {
        await render(<template>
          <Accordion @type="single" as |A|>
            <A.Item @value="item-1" as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value="item-2" as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);

        assert.dom('[data-test-content-1]').isNotVisible();
        await click('[data-test-trigger-1]');
        assert.dom('[data-test-content-1]').isVisible();
      });

      module('clicking the trigger again', function () {
        test('it hides the content', async function(assert) {
          await render(<template>
            <Accordion @type="single" as |A|>
              <A.Item @value="item-1" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
                </I.Header>
                <I.Content data-test-content-1>Content 1</I.Content>
              </A.Item>
              <A.Item @value="item-2" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 2</H.Trigger>
                </I.Header>
                <I.Content data-test-content-2>Content 2</I.Content>
              </A.Item>
            </Accordion>
          </template>);

          assert.dom('[data-test-content-1]').isNotVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });
      });

      module('clicking a different trigger', function () {
        test('it hides the previous content', async function(assert) {
          await render(<template>
            <Accordion @type="single" as |A|>
              <A.Item @value="item-1" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
                </I.Header>
                <I.Content data-test-content-1>Content 1</I.Content>
              </A.Item>
              <A.Item @value="item-2" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
                </I.Header>
                <I.Content data-test-content-2>Content 2</I.Content>
              </A.Item>
            </Accordion>
          </template>);

          await click('[data-test-trigger-1]');
          assert.dom('[data-test-content-1]').isVisible();
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });

        test('it shows the new content', async function(assert) {
          await render(<template>
            <Accordion @type="single" as |A|>
              <A.Item @value="item-1" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
                </I.Header>
                <I.Content data-test-content-1>Content 1</I.Content>
              </A.Item>
              <A.Item @value="item-2" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
                </I.Header>
                <I.Content data-test-content-2>Content 2</I.Content>
              </A.Item>
            </Accordion>
          </template>);

          await click('[data-test-trigger-1]');
          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-2]').isVisible();
        });
      });
    });

    module('with a defaultValue', function() {
      test('it shows the defaultValue', async function (assert) {
        await render(<template>
          <Accordion @type="single" @defaultValue="item-1" as |A|>
            <A.Item @value="item-1" as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value="item-2" as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);

        assert.dom('[data-test-content-1]').isVisible();
      });

      test('clicking the defaultValue\'s trigger hides the content', async function (assert) {
        await render(<template>
          <Accordion @type="single" @defaultValue="item-1" as |A|>
            <A.Item @value="item-1" as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
              </I.Header>
              <I.Content data-test-content-1>Content 1</I.Content>
            </A.Item>
            <A.Item @value="item-2" as |I|>
              <I.Header as |H|>
                <H.Trigger data-test-trigger-1>Trigger 2</H.Trigger>
              </I.Header>
              <I.Content data-test-content-2>Content 2</I.Content>
            </A.Item>
          </Accordion>
        </template>);

        await click('[data-test-trigger-1]');
        assert.dom('[data-test-content-1]').isNotVisible();
      });

      module('clicking a non-defaultValue\'s trigger', function () {
        test('shows the new content', async function (assert) {
          await render(<template>
            <Accordion @type="single" @defaultValue="item-1" as |A|>
              <A.Item @value="item-1" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
                </I.Header>
                <I.Content data-test-content-1>Content 1</I.Content>
              </A.Item>
              <A.Item @value="item-2" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
                </I.Header>
                <I.Content data-test-content-2>Content 2</I.Content>
              </A.Item>
            </Accordion>
          </template>);

          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-2]').isVisible();
        });

        test('hides the defaultValue\'s content', async function (assert) {
          await render(<template>
            <Accordion @type="single" @defaultValue="item-1" as |A|>
              <A.Item @value="item-1" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-1>Trigger 1</H.Trigger>
                </I.Header>
                <I.Content data-test-content-1>Content 1</I.Content>
              </A.Item>
              <A.Item @value="item-2" as |I|>
                <I.Header as |H|>
                  <H.Trigger data-test-trigger-2>Trigger 2</H.Trigger>
                </I.Header>
                <I.Content data-test-content-2>Content 2</I.Content>
              </A.Item>
            </Accordion>
          </template>);

          await click('[data-test-trigger-2]');
          assert.dom('[data-test-content-1]').isNotVisible();
        });
      })
    });
  });
});
