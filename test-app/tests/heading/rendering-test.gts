import { render } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { Heading } from 'ember-primitives/components/heading';
import { Shadowed } from 'ember-primitives/components/shadowed';

import { findInFirstShadow } from 'ember-primitives/test-support';

module('Rendering | Heading', function (hooks) {
  setupRenderingTest(hooks);

  test('in a section', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>
        <section>
          <Heading id="b">two</Heading>
        </section>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h2');
  });

  module('wrapped headings', function () {
    test('h1 wrapped in <a>', async function (assert) {
      await render(
        <template>
          <a href="#">
            <Heading id="a">one</Heading>
          </a>
          <section>
            <Heading id="b">two</Heading>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom('#b').hasTagName('h2');
    });

    test('h2 wrapped in <a>', async function (assert) {
      await render(
        <template>
          <Heading id="a">one</Heading>

          <section>
            <a href="#">
              <Heading id="b">two</Heading>
            </a>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom('#b').hasTagName('h2');
    });

    test('h1 wrapped in <header><a>', async function (assert) {
      await render(
        <template>
          <header>
            <a href="#">
              <Heading id="a">one</Heading>
            </a>
          </header>
          <section>
            <Heading id="b">two</Heading>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom('#b').hasTagName('h2');
    });

    test('h1 wrapped in <header><div><a>', async function (assert) {
      await render(
        <template>
          <header>
            <div>
              <a href="#">
                <Heading id="a">one</Heading>
              </a>
            </div>
          </header>
          <section>
            <Heading id="b">two</Heading>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom('#b').hasTagName('h2');
    });

    test('h1 wrapped in <header><div><a>, h2 wrapped in <a>', async function (assert) {
      await render(
        <template>
          <header>
            <div>
              <a href="#">
                <Heading id="a">one</Heading>
              </a>
            </div>
          </header>
          <section>
            <a href="#">
              <Heading id="b">two</Heading>
            </a>

            <section>
              <a href="#">
                <Heading id="c">three</Heading>
              </a>
            </section>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom('#b').hasTagName('h2');
      assert.dom('#c').hasTagName('h3');
    });

    test('[extraneous handling] h1 wrapped in <header><div><a>, h2 wrapped in <a>', async function (assert) {
      await render(
        <template>
          <header>
            <div>
              <a href="#">
                <Heading id="a">one</Heading>
              </a>
              <section>
                <a href="#">
                  <Heading id="d">two</Heading>
                </a>
              </section>
            </div>
          </header>
          <section>
            <a href="#">
              <Heading id="b">two</Heading>
            </a>

            <Heading id="f">two</Heading>

            <section>
              <a href="#">
                <Heading id="c">three</Heading>
              </a>

              <section>
                <a href="#">
                  <Heading id="e">four</Heading>
                </a>
              </section>
            </section>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom('#b').hasTagName('h2');
      assert.dom('#c').hasTagName('h3');

      assert.dom('#d').hasTagName('h2');
      assert.dom('#e').hasTagName('h4');
      assert.dom('#f').hasTagName('h2');
    });
  });

  module('in shadow', function () {
    test('in a section', async function (assert) {
      await render(
        <template>
          <Heading id="a">one</Heading>

          <Shadowed>
            <section>
              <Heading id="b">two</Heading>
            </section>
          </Shadowed>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom(findInFirstShadow('#b')).hasTagName('h2');
    });

    test('section wraps shadow', async function (assert) {
      await render(
        <template>
          <Heading id="a">one</Heading>

          <section>
            <Shadowed>
              <Heading id="b">two</Heading>
            </Shadowed>
          </section>
        </template>
      );

      assert.dom('#a').hasTagName('h1');
      assert.dom(findInFirstShadow('#b')).hasTagName('h2');
    });
  });

  test('first in a section', async function (assert) {
    await render(
      <template>
        <section>
          <Heading id="a">one</Heading>
        </section>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
  });

  test('extraneous sections', async function (assert) {
    await render(
      <template>
        <section>
          <section>
            <section>
              <Heading id="a">one</Heading>
            </section>
          </section>
        </section>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
  });

  test('in a section (with hardcoded h1)', async function (assert) {
    await render(
      <template>
        <h1 id="a">one</h1>
        <section>
          <Heading id="b">two</Heading>
        </section>
      </template>
    );

    assert.dom('#b').hasTagName('h2');
  });

  test('in a section (with hardcoded h1 *and* h2)', async function (assert) {
    await render(
      <template>
        <h1 id="a">one</h1>
        <h2 id="c">three</h2>
        <section>
          <Heading id="b">two</Heading>
        </section>
      </template>
    );

    assert.dom('#b').hasTagName('h3');
  });

  test('in a section (with hardcoded 2 h1)', async function (assert) {
    await render(
      <template>
        <h1 id="a">one</h1>
        <h1 id="c">three</h1>
        <section>
          <Heading id="b">two</Heading>
        </section>
      </template>
    );

    assert.dom('#b').hasTagName('h2');
  });

  test('top-level adjacent', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>
        <Heading id="b">one</Heading>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h1');
  });

  test('top-level adjacent (with hardcoded h1)', async function (assert) {
    await render(
      <template>
        <h1 id="a">one</h1>
        <Heading id="b">one</Heading>
      </template>
    );

    assert.dom('#b').hasTagName('h1');
  });

  test('top-level adjacent, one in section', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>
        <Heading id="b">one</Heading>

        <section>
          <Heading id="c">two</Heading>
        </section>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h1');
    assert.dom('#c').hasTagName('h2');
  });

  test('one top-level, two in section', async function (assert) {
    await render(
      <template>
        <Heading id="a">one</Heading>

        <section>
          <Heading id="b">two</Heading>
          <Heading id="c">two</Heading>
        </section>
      </template>
    );

    assert.dom('#a').hasTagName('h1');
    assert.dom('#b').hasTagName('h2');
    assert.dom('#c').hasTagName('h2');
  });

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
