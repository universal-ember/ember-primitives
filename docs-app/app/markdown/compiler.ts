import { Shadowed } from 'ember-primitives';
import { Compiled as REPLCompiled } from 'ember-repl';
import { resource, resourceFactory } from 'ember-resources';

import { Callout } from '../components/callout';
import { defaultOptions } from './import-map';

type Input = string | undefined | null;
type Format = 'glimdown' | 'gjs' | 'hbs';
export interface Options {
  format: Format;
  importMap: Record<string, Record<string, unknown>>;
}

export const Compiled = resourceFactory(
  (markdownText: Input | (() => Input), userOptions?: Options) => {
    return resource(({ use }) => {
      let options = {
        topLevelScope: {
          Shadowed,
          Callout,
        },
        ShadowComponent: 'Shadowed',
        ...defaultOptions,
        ...userOptions,
      };

      let output = use(REPLCompiled(markdownText, options));

      return () => output.current;
    });
  }
);
