import type Owner from '@ember/owner';
export declare function uniqueId(): string;
export declare function isNewable(x: any): x is new (...args: unknown[]) => NonNullable<object>;
/**
 * Loose check for an "ownerish" API.
 * only the ".lookup" method is required.
 *
 * The requirements for what an "owner" is are sort of undefined,
 * as the actual owner in ember applications has too much on it,
 * and the long term purpose of the owner will be questioned once we
 * eliminate the need to have a registry (what lookup looks in to),
 * but we'll still need "Something" to represent the lifetime of the application.
 *
 * Technically, the owner could be any object, including `{}`
 */
export declare function isOwner(x: unknown): x is Owner;
export declare function isNonNullableObject(x: unknown): x is NonNullable<object>;
/**
 * Can receive the class instance or the owner itself, and will always return return the owner.
 *
 * undefined will be returned if the Owner does not exist on the passed object
 *
 * Can be useful when combined with `createStore` to then create "services",
 * which don't require string lookup.
 */
export declare function findOwner(contextOrOwner: unknown): Owner | undefined;
//# sourceMappingURL=utils.d.ts.map