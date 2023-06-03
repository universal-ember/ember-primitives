import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';

import type EmberRouter from '@ember/routing/router';
import type RouterService from '@ember/routing/router-service';

type RouterType = typeof EmberRouter;

interface Options {
  ignore?: string[];
}

export function properLinks(options: Options): (klass: RouterType) => RouterType;
export function properLinks(klass: RouterType): RouterType;
/**
 * @internal
 */
export function properLinks(options: Options, klass: RouterType): RouterType;

export function properLinks(
  ...args: [Options] | [RouterType] | [Options, RouterType]
): RouterType | ((klass: RouterType) => RouterType) {
  let options: Options = {};
  let klass: undefined | RouterType = undefined;

  if (args.length === 2) {
    options = args[0] as Options;
    klass = args[1] as RouterType;
  } else if (args.length === 1) {
    if (typeof args[0] === 'object') {
      // TODO: how to get first arg type correct?
      return (klass: RouterType) => properLinks(args[0] as any, klass);
    } else {
      klass = args[0];
    }
  }

  let ignore = options.ignore || [];

  assert(`klass was not defined. possibile incorrect arity given to properLinks`, klass);

  return class extends klass {
    constructor(...args: object[]) {
      super(...args);

      const handler = (event: MouseEvent) => {
        /**
         * event.target may not be an anchor,
         * it may be a span, svg, img, or any number of elements nested in <a>...</a>
         */
        let interactive = isLink(event);

        if (!interactive) return;

        let owner = getOwner(this);

        assert('owner is not present', owner);

        let routerService = owner.lookup('service:router');

        handle(routerService, interactive, ignore, event);

        return false;
      };

      document.body.addEventListener('click', handler, false);

      registerDestructor(this, () => document.body.removeEventListener('click', handler));
    }
  };
}

export function isLink(event: Event) {
  /**
   * Using composed path in case the link is removed from the DOM
   * before the event handler evaluates
   */
  let composedPath = event.composedPath();

  for (let element of composedPath) {
    if (element instanceof HTMLAnchorElement) {
      return element;
    }
  }
}

function handle(router: RouterService, element: HTMLAnchorElement, ignore: string[], event: Event) {
  /**
   * The href includes the protocol/host/etc
   * In order to not have the page look like a full page refresh,
   * we need to chop that "origin" off, and just use the path
   */
  let url = new URL(element.href);

  /**
   * If the domains are different, we want to fall back to normal link behavior
   *
   */
  if (location.origin !== url.origin) return;

  /**
   * We can optionally declare some paths as ignored,
   * or "let the browser do its default thing,
   * because there is other server-based routing to worry about"
   */
  if (ignore.includes(url.pathname)) return;

  let routeInfo = router.recognize(url.pathname);

  if (routeInfo) {
    event.preventDefault();
    event.stopImmediatePropagation();
    event.stopPropagation();

    router.transitionTo(url.pathname);

    return false;
  }
}
