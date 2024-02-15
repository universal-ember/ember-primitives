import Route from '@ember/routing/route';
import { service } from '@ember/service';

import type { SetupService } from 'ember-primitives';

export default class Application extends Route {
  @service('ember-primitives/setup') declare primitives: SetupService;

  beforeModel() {
    this.primitives.setup();
  }
}
