import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Heading } from 'ember-primitives/component/heading';

module('Rendering | Heading', function (hooks) {
  setupRenderingTest(hooks);

  test('it works', async function (assert) {
    await render(
      <template>
        <Heading>a</Heading>
        <Heading>b</Heading>
        <section>
          <Heading>c</Heading>
          <Heading>d</Heading>
          <section>
            <Heading>f</Heading>

          </section>
          <Heading>e</Heading>
        </section>
      </template>
    );
  });
});
