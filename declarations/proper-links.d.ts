import type RouterService from '@ember/routing/router-service';
export interface Options {
    ignore?: string[];
}
export declare function properLinks(options: Options): <Instance extends {}, Klass = {
    new (...args: any[]): Instance;
}>(klass: Klass) => Klass;
export declare function properLinks<Instance extends {}, Klass = {
    new (...args: any[]): Instance;
}>(klass: Klass): Klass;
/**
 * @internal
 */
export declare function properLinks<Instance extends {}, Klass = {
    new (...args: any[]): Instance;
}>(options: Options, klass: Klass): Klass;
/**
 * Setup proper links without a decorator.
 * This function only requires that a framework object with an owner is passed.
 */
export declare function setup(parent: object, ignore?: string[]): void;
export declare function isLink(event: Event): HTMLAnchorElement | undefined;
export declare function handle(router: RouterService, element: HTMLAnchorElement, ignore: string[], event: MouseEvent): false | undefined;
//# sourceMappingURL=proper-links.d.ts.map