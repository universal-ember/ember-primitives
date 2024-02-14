import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { Callout } from 'docs-app/components/callout';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import * as eFocusTrap from 'ember-focus-trap';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import * as emberFocusTrap from 'ember-focus-trap/modifiers/focus-trap';
import * as emberHeadlessForm from 'ember-headless-form';
// ember-primitives (this library! yay!)
import * as emberPrimitives from 'ember-primitives';
import * as colorScheme from 'ember-primitives/color-scheme';
// ember-velcro
import * as emberVelcro from 'ember-velcro';
import * as velcro from 'ember-velcro/modifiers/velcro';
import * as loremIpsum from 'lorem-ipsum';
import * as remoteData from 'reactiveweb/remote-data';

import type { DocsService } from 'kolay';


export default class Application extends Route {
  @service('kolay/docs') declare docs: DocsService;

  beforeModel() {
    this.docs.setup({
      // Available directly within the markdown
      topLevelScope: {
        Callout,
      },
      // TODO: discover this at build time
      // TODO: change all this to await imports
      resolve: {
        // ember-primitives
        'ember-primitives': emberPrimitives,
        'ember-primitives/color-scheme': colorScheme,

        // community libraries
        'ember-headless-form': emberHeadlessForm,
        'reactiveweb/remote-data': remoteData,
        'ember-focus-trap/modifiers/focus-trap': emberFocusTrap,
        'ember-focus-trap': eFocusTrap,
        'ember-velcro': emberVelcro,
        'ember-velcro/modifiers/velcro': velcro,

        // utility
        'lorem-ipsum': loremIpsum,
      },
    });
  }
}
