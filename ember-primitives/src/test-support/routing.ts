import Router from '@ember/routing/router';

import { properLinks } from '../proper-links';

import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';

export function setupRouting(
  owner: Owner,
  map: Parameters<(typeof Router)['map']>[0],
  options?: { rootURL: string }
) {
  @properLinks
  class TestRouter extends Router {
    rootURL = options?.rootURL ?? '/';
  }

  TestRouter.map(map);

  owner.register('router:main', TestRouter);

  // eslint-disable-next-line ember/no-private-routing-service
  let iKnowWhatIMDoing = owner.lookup('router:main');

  // We need a public testing API for this sort of stuff
  (iKnowWhatIMDoing as any).setupRouter();
}

export function getRouter(owner: Owner) {
  return owner.lookup('service:router') as RouterService;
}

