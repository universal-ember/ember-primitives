import { assert } from '@ember/debug';
import { service as emberService } from '@ember/service';

import type { Newable } from './type-utils.ts';
import type { Registry } from '@ember/service';
import type Service from '@ember/service';

type Decorator = ReturnType<typeof emberService>;

export function service<Key extends keyof Registry>(
  context: object,
  serviceName: Key
): Registry[Key] & Service;
export function service<Class extends object>(
  context: object,
  serviceDefinition: Newable<Class>
): Class;
export function service<Class extends object>(serviceDefinition: Newable<Class>): Decorator;
export function service<Key extends keyof Registry>(serviceName: string): Decorator;
export function service(prototype: object, name: string | symbol, descriptor?: unknown): void;

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
 * class Demo extends Component {
 *   @service(State) state;
 * }
 * ```
 *
 * Additionally for better TypeScript type-inference, this alternate invocation syntax is allowed:
 * ```js
 * class Demo extends Component {
 *   state = service(this, State);
 * }
 * ```
 */
export function service(...args: any[]) {
  /**
   * Stage 1 / Legacy Decorators (original ember service)
   */
  if (args.length === 3) {
    return emberService(...(args as Parameters<typeof emberService>));
  }

  /**
   * This is either:
   * - spec decorator
   * - or non-decorator usage (requiring a this parameter to be passed for the first)
   */
  if (args.length === 2) {
    if (typeof args[1] === 'object' && args[1]) {
      if ('kind' in args[1]) {
        assert(
          `TC39 Spec decorators are not yet supported. If you see this error, please open an issue at https://github.com/universal-ember/ember-primitives/ -- also!, congratulations for being an early adopter of real decorators!`
        );
      }
    }

    return inlineSerice(...args);
  }

  if (args.length === 1) {
    /**
     * Traditional string-based service usage
     */
    if (typeof args[0] === 'string') {
      return emberService(...args);
    }
  }
}

function concreteService<Class>(definition: Newable<Class>): Decorator {}

function inlineService(context: object, service: string | object | Function) {}
