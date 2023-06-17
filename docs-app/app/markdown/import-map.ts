import * as docsSupport from 'docs-app/docs-support';
import * as emberHeadlessForm from 'ember-headless-form';
// ember-primitives (this library! yay!)
import * as emberPrimitives from 'ember-primitives';
import * as colorScheme from 'ember-primitives/color-scheme';
// ember-resources
import * as emberResources from 'ember-resources';
import * as remoteData from 'ember-resources/util/remote-data';
// ember-velcro
import * as emberVelcro from 'ember-velcro';
import * as velcro from 'ember-velcro/modifiers/velcro';

import type { Options } from './compiler';

export const defaultOptions: Options = {
  format: 'glimdown',
  importMap: {
    'ember-velcro': emberVelcro,
    'ember-velcro/modifiers/velcro': velcro,
    'ember-primitives': emberPrimitives,
    'ember-primitives/color-scheme': colorScheme,
    'ember-headless-form': emberHeadlessForm,
    'ember-resources': emberResources,
    'ember-resources/util/remote-data': remoteData,
    'docs-app/docs-support': docsSupport,
  },
};
