import { getPromiseState } from 'reactiveweb/get-promise-state';
import type { Newable } from './type-utils.ts';
/**
 * Instantiates a class once per application instance.
 *
 *
 */
export declare function createService<Instance extends object>(context: object, theClass: Newable<Instance> | (() => Instance)): Instance;
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
export declare function createAsyncService<Instance extends object>(context: object, theClass: () => Promise<Newable<Instance> | (() => Instance)>): ReturnType<typeof getPromiseState<unknown, Instance>>;
//# sourceMappingURL=service.d.ts.map