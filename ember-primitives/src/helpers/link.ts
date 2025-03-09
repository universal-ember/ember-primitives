import Helper from '@ember/component/helper';
import { assert } from '@ember/debug';
import { service } from '@ember/service';

import { handle } from '../proper-links.ts';

import type RouterService from '@ember/routing/router-service';

export interface Signature {
  Args: {
    Positional: [href: string];
    Named: {
      includeActiveQueryParams?: boolean | string[];
      activeOnSubPaths?: boolean;
    };
  };
  Return: {
    isExternal: boolean;
    isActive: boolean;
    handleClick: (event: MouseEvent) => void;
  };
}

export default class Link extends Helper<Signature> {
  @service declare router: RouterService;

  compute(
    [href]: [href: string],
    {
      includeActiveQueryParams = false,
      activeOnSubPaths = false,
    }: { includeActiveQueryParams?: boolean | string[]; activeOnSubPaths?: boolean }
  ) {
    assert('href was not passed in', href);

    const router = this.router;
    const handleClick = (event: MouseEvent) => {
      assert('[BUG]', event.target instanceof HTMLAnchorElement);

      handle(router, event.target, [], event);
    };

    return {
      isExternal: isExternal(href),
      get isActive() {
        return isActive(router, href, includeActiveQueryParams, activeOnSubPaths);
      },
      handleClick,
    };
  }
}

export const link = Link;

export function isExternal(href: string) {
  if (!href) return false;
  if (href.startsWith('#')) return false;
  if (href.startsWith('/')) return false;

  return location.origin !== new URL(href).origin;
}

export function isActive(
  router: RouterService,
  href: string,
  includeQueryParams?: boolean | string[],
  activeOnSubPaths?: boolean
) {
  if (!includeQueryParams) {
    /**
     * is Active doesn't understand `href`, so we have to convert to RouteInfo-esque
     */
    const info = router.recognize(href);

    if (info) {
      const dynamicSegments = getParams(info);
      const routeName = activeOnSubPaths ? info.name.replace(/\.index$/, '') : info.name;

      return router.isActive(routeName, ...dynamicSegments);
    }

    return false;
  }

  const url = new URL(href, location.origin);
  const hrefQueryParams = new URLSearchParams(url.searchParams);
  const hrefPath = url.pathname;

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

  return includeQueryParams.every((key) => {
    return hrefQueryParams.get(key) === currentQueryParams[key];
  });
}

type RouteInfo = ReturnType<RouterService['recognize']>;

export function getParams(currentRouteInfo: RouteInfo) {
  let params: Record<string, string | unknown | undefined>[] = [];

  while (currentRouteInfo?.parent) {
    const currentParams = currentRouteInfo.params;

    params = currentParams ? [currentParams, ...params] : params;
    currentRouteInfo = currentRouteInfo.parent;
  }

  return params.map(Object.values).flat();
}
