import type { FlipOptions, HideOptions, Middleware, OffsetOptions, Placement, ShiftOptions, Strategy } from '@floating-ui/dom';
export interface Signature {
    /**
     *
     */
    Element: HTMLElement;
    Args: {
        Positional: [
            /**
             * What do use as the reference element.
             * Can be a selector or element instance.
             *
             * Example:
             * ```gjs
             * import { anchorTo } from 'ember-primitives/floating-ui';
             *
             * <template>
             *   <div id="reference">...</div>
             *   <div {{anchorTo "#reference"}}> ... </div>
             * </template>
             * ```
             */
            referenceElement: string | HTMLElement | SVGElement
        ];
        Named: {
            /**
             * This is the type of CSS position property to use.
             * By default this is 'fixed', but can also be 'absolute'.
             *
             * See: [The strategy docs](https://floating-ui.com/docs/computePosition#strategy)
             */
            strategy?: Strategy;
            /**
             * Options to pass to the [offset middleware](https://floating-ui.com/docs/offset)
             */
            offsetOptions?: OffsetOptions;
            /**
             * Where to place the floating element relative to its reference element.
             * The default is 'bottom'.
             *
             * See: [The placement docs](https://floating-ui.com/docs/computePosition#placement)
             */
            placement?: Placement;
            /**
             * Options to pass to the [flip middleware](https://floating-ui.com/docs/flip)
             */
            flipOptions?: FlipOptions;
            /**
             * Options to pass to the [shift middleware](https://floating-ui.com/docs/shift)
             */
            shiftOptions?: ShiftOptions;
            /**
             * Options to pass to the [hide middleware](https://floating-ui.com/docs/hide)
             */
            hideOptions?: HideOptions;
            /**
             * Additional middleware to pass to FloatingUI.
             *
             * See: [The middleware docs](https://floating-ui.com/docs/middleware)
             */
            middleware?: Middleware[];
            /**
             * A callback for when data changes about the position / placement / etc
             * of the floating element.
             */
            setData?: Middleware['fn'];
        };
    };
}
/**
 * A modifier to apply to the _floating_ element.
 * This is what will anchor to the reference element.
 *
 * Example
 * ```gjs
 * import { anchorTo } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <button id="my-button"> ... </button>
 *   <menu {{anchorTo "#my-button"}}> ... </menu>
 * </template>
 * ```
 */
export declare const anchorTo: import("ember-modifier").FunctionBasedModifier<{
    Element: HTMLElement;
    Args: {
        Named: {
            /**
             * This is the type of CSS position property to use.
             * By default this is 'fixed', but can also be 'absolute'.
             *
             * See: [The strategy docs](https://floating-ui.com/docs/computePosition#strategy)
             */
            strategy?: Strategy;
            /**
             * Options to pass to the [offset middleware](https://floating-ui.com/docs/offset)
             */
            offsetOptions?: OffsetOptions;
            /**
             * Where to place the floating element relative to its reference element.
             * The default is 'bottom'.
             *
             * See: [The placement docs](https://floating-ui.com/docs/computePosition#placement)
             */
            placement?: Placement;
            /**
             * Options to pass to the [flip middleware](https://floating-ui.com/docs/flip)
             */
            flipOptions?: FlipOptions;
            /**
             * Options to pass to the [shift middleware](https://floating-ui.com/docs/shift)
             */
            shiftOptions?: ShiftOptions;
            /**
             * Options to pass to the [hide middleware](https://floating-ui.com/docs/hide)
             */
            hideOptions?: HideOptions;
            /**
             * Additional middleware to pass to FloatingUI.
             *
             * See: [The middleware docs](https://floating-ui.com/docs/middleware)
             */
            middleware?: Middleware[];
            /**
             * A callback for when data changes about the position / placement / etc
             * of the floating element.
             */
            setData?: Middleware["fn"];
        };
        Positional: [referenceElement: string | HTMLElement | SVGElement];
    };
}>;
//# sourceMappingURL=modifier.d.ts.map