import { assert } from '@ember/debug';

import { compileTopLevelComponent } from './create-top-level-component';
import { cell, resource, resourceFactory } from 'ember-resources';
import rehypeRaw from 'rehype-raw';
import type { ComponentLike } from '@glint/template';
import rehypeStringify from 'rehype-stringify';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import { unified } from 'unified';

const compiler = unified()
  .use(remarkParse)
  .use(remarkRehype, { allowDangerousHtml: true })
  .use(rehypeRaw)
  .use(rehypeStringify);

async function compile(markdown: string | undefined | null) {
  if (!markdown) return;

  let processed = await compiler.process(markdown);

  return String(processed);
}

type Input = string | undefined | null;

export const MarkdownToHTML = resourceFactory(
  (markdownText: Input | (() => Input)) => {
    return resource(() => {
      let input =
        typeof markdownText === 'function' ? markdownText() : markdownText;
      let ready = cell(false);
      let result = cell('');

      if (input) {
        compile(input).then((html) => {
          assert(`Failed to compile ${input}`, html);
          result.current = html;
          ready.current = true;
        });
      }

      return () => ({
        ready: ready.current,
        html: result.current,
      });
    });
  }
);

export const MarkdownToComponent = resourceFactory(
  (markdownText: Input | (() => Input)) => {
    return resource(() => {
      let input =
        typeof markdownText === 'function' ? markdownText() : markdownText;
      let ready = cell(false);
      let result = cell<ComponentLike>();

      if (input) {
        compileTopLevelComponent(input, {
          format: 'glimdown',
          onSuccess: (component) => {
            result.current = component;
            ready.current = true;
          },
          onError: (error) => {
            console.error(error);
          },
          onCompileStart: () => {},
        });
      }

      return () => ({
        ready: ready.current,
        html: result.current,
      });
    });
  }
);
