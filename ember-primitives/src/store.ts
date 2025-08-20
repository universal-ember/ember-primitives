import { link } from 'reactiveweb/link';

import { isNewable } from './utils.ts';

import type { Newable } from './type-utils.ts';

/**
 * context => { class => instance }
 */
const contextCache = new WeakMap<object, Map<object, object>>();

/**
 * Creates a singleton for the given context and links the lifetime of the created class to the passed context
 *
 * Note that this function is _not_ lazy. Calling `createStore` will create an instance of the passed class.
 * When combined with a getter though, creation becomes lazy.
 *
 * In this example, `MyState` is created once per instance of the component.
 * repeat accesses to `this.foo` return a stable reference _as if_ `@cached` were used.
 * ```js
 * class MyState {}
 *
 * class Demo extends Component {
 *   // this is a stable reference
 *   get foo() {
 *     return createStore(this, MyState);
 *   }
 *
 *   // or
 *   bar = createStore(this, MyState);
 *
 *  // or
 *  three = createStore(this, () => new MyState(1, 2));
 * }
 * ```
 *
 * If arguments need to be configured during construction, the second argument may also be a function
 * ```js
 * class MyState {}
 *
 * class Demo extends Component {
 *   // this is a stable reference
 *   get foo() {
 *     return createStore(this, MyState);
 *   }
 * }
 * ```
 */
export function createStore<Instance extends object>(
  context: object,
  theClass: Newable<Instance> | (() => Instance)
): Instance {
  let cache = contextCache.get(context);

  if (!cache) {
    cache = new Map();
    contextCache.set(context, cache);
  }

  let existing = cache.get(theClass);

  if (!existing) {
    const instance = isNewable(theClass) ? new theClass() : theClass();

    link(instance, context);

    cache.set(theClass, instance);
    existing = instance;
  }

  return existing as Instance;
}
