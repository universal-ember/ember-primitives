import type { ComponentLike } from "@glint/template";
interface LoadSignature<Expected = {
    Args: any;
}> {
    Blocks: {
        loading: [];
        error: [
            {
                original: unknown;
                reason: string;
            }
        ];
        success?: [component: ComponentLike<Expected>];
    };
}
/**
 * Loads a value / promise / function providing state for the lifetime of that value / promise / function.
 *
 * Can be used for manual bundle splitting via await importing components.
 *
 * @example
 * ```gjs
 * import { load } from 'ember-primitives/load';
 *
 * const Loader = load(() => import('./routes/sub-route'));
 *
 * <template>
 *   <Loader>
 *     <:loading> ... loading ... </:loading>
 *     <:error as |error|> ... error! {{error.reason}} </:error>
 *     <:success as |component|> <component /> </:success>
 *   </Loader>
 * </template>
 * ```
 */
export declare function load<ExpectedSignature, Value>(fn: Value | Promise<Value> | (() => Promise<Value>) | (() => Value)): ComponentLike<LoadSignature<ExpectedSignature>>;
export {};
//# sourceMappingURL=load.d.ts.map