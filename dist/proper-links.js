import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';

/* eslint-disable @typescript-eslint/no-explicit-any */

/**
 * @internal
 */

function properLinks(...args) {
  let options = {};
  let klass = undefined;
  if (args.length === 2) {
    options = args[0];
    klass = args[1];
  } else if (args.length === 1) {
    if (typeof args[0] === 'object') {
      // TODO: how to get first arg type correct?
      return klass => properLinks(args[0], klass);
    } else {
      klass = args[0];
    }
  }
  let ignore = options.ignore || [];
  assert(`klass was not defined. possibile incorrect arity given to properLinks`, klass);
  return class RouterWithProperLinks extends klass {
    // SAFETY: we literally do not care about the args' type here,
    //         because we just call super
    constructor(...args) {
      super(...args);
      setup(this, ignore);
    }
  };
}

/**
 * Setup proper links without a decorator.
 * This function only requires that a framework object with an owner is passed.
 */
function setup(parent, ignore) {
  const handler = event => {
    /**
     * event.target may not be an anchor,
     * it may be a span, svg, img, or any number of elements nested in <a>...</a>
     */
    let interactive = isLink(event);
    if (!interactive) return;
    let owner = getOwner(parent);
    assert('owner is not present', owner);
    let routerService = owner.lookup('service:router');
    handle(routerService, interactive, ignore ?? [], event);
  };
  document.body.addEventListener('click', handler, false);
  registerDestructor(parent, () => document.body.removeEventListener('click', handler));
}
function isLink(event) {
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
function handle(router, element, ignore, event) {
  if (!element) return;
  /**
   * If we don't have an href, the <a> is invalid.
   * If you're debugging your code and end up finding yourself
   * early-returning here, please add an href ;)
   */
  if (!element.href) return;

  /**
   * This is partially an escape hatch, but any time target is set,
   * we are usually wanting to escape the behavior of single-page-apps.
   *
   * Some folks desire to have in-SPA links, but still do native browser behavior
   * (which for the case of SPAs is a full page refresh)
   * but they can set target="_self" to get that behavior back if they want.
   *
   * I expect that this'll be a super edge case, because the whole goal of
   * "proper links" is to do what is expected, always -- for in-app SPA links
   * as well as external, cross-domain links
   */
  if (element.target) return;

  /**
   * If the click is not a "left click" we don't want to intercept the event.
   * This allows folks to
   * - middle click (usually open the link in a new tab)
   * - right click (usually opens the context menu)
   */
  if (event.button !== 0) return;

  /**
   * for MacOS users, this default behavior opens the link in a new tab
   */
  if (event.metaKey) return;

  /**
   * for for everyone else, this default behavior opens the link in a new tab
   */
  if (event.ctrlKey) return;

  /**
   * The default behavior here downloads the link content
   */
  if (event.altKey) return;

  /**
   * The default behavior here opens the link in a new window
   */
  if (event.shiftKey) return;

  /**
   * If another event listener called event.preventDefault(), we don't want to proceed.
   */
  if (event.defaultPrevented) return;

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

export { handle, isLink, properLinks, setup };
//# sourceMappingURL=proper-links.js.map
