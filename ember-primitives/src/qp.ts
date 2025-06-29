import Helper from '@ember/component/helper';
import { assert } from '@ember/debug';
import { service } from '@ember/service';

import type RouterService from '@ember/routing/router-service';

interface Signature {
  Args: {
    Positional: [string];
  };
  Return: string | undefined;
}

/**
 * Grabs a query-param off the current route from the router service.
 *
 * ```gjs
 * import { qp } from 'ember-primitives/qp';
 *
 * <template>
 *  {{qp "query-param"}}
 * </template>
 * ```
 */
export class qp extends Helper<Signature> {
  @service declare router: RouterService;

  compute([name]: [string]): string | undefined {
    assert('A queryParam name is required', name);

    return this.router.currentRoute?.queryParams?.[name] as string | undefined;
  }
}

/**
 * Returns a string for use as an `href` on `<a>` tags, updated with the passed query param
 *
 * ```gjs
 * import { withQP } from 'ember-primitives/qp';
 *
 * <template>
 *   <a href={{withQP "foo" "2"}}>
 *     ...
 *   </a>
 * </template>
 * ```
 */
export class withQP extends Helper<{ Args: { Positional: [string, string] }; Return: string }> {
  @service declare router: RouterService;

  compute([qpName, nextValue]: [string, string]) {
    const existing = this.router.currentURL;

    assert('A queryParam name is required', qpName);
    assert('There is no currentURL', existing);

    const url = new URL(existing, location.origin);

    url.searchParams.set(qpName, nextValue);

    return url.href;
  }
}

/**
 * Cast a query-param string value to a boolean
 *
 * The following values are considered "false"
 * - undefined
 * - ""
 * - "0"
 * - false
 * - "f"
 * - "off"
 * - "no"
 * - "null"
 * - "undefined"
 *
 * All other values are considered truthy
 */
export function castToBoolean(x: string | undefined) {
  if (!x) return false;

  const isFalsey =
    x === '0' ||
    x === 'false' ||
    x === 'f' ||
    x === 'null' ||
    x === 'off' ||
    x === 'undefined' ||
    x === 'no';

  if (isFalsey) return false;

  // All other values are considered truthy
  return true;
}
