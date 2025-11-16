import { getOwner } from '@ember/owner';

import type Owner from '@ember/owner';

// this is copy pasted from https://github.com/emberjs/ember.js/blob/60d2e0cddb353aea0d6e36a72fda971010d92355/packages/%40ember/-internals/glimmer/lib/helpers/unique-id.ts
// Unfortunately due to https://github.com/emberjs/ember.js/issues/20165 we cannot use the built-in version in template tags
export function uniqueId(): string {
  // @ts-expect-error this one-liner abuses weird JavaScript semantics that
  // TypeScript (legitimately) doesn't like, but they're nonetheless valid and
  // specced.
  // eslint-disable-next-line @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call, @typescript-eslint/restrict-plus-operands, @typescript-eslint/no-unsafe-member-access
  return ([3e7] + -1e3 + -4e3 + -2e3 + -1e11).replace(/[0-3]/g, (a) =>
    ((a * 4) ^ ((Math.random() * 16) >> (a & 2))).toString(16)
  );
}

export function isNewable(x: any): x is new (...args: unknown[]) => NonNullable<object> {
  // TypeScript has really bad prototype support -- they don't really
  // want folks using this sort of stuff -- but it's handy for perf and all that.
  //
  // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
  return x.prototype?.constructor === x;
}

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
export function isOwner(x: unknown): x is Owner {
  if (!isNonNullableObject(x)) return false;

  return 'lookup' in x && typeof x.lookup === 'function';
}

export function isNonNullableObject(x: unknown): x is NonNullable<object> {
  if (typeof x !== 'object') return false;
  if (x === null) return false;

  return true;
}

/**
 * Can receive the class instance or the owner itself, and will always return return the owner.
 *
 * undefined will be returned if the Owner does not exist on the passed object
 *
 * Can be useful when combined with `createStore` to then create "services",
 * which don't require string lookup.
 */
export function findOwner(contextOrOwner: unknown): Owner | undefined {
  if (isOwner(contextOrOwner)) return contextOrOwner;

  // _ENSURE_ that we have an object, else getOwner makes no sense to call
  if (!isNonNullableObject(contextOrOwner)) return;

  const maybeOwner = getOwner(contextOrOwner);

  if (isOwner(maybeOwner)) return maybeOwner;

  return;
}
