
import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';
import { shouldHandle, getAnchor } from 'should-handle-link';
export { shouldHandle } from 'should-handle-link';

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
      // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
      return klass => properLinks(args[0], klass);
    } else {
      klass = args[0];
    }
  }
  const ignore = options.ignore || [];
  assert(`klass was not defined. possibile incorrect arity given to properLinks`, klass);
  return class RouterWithProperLinks extends klass {
    // SAFETY: we literally do not care about the args' type here,
    //         because we just call super
    constructor(...args) {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-argument
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
function handle(router, element, ignore, event) {
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

export { handle, properLinks, setup };
//# sourceMappingURL=proper-links.js.map
