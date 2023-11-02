import { cached } from '@glimmer/tracking';
import Service, { service } from '@ember/service';

import { use } from 'ember-resources';
import { RemoteData } from 'reactiveweb/remote-data';

import type Selected from './selected';
import type { Manifest } from './types';
import type RouterService from '@ember/routing/router-service';

export default class DocsService extends Service {
  @service declare router: RouterService;
  @service declare selected: Selected;

  @use docs = RemoteData<Manifest>(() => `/docs/manifest.json`);

  get pages() {
    return this.docs.value?.list ?? [];
  }

  get grouped() {
    return this.docs.value?.grouped ?? {};
  }

  @cached
  get flatList() {
    return this.pages.flat();
  }
}

// DO NOT DELETE: this is how TypeScript knows how to look up your services.
declare module '@ember/service' {
  interface Registry {
    docs: DocsService;
  }
}
