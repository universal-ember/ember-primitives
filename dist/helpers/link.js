import Helper from '@ember/component/helper';
import { assert } from '@ember/debug';
import { service } from '@ember/service';
import { handle } from '../proper-links.js';
import { g, i } from 'decorator-transforms/runtime';

class Link extends Helper {
  static {
    g(this.prototype, "router", [service]);
  }
  #router = (i(this, "router"), void 0);
  compute([href], {
    includeActiveQueryParams = false,
    activeOnSubPaths = false
  }) {
    assert('href was not passed in', href);
    const router = this.router;
    const handleClick = event => {
      assert('[BUG]', event.target instanceof HTMLAnchorElement);
      handle(router, event.target, [], event);
    };
    return {
      isExternal: isExternal(href),
      get isActive() {
        return isActive(router, href, includeActiveQueryParams, activeOnSubPaths);
      },
      handleClick
    };
  }
}
const link = Link;
function isExternal(href) {
  if (!href) return false;
  if (href.startsWith('#')) return false;
  if (href.startsWith('/')) return false;
  return location.origin !== new URL(href).origin;
}
function isActive(router, href, includeQueryParams, activeOnSubPaths) {
  if (!includeQueryParams) {
    /**
     * is Active doesn't understand `href`, so we have to convert to RouteInfo-esque
     */
    let info = router.recognize(href);
    if (info) {
      let dynamicSegments = getParams(info);
      let routeName = activeOnSubPaths ? info.name.replace(/\.index$/, '') : info.name;
      return router.isActive(routeName, ...dynamicSegments);
    }
    return false;
  }
  let url = new URL(href, location.origin);
  let hrefQueryParams = new URLSearchParams(url.searchParams);
  let hrefPath = url.pathname;
  const currentPath = router.currentURL?.split('?')[0];
  if (!currentPath) return false;
  if (activeOnSubPaths ? !currentPath.startsWith(hrefPath) : hrefPath !== currentPath) return false;
  const currentQueryParams = router.currentRoute?.queryParams;
  if (!currentQueryParams) return false;
  if (includeQueryParams === true) {
    return Object.entries(currentQueryParams).every(([key, value]) => {
      return hrefQueryParams.get(key) === value;
    });
  }
  return includeQueryParams.every(key => {
    return hrefQueryParams.get(key) === currentQueryParams[key];
  });
}
function getParams(currentRouteInfo) {
  let params = [];
  while (currentRouteInfo?.parent) {
    let currentParams = currentRouteInfo.params;
    params = currentParams ? [currentParams, ...params] : params;
    currentRouteInfo = currentRouteInfo.parent;
  }
  return params.map(Object.values).flat();
}

export { Link as default, getParams, isActive, isExternal, link };
//# sourceMappingURL=link.js.map
