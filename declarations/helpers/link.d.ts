import Helper from '@ember/component/helper';
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
    router: RouterService;
    compute([href]: [href: string], { includeActiveQueryParams, activeOnSubPaths, }: {
        includeActiveQueryParams?: boolean | string[];
        activeOnSubPaths?: boolean;
    }): {
        isExternal: boolean;
        readonly isActive: boolean;
        handleClick: (event: MouseEvent) => void;
    };
}
export declare const link: typeof Link;
export declare function isExternal(href: string): boolean;
export declare function isActive(router: RouterService, href: string, includeQueryParams?: boolean | string[], activeOnSubPaths?: boolean): boolean;
type RouteInfo = ReturnType<RouterService['recognize']>;
export declare function getParams(currentRouteInfo: RouteInfo): any[];
export {};
//# sourceMappingURL=link.d.ts.map