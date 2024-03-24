import Component from '@glimmer/component';
import { assert } from '@ember/debug';
import { service } from '@ember/service';
import { handle } from '../proper-links.js';
import { ExternalLink } from './external-link.js';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i } from 'decorator-transforms/runtime';

/**
 * TODO: make template-only component,
 * and use class-based modifier?
 *
 * This would require that modifiers could run pre-render
 */
/**
 * A light wrapper around the [Anchor element][mdn-a], which will appropriately make your link an external link if the passed `@href` is not on the same domain.
 *
 *
 * [mdn-a]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/a
 */
class Link extends Component {
  static {
    setComponentTemplate(precompileTemplate("\n    {{#if (isExternal @href)}}\n      <ExternalLink href={{@href}} ...attributes>\n        {{yield (hash isExternal=true isActive=false)}}\n      </ExternalLink>\n    {{else}}\n      <a data-active={{this.isActive}} href={{if @href @href \"##missing##\"}} {{on \"click\" this.handleClick}} ...attributes>\n        {{yield (hash isExternal=false isActive=this.isActive)}}\n      </a>\n    {{/if}}\n  ", {
      scope: () => ({
        isExternal,
        ExternalLink,
        hash,
        on
      }),
      strictMode: true
    }), this);
  }
  static {
    g(this.prototype, "router", [service]);
  }
  #router = (i(this, "router"), void 0);
  handleClick = event1 => {
    assert('[BUG]', event1.target instanceof HTMLAnchorElement);
    handle(this.router, event1.target, [], event1);
  };
  get isActive() {
    let {
      href: href1,
      includeActiveQueryParams: includeActiveQueryParams1
    } = this.args;
    return isActive(this.router, href1, includeActiveQueryParams1);
  }
}
function isExternal(href1) {
  if (!href1) return false;
  if (href1.startsWith('#')) return false;
  if (href1.startsWith('/')) return false;
  return location.origin !== new URL(href1).origin;
}
function isActive(router1, href1, includeQueryParams1) {
  if (!includeQueryParams1) {
    /**
    * is Active doesn't understand `href`, so we have to convert to RouteInfo-esque
    */
    let info1 = router1.recognize(href1);
    if (info1) {
      let dynamicSegments1 = getParams(info1);
      return router1.isActive(info1.name, ...dynamicSegments1);
    }
    return false;
  }
  let url1 = new URL(href1, location.origin);
  let hrefQueryParams1 = new URLSearchParams(url1.searchParams);
  let hrefPath1 = url1.pathname;
  const currentPath1 = router1.currentURL?.split('?')[0];
  if (!currentPath1) return false;
  if (hrefPath1 !== currentPath1) return false;
  const currentQueryParams1 = router1.currentRoute?.queryParams;
  if (!currentQueryParams1) return false;
  if (includeQueryParams1 === true) {
    return Object.entries(currentQueryParams1).every(([key1, value1]) => {
      return hrefQueryParams1.get(key1) === value1;
    });
  }
  return includeQueryParams1.every(key1 => {
    return hrefQueryParams1.get(key1) === currentQueryParams1[key1];
  });
}
function getParams(currentRouteInfo1) {
  let params1 = [];
  while (currentRouteInfo1?.parent) {
    let currentParams1 = currentRouteInfo1.params;
    params1 = currentParams1 ? [currentParams1, ...params1] : params1;
    currentRouteInfo1 = currentRouteInfo1.parent;
  }
  return params1.map(Object.values).flat();
}

export { Link, Link as default };
//# sourceMappingURL=link.js.map
