/**
 * Lazily instantiate a service
 *
 * This is a replacement / alternative API for ember's `@service` decorator from `@ember/service`.
 *
 * For example
 * ```js
 * import { service } from 'ember-primitives/service';
 *
 * class State {
 *   @service router; // also works with the traditional string usage
 * }
 *
 * class Demo {
 *   @service(State) state;
 * }
 * ```
 */
export function service() {}
