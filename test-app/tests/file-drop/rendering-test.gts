import { render, settled } from '@ember/test-helpers';
import { module, test } from 'qunit';
import { setupRenderingTest } from 'ember-qunit';

import { DocumentFileDrop, FileDrop } from 'ember-primitives/components/file-drop';
import { cell } from 'ember-resources';

const video = new File(['video'], 'clip.webm', { type: 'video/webm' });
const movie = new File(['movie'], 'movie.MKV', { type: '' });
const notes = new File(['notes'], 'notes.txt', { type: 'text/plain' });

function transfer(items: File[] | string) {
  const data = new DataTransfer();

  if (typeof items === 'string') {
    data.setData('text/plain', items);
  } else {
    for (const file of items) data.items.add(file);
  }

  return data;
}

/**
 * A real `DragEvent`, so that `dataTransfer` and `defaultPrevented` behave as in a browser.
 */
async function drag(target: Element | Document, type: string, items: File[] | string) {
  const event = new DragEvent(type, {
    bubbles: true,
    cancelable: true,
    dataTransfer: transfer(items),
  });

  target.dispatchEvent(event);
  await settled();

  return event;
}

function element(selector: string) {
  const found = document.querySelector(selector);

  if (!found) throw new Error(`Nothing matches ${selector}`);

  return found;
}

const names = (files: File[]) => files.map((file) => file.name).join(', ');

module('FileDrop', function (hooks) {
  setupRenderingTest(hooks);

  test('a label opens a hidden file input', async function (assert) {
    const noop = () => {};

    await render(
      <template>
        <FileDrop @accept="video/*" @multiple={{true}} @onFiles={{noop}} data-test-zone>
          Drop here
        </FileDrop>
      </template>
    );

    const input = element('[data-test-zone] input[type="file"]');

    assert.dom('[data-test-zone]').hasTagName('label');
    assert.dom('[data-test-zone]').hasAttribute('for', input.id);
    assert.dom('[data-test-zone]').hasText('Drop here');
    assert.dom(input).hasAttribute('accept', 'video/*');
    assert.dom(input).hasAttribute('multiple');
    assert.dom(input).hasClass('ember-primitives__visually-hidden');
  });

  test('isDragging stays on while the pointer crosses children', async function (assert) {
    const noop = () => {};

    await render(
      <template>
        <FileDrop @onFiles={{noop}} data-test-zone as |zone|>
          <span data-test-child>{{if zone.isDragging "dragging" "idle"}}</span>
        </FileDrop>
      </template>
    );

    const zone = element('[data-test-zone]');
    const child = element('[data-test-child]');

    await drag(zone, 'dragenter', [video]);
    await drag(child, 'dragenter', [video]);
    await drag(zone, 'dragleave', [video]);
    assert.dom(zone).hasAttribute('data-dragging');
    assert.dom(child).hasText('dragging');

    await drag(child, 'dragleave', [video]);
    assert.dom(zone).doesNotHaveAttribute('data-dragging');
    assert.dom(child).hasText('idle');
  });

  test('a drop gives the files that match @accept', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));

    await render(
      <template>
        <FileDrop @accept="video/*, .mkv" @multiple={{true}} @onFiles={{take}} data-test-zone />
      </template>
    );

    const zone = element('[data-test-zone]');

    await drag(zone, 'dragenter', [video]);

    const drop = await drag(zone, 'drop', [notes, video, movie]);

    assert.verifySteps(['clip.webm, movie.MKV']);
    assert.true(drop.defaultPrevented, 'the browser does not open the files');
    assert.dom(zone).doesNotHaveAttribute('data-dragging');

    await drag(zone, 'drop', [notes]);
    assert.verifySteps([], 'no call when nothing matches');
  });

  test('without @multiple, only the first matching file', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));

    await render(<template><FileDrop @onFiles={{take}} data-test-zone /></template>);

    await drag(element('[data-test-zone]'), 'drop', [notes, video]);

    assert.verifySteps(['notes.txt']);
  });

  test('a drag of text is not a file drag', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));

    await render(<template><FileDrop @onFiles={{take}} data-test-zone /></template>);

    const zone = element('[data-test-zone]');

    await drag(zone, 'dragenter', 'hello');
    assert.dom(zone).doesNotHaveAttribute('data-dragging');

    const drop = await drag(zone, 'drop', 'hello');

    assert.false(drop.defaultPrevented);
    assert.verifySteps([]);
  });

  test('a pick gives the files, and the same file can be picked again', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));

    await render(<template><FileDrop @onFiles={{take}} data-test-zone /></template>);

    const input = element('[data-test-zone] input') as HTMLInputElement;

    input.files = transfer([video]).files;
    input.dispatchEvent(new Event('change', { bubbles: true }));
    await settled();

    assert.verifySteps(['clip.webm']);
    assert.strictEqual(input.value, '', 'the input is cleared');
  });
});

module('DocumentFileDrop', function (hooks) {
  setupRenderingTest(hooks);

  test('a drop anywhere on the page gives the files', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));

    await render(
      <template>
        <DocumentFileDrop @accept="video/*" @onFiles={{take}} as |page|>
          <p data-test-state>{{if page.isDragging "dragging" "idle"}}</p>
        </DocumentFileDrop>
      </template>
    );

    await drag(document.body, 'dragenter', [video]);
    assert.dom('[data-test-state]').hasText('dragging');

    const over = await drag(document.body, 'dragover', [video]);

    assert.true(over.defaultPrevented, 'the page allows the drop');

    const drop = await drag(document.body, 'drop', [notes, video]);

    assert.verifySteps(['clip.webm']);
    assert.true(drop.defaultPrevented, 'the browser does not open the file');
    assert.dom('[data-test-state]').hasText('idle');
  });

  test('a drop that matches nothing still does not open the file', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));

    await render(<template><DocumentFileDrop @accept="video/*" @onFiles={{take}} /></template>);

    const drop = await drag(document.body, 'drop', [notes]);

    assert.true(drop.defaultPrevented);
    assert.verifySteps([]);
  });

  test('a drop on a FileDrop goes only to the FileDrop', async function (assert) {
    const page = (files: File[]) => assert.step(`page ${names(files)}`);
    const zone = (files: File[]) => assert.step(`zone ${names(files)}`);

    await render(
      <template>
        <DocumentFileDrop @onFiles={{page}} />
        <FileDrop @onFiles={{zone}} data-test-zone />
      </template>
    );

    await drag(element('[data-test-zone]'), 'drop', [video]);
    await drag(document.body, 'drop', [video]);

    assert.verifySteps(['zone clip.webm', 'page clip.webm']);
  });

  test('it stops listening when it leaves the page', async function (assert) {
    const take = (files: File[]) => assert.step(names(files));
    const shown = cell(true);

    await render(
      <template>
        {{#if shown.current}}
          <DocumentFileDrop @onFiles={{take}} />
        {{/if}}
      </template>
    );

    shown.current = false;
    await settled();

    const drop = await drag(document.body, 'drop', [video]);

    assert.false(drop.defaultPrevented);
    assert.verifySteps([]);
  });
});
