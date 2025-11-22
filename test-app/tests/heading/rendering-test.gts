import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Heading } from 'ember-primitives/components/heading';

module('Rendering | Heading', function (hooks) {
  setupRenderingTest(hooks);

  test('section elements change the section heading level', async function (assert) {
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

  test('aside elements change the section heading level', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>
        <Heading id="b">one</Heading>
        <aside>
          <Heading id="c">two</Heading>
          <Heading id="d">two</Heading>
        </aside>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h1');
    assert.dom('#c').hasTagName('h2');
    assert.dom('#d').hasTagName('h2');
  });

  test('article elements change the section heading level', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>
        <Heading id="b">one</Heading>
        <article>
          <Heading id="c">two</Heading>
          <Heading id="d">two</Heading>
          <article>
            <Heading id="f">three</Heading>

          </article>
          <Heading id="e">two</Heading>
        </article>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h1');
    assert.dom('#c').hasTagName('h2');
    assert.dom('#d').hasTagName('h2');
    assert.dom('#e').hasTagName('h2');
    assert.dom('#f').hasTagName('h3');
  });

  test('A mix of article, section, and aside change the sectian heading level', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>

        <aside>
          <Heading id="b">two</Heading>
        </aside>
        <article>
          <Heading id="c">two</Heading>

          <section>
            <Heading id="d">three</Heading>
          </section>
          <section>
            <Heading id="e">three</Heading>
          </section>
        </article>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h2');
    assert.dom('#c').hasTagName('h2');
    assert.dom('#d').hasTagName('h3');
    assert.dom('#e').hasTagName('h3');
  });
});
