import { find, render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Tabs } from 'ember-primitives/components/tabs';

module('Rendering | <Tabs>', function (hooks) {
  setupRenderingTest(hooks);

  test('it works (minimal)', async function (assert) {
    await render(
      <template>
        <Tabs as |TabList|>
          <TabList.Label>This is a list of foods</TabList.Label>
          <TabList as |tab|>
            <tab as |trigger content|>
              <trigger>
                Banana
              </trigger>
              <content>
                Something about Bananas
              </content>
            </tab>
            <tab as |trigger content|>
              <trigger>
                Apples
              </trigger>
              <content>
                Something about Apples
              </content>
            </tab>
          </TabList>
          <TabList.Content />
        </Tabs>
      </template>
    );

    await this.pauseTest();
    assert.dom().containsText('Something about Bananas');
  });
});
