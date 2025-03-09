/* eslint-disable @typescript-eslint/no-explicit-any */
import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';

import { getAnchor, shouldHandle } from 'should-handle-link';

import type EmberRouter from '@ember/routing/router';
import type RouterService from '@ember/routing/router-service';

export { shouldHandle } from 'should-handle-link';

type Constructor<T extends object = object> = { new (...args: any[]): T };

export interface Options {
  ignore?: string[];
}

export function properLinks(
  options: Options
): <Instance extends object, Klass = { new (...args: any[]): Instance }>(klass: Klass) => Klass;

export function properLinks<Instance extends object, Klass = { new (...args: any[]): Instance }>(
  klass: Klass
): Klass;
/**
 * @internal
 */
export function properLinks<Instance extends object, Klass = { new (...args: any[]): Instance }>(
  options: Options,
  klass: Klass
): Klass;

export function properLinks<Instance extends object, Klass = { new (...args: any[]): Instance }>(
  ...args: [Options] | [Klass] | [Options, Klass]
): Klass | ((klass: Klass) => Klass) {
  let options: Options = {};

  let klass: undefined | Klass = undefined;

  if (args.length === 2) {
    options = args[0];
    klass = args[1];
  } else if (args.length === 1) {
    if (typeof args[0] === 'object') {
      // TODO: how to get first arg type correct?
      return (klass: Klass) => properLinks(args[0] as any, klass);
    } else {
      klass = args[0];
    }
  }

  const ignore = options.ignore || [];

  assert(`klass was not defined. possibile incorrect arity given to properLinks`, klass);

  return class RouterWithProperLinks extends (klass as unknown as Constructor<EmberRouter>) {
    // SAFETY: we literally do not care about the args' type here,
    //         because we just call super
    constructor(...args: any[]) {
      super(...args);

      setup(this, ignore);
    }
  } as unknown as Klass;
}

/**
 * Setup proper links without a decorator.
 * This function only requires that a framework object with an owner is passed.
 */
export function setup(parent: object, ignore?: string[]) {
  const handler = (event: MouseEvent) => {
    /**
     * event.target may not be an anchor,
     * it may be a span, svg, img, or any number of elements nested in <a>...</a>
     */
    const interactive = getAnchor(event);

    if (!interactive) return;

    const owner = getOwner(parent);

    assert('owner is not present', owner);

    const routerService = owner.lookup('service:router');

    handle(routerService, interactive, ignore ?? [], event);
  };

  document.body.addEventListener('click', handler, false);

  registerDestructor(parent, () => document.body.removeEventListener('click', handler));
}

export function handle(
  router: RouterService,
  element: HTMLAnchorElement,
  ignore: string[],
  event: MouseEvent
) {
  if (!shouldHandle(location.href, element, event, ignore)) {
    return;
  }

  const url = new URL(element.href);

  const fullHref = `${url.pathname}${url.search}${url.hash}`;

  const rootURL = router.rootURL;

  let withoutRootURL = fullHref.slice(rootURL.length);

  // re-add the "root" sigil
  // we removed it when we chopped off the rootURL,
  // because the rootURL often has this attached to it as well
  if (!withoutRootURL.startsWith('/')) {
    withoutRootURL = `/${withoutRootURL}`;
  }

  try {
    const routeInfo = router.recognize(fullHref);

    if (routeInfo) {
      event.preventDefault();
      event.stopImmediatePropagation();
      event.stopPropagation();

      router.transitionTo(withoutRootURL);

      return false;
    }
  } catch (e) {
    if (e instanceof Error && e.name === 'UnrecognizedURLError') {
      return;
    }

    throw e;
  }
}
