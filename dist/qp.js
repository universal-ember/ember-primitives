
import Helper from '@ember/component/helper';
import { assert } from '@ember/debug';
import { service } from '@ember/service';
import { g, i } from 'decorator-transforms/runtime';

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
class qp extends Helper {
  static {
    g(this.prototype, "router", [service]);
  }
  #router = (i(this, "router"), void 0);
  compute([name]) {
    assert('A queryParam name is required', name);
    return this.router.currentRoute?.queryParams?.[name];
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
class withQP extends Helper {
  static {
    g(this.prototype, "router", [service]);
  }
  #router = (i(this, "router"), void 0);
  compute([qpName, nextValue]) {
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
 * ```gjs
 * import { castToBoolean, qp } from 'ember-primitives/qp';
 *
 * <template>
 *  {{#if (castToBoolean (qp 'the-qp'))}}
 *    ...
 *  {{/if}}
 * </template>
 * ```
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
function castToBoolean(x) {
  if (!x) return false;
  const isFalsey = x === '0' || x === 'false' || x === 'f' || x === 'null' || x === 'off' || x === 'undefined' || x === 'no';
  if (isFalsey) return false;

  // All other values are considered truthy
  return true;
}

export { castToBoolean, qp, withQP };
//# sourceMappingURL=qp.js.map
