/* eslint-disable ember/no-runloop */
/* eslint-disable @typescript-eslint/no-unsafe-argument */
/* eslint-disable @typescript-eslint/no-unsafe-assignment */
import { warn } from '@ember/debug';
import { isDestroyed, isDestroying, registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';
import { schedule } from '@ember/runloop';
import { waitForPromise } from '@ember/test-waiters';

import type ApplicationInstance from '@ember/application/instance';
import type Route from '@ember/routing/route';
import type EmberRouter from '@ember/routing/router';

type Transition = Parameters<Route['beforeModel']>[0];
type TransitionWithPrivateAPIs = Transition & {
  intent?: {
    url: string;
  };
};

export function withHashSupport(AppRouter: typeof EmberRouter): typeof AppRouter {
  return class RouterWithHashSupport extends AppRouter {
    constructor(...args: any[]) {
      super(...args);

      void setupHashSupport(this);
    }
  };
}

export function scrollToHash(hash: string) {
  const selector = `[name="${hash}"]`;
  const element = document.getElementById(hash) || document.querySelector(selector);

  if (!element) {
    warn(`Tried to scroll to element with id or name "${hash}", but it was not found`, {
      id: 'no-hash-target',
    });

    return;
  }

  /**
   * NOTE: the ember router does not support hashes in the URL
   *       https://github.com/emberjs/rfcs/issues/709
   *
   *       this means that when testing hash changes in the URL,
   *       we have to assert against the window.location, rather than
   *       the self-container currentURL helper
   *
   * NOTE: other ways of changing the URL, but without the smoothness:
   *   - window[.top].location.replace
   */

  element.scrollIntoView({ behavior: 'smooth' });

  if (hash !== window.location.hash) {
    const withoutHash = location.href.split('#')[0];
    const nextUrl = `${withoutHash}#${hash}`;
    // most browsers ignore the title param of pushState
    const titleWithoutHash = document.title.split(' | #')[0];
    const nextTitle = `${titleWithoutHash} | #${hash}`;

    history.pushState({}, nextTitle, nextUrl);
    document.title = nextTitle;
  }
}

function isLoadingRoute(routeName: string) {
  return routeName.endsWith('_loading') || routeName.endsWith('.loading');
}

async function setupHashSupport(router: EmberRouter) {
  let initialURL: string | undefined;
  const owner = getOwner(router) as ApplicationInstance;

  await new Promise((resolve) => {
    const interval = setInterval(() => {
      const { currentURL, currentRouteName } = router as any; /* Private API */

      if (currentURL && !isLoadingRoute(currentRouteName)) {
        clearInterval(interval);
        initialURL = currentURL;
        resolve(null);
      }
    }, 100);
  });

  if (isDestroyed(owner) || isDestroying(owner)) {
    return;
  }

  /**
   * This handles the initial Page Load, which is not imperceptible through
   * route{Did,Will}Change
   *
   */
  requestAnimationFrame(() => {
    void eventuallyTryScrollingTo(owner, initialURL);
  });

  const routerService = owner.lookup('service:router');

  function handleHashIntent(transition: TransitionWithPrivateAPIs) {
    const { url } = transition.intent || {};

    if (!url) {
      return;
    }

    void eventuallyTryScrollingTo(owner, url);
  }

  // @ts-expect-error -- I don't want to fix this
  routerService.on('routeDidChange', handleHashIntent);

  registerDestructor(router, () => {
    routerService.off('routeDidChange', handleHashIntent);
  });
}

const CACHE = new WeakMap<ApplicationInstance, MutationObserver>();

async function eventuallyTryScrollingTo(owner: ApplicationInstance, url?: string) {
  // Prevent quick / rapid transitions from continuing to observe beyond their URL-scope
  CACHE.get(owner)?.disconnect();

  if (!url) return;

  const [, hash] = url.split('#');

  if (!hash) return;

  await waitForPromise(uiSettled(owner));

  if (isDestroyed(owner) || isDestroying(owner)) {
    return;
  }

  scrollToHash(hash);
}

const TIME_SINCE_LAST_MUTATION = 500; // ms
const MAX_TIMEOUT = 2000; // ms

/**
 * exported for testing
 *
 * @internal
 */
export async function uiSettled(owner: ApplicationInstance) {
  const timeStarted = new Date().getTime();
  let lastMutationAt = Infinity;
  let totalTimeWaited = 0;

  const observer = new MutationObserver(() => {
    lastMutationAt = new Date().getTime();
  });

  CACHE.set(owner, observer);

  observer.observe(document.body, { childList: true, subtree: true });

  /**
   * Wait for DOM mutations to stop until MAX_TIMEOUT
   */
  await new Promise((resolve) => {
    let frame: number;

    function requestTimeCheck() {
      if (frame) cancelAnimationFrame(frame);

      if (isDestroyed(owner) || isDestroying(owner)) {
        return;
      }

      frame = requestAnimationFrame(() => {
        totalTimeWaited = new Date().getTime() - timeStarted;

        const timeSinceLastMutation = new Date().getTime() - lastMutationAt;

        if (totalTimeWaited >= MAX_TIMEOUT) {
          return resolve(totalTimeWaited);
        }

        if (timeSinceLastMutation >= TIME_SINCE_LAST_MUTATION) {
          return resolve(totalTimeWaited);
        }

        schedule('afterRender', requestTimeCheck);
      });
    }

    schedule('afterRender', requestTimeCheck);
  });
}
