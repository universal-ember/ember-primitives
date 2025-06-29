import Helper from '@ember/component/helper';
import { assert } from '@ember/debug';
import { service } from '@ember/service';

import type RouterService from '@ember/routing/router-service';

export interface Signature {
  Args: {
    Positional: [string];
  };
  Return: string | undefined;
}

class QP extends Helper<Signature> {
  @service declare router: RouterService;

  compute([name]: [string]): string | undefined {
    assert('A queryParam name is required', name);

    return this.router.currentRoute?.queryParams?.[name] as string | undefined;
  }
}

export const qp = QP;

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
