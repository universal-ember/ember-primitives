import Helper from '@ember/component/helper';
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
export declare class qp extends Helper<Signature> {
    router: RouterService;
    compute([name]: [string]): string | undefined;
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
export declare class withQP extends Helper<{
    Args: {
        Positional: [string, string];
    };
    Return: string;
}> {
    router: RouterService;
    compute([qpName, nextValue]: [string, string]): string;
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
export declare function castToBoolean(x: string | undefined): boolean;
export {};
//# sourceMappingURL=qp.d.ts.map