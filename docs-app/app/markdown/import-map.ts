import * as docsSupport from 'docs-app/docs-support';
import * as docsMarkdown from 'docs-app/markdown';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import * as eFocusTrap from 'ember-focus-trap';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import * as emberFocusTrap from 'ember-focus-trap/modifiers/focus-trap';
import * as emberHeadlessForm from 'ember-headless-form';
import * as eModifier from 'ember-modifier';
// ember-primitives (this library! yay!)
import * as emberPrimitives from 'ember-primitives';
import * as colorScheme from 'ember-primitives/color-scheme';
// ember-resources
import * as emberResources from 'ember-resources';
import * as remoteData from 'ember-resources/util/remote-data';
// ember-velcro
import * as emberVelcro from 'ember-velcro';
import * as velcro from 'ember-velcro/modifiers/velcro';
// other
import * as loremIpsum from 'lorem-ipsum';

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
    'ember-focus-trap/modifiers/focus-trap': emberFocusTrap,
    'ember-focus-trap': eFocusTrap,
    'docs-app/docs-support': docsSupport,
    'docs-app/markdown': docsMarkdown,
    'lorem-ipsum': loremIpsum,
    'ember-modifier': eModifier,
  },
};
