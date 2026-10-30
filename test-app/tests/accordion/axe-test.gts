import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Accordion } from 'ember-primitives';

import { audit } from '../axe.ts';

module('<Accordion> | axe', function (hooks) {
  setupRenderingTest(hooks);

  test('has no axe violations when expanded', async function (assert) {
    await render(
      <template>
        <Accordion @type="single" @defaultValue="a" as |A|>
          <A.Item @value="a" as |I|>
            <I.Header as |H|><H.Trigger>Trigger</H.Trigger></I.Header>
            <I.Content>Content</I.Content>
          </A.Item>
        </Accordion>
      </template>
    );

    await audit(assert);
  });
});
