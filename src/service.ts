import { assert } from '@ember/debug';

import { getPromiseState } from 'reactiveweb/get-promise-state';

import { createStore } from './store.ts';
import { findOwner } from './utils.ts';

import type { Newable } from './type-utils.ts';

/*
import type { Newable } from './type-utils.ts';
import type { Registry } from '@ember/service';
import type Service from '@ember/service';

type Decorator = ReturnType<typeof emberService>;

// export function service<Key extends keyof Registry>(
//   context: object,
//   serviceName: Key
// ): Registry[Key] & Service;
export function service<Class extends object>(
  context: object,
  serviceDefinition: Newable<Class>
): Class;
export function service<Class extends object>(serviceDefinition: Newable<Class>): Decorator;
export function service<Key extends keyof Registry>(serviceName: Key): Decorator;
export function service(prototype: object, name: string | symbol, descriptor: unknown): void;
export function service<Value, Result>(
  context: object,
  fn: Parameters<typeof getPromiseState<Value, Result>>[0]
): ReturnType<typeof getPromiseState<Value, Result>>;
export function service<Value, Result>(
  fn: Parameters<typeof getPromiseState<Value, Result>>[0]
): Decorator;
*/

/**
 * Instantiates a class once per application instance.
 *
 *
 */
export function createService<Instance extends object>(
  context: object,
  theClass: Newable<Instance> | (() => Instance)
): Instance {
  const owner = findOwner(context);

  assert(
    `Could not find owner / application instance. Cannot create a instance tied to the application lifetime without the application`,
    owner
  );

  return createStore(owner, theClass);
}

const promiseCache = new WeakMap<() => any, unknown>();

/**
 * Lazily instantiate a service.
 *
 * This is a replacement / alternative API for ember's `@service` decorator from `@ember/service`.
 *
 * For example
 * ```js
 * import { service } from 'ember-primitives/service';
 *
 * const loader = () => {
 *   let module = await import('./foo/file/with/class.js');
 *   return () => new module.MyState();
 * }
 *
 * class Demo extends Component {
 *   state = createAsyncService(this, loader);
 * }
 * ```
 *
 * The important thing is for repeat usage of `createAsyncService` the second parameter,
 * (loader in this case), must be shared between all usages.
 *
 * This is an alternative to using `createStore` inside an await'd component,
 * or a component rendered with [`getPromiseState`](https://reactive.nullvoxpopuli.com/functions/get-promise-state.getPromiseState.html)
 * ```
 */
export function createAsyncService<Instance extends object>(
  context: object,
  theClass: () => Promise<Newable<Instance> | (() => Instance)>
): ReturnType<typeof getPromiseState<unknown, Instance>> {
  let existing = promiseCache.get(theClass);

  if (!existing) {
    existing = async () => {
      const result = await theClass();

      // Pay no attention to the lies, I don't know what the right type is here
      return createStore(context, result as Newable<Instance>);
    };

    promiseCache.set(theClass, existing);
  }

  // Pay no attention to the TS inference crime here
  return getPromiseState<unknown, Instance>(existing);
}
