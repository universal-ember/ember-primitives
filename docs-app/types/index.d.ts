/// <reference types="@embroider/core/virtual" />
import 'kolay/virtual';
//
// import 'ember-source/types';
// import 'ember-source/types/preview';
import 'ember-cached-decorator-polyfill';
import '@glint/environment-ember-loose';

import type { HelperLike } from '@glint/template';

declare module '@ember/template-compilation';

import type Layout from 'docs-app/components/layout';

declare module '@glint/environment-ember-loose/registry' {
  // Remove this once entries have been added! 👇
  // eslint-disable-next-line @typescript-eslint/no-empty-interface
  export default interface Registry {
    // Add any registry entries from other addons here that your addon itself uses (in non-strict mode templates)
    // See https://typed-ember.gitbook.io/glint/using-glint/ember/using-addons
    'page-title': HelperLike<{
      Args: { Positional: [string] };
      Return: string;
    }>;

    Layout: typeof Layout;
  }
}
