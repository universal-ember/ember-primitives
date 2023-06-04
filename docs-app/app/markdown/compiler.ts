// import { Shadowed } from 'ember-primitives';
import { compile } from 'ember-repl';
import { cell, resource, resourceFactory } from 'ember-resources';

import { Wrapper } from './shadow-highlight';

import type { ComponentLike } from '@glint/template';

type Input = string | undefined | null;
type Format = 'glimdown' | 'gjs' | 'hbs';
interface Options {
  format: Format;
  importMap: Record<string, Record<string, unknown>>;
}

// TODO: upstream these tweaks to ember-repl
export const Compiled = resourceFactory(
  (markdownText: Input | (() => Input), options: Options) => {
    return resource(() => {
      let { format = 'glimdown', importMap } = options ?? {};

      let input =
        typeof markdownText === 'function' ? markdownText() : markdownText;
      let ready = cell(false);
      let error = cell();
      let result = cell<ComponentLike>();

      if (input) {
        compile(input, {
          format,
          importMap,
          topLevelScope: {
            Shadowed: Wrapper,
          },
          ShadowComponent: 'Shadowed',
          onSuccess: async (component) => {
            result.current = component;
            ready.set(true);
            error.set(null);
          },
          onError: async (e) => {
            error.set(e);
          },
          onCompileStart: async () => {
            ready.set(false);
          },
        });
      }

      return () => ({
        isReady: ready.current,
        error: error.current,
        component: result.current,
      });
    });
  }
);
