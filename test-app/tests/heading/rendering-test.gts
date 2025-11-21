import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Heading } from 'ember-primitives/components/heading';

module('Rendering | Heading', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>
        <Heading id="b">one</Heading>
        <section>
          <Heading id="c">two</Heading>
          <Heading id="d">two</Heading>
          <section>
            <Heading id="f">three</Heading>

          </section>
          <Heading id="e">two</Heading>
        </section>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h1');
    assert.dom('#c').hasTagName('h2');
    assert.dom('#d').hasTagName('h2');
    assert.dom('#e').hasTagName('h2');
    assert.dom('#f').hasTagName('h3');
  });
});
