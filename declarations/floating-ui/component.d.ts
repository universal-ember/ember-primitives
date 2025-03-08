import Component from '@glimmer/component';
import { anchorTo } from './modifier.ts';
import type { Signature as ModifierSignature } from './modifier.ts';
import type { MiddlewareState } from '@floating-ui/dom';
import type { WithBoundArgs, WithBoundPositionals } from '@glint/template';
import type { ModifierLike } from '@glint/template';
type ModifierArgs = ModifierSignature['Args']['Named'];
interface ReferenceSignature {
    Element: HTMLElement | SVGElement;
}
export interface Signature {
    Args: {
        /**
         * Additional middleware to pass to FloatingUI.
         *
         * See: [The middleware docs](https://floating-ui.com/docs/middleware)
         */
        middleware?: ModifierArgs['middleware'];
        /**
         * Where to place the floating element relative to its reference element.
         * The default is 'bottom'.
         *
         * See: [The placement docs](https://floating-ui.com/docs/computePosition#placement)
         */
        placement?: ModifierArgs['placement'];
        /**
         * This is the type of CSS position property to use.
         * By default this is 'fixed', but can also be 'absolute'.
         *
         * See: [The strategy docs](https://floating-ui.com/docs/computePosition#strategy)
         */
        strategy?: ModifierArgs['strategy'];
        /**
         * Options to pass to the [flip middleware](https://floating-ui.com/docs/flip)
         */
        flipOptions?: ModifierArgs['flipOptions'];
        /**
         * Options to pass to the [hide middleware](https://floating-ui.com/docs/hide)
         */
        hideOptions?: ModifierArgs['hideOptions'];
        /**
         * Options to pass to the [shift middleware](https://floating-ui.com/docs/shift)
         */
        shiftOptions?: ModifierArgs['shiftOptions'];
        /**
         * Options to pass to the [offset middleware](https://floating-ui.com/docs/offset)
         */
        offsetOptions?: ModifierArgs['offsetOptions'];
    };
    Blocks: {
        default: [
            /**
             * A modifier to apply to the _reference_ element.
             * This is what the floating element will use to anchor to.
             *
             * Example
             * ```gjs
             * import { FloatingUI } from 'ember-primitives/floating-ui';
             *
             * <template>
             *   <FloatingUI as |reference floating|>
             *     <button {{reference}}> ... </button>
             *     ...
             *   </FloatingUI>
             * </template>
             * ```
             */
            reference: ModifierLike<ReferenceSignature>,
            /**
             * A modifier to apply to the _floating_ element.
             * This is what will anchor to the reference element.
             *
             * Example
             * ```gjs
             * import { FloatingUI } from 'ember-primitives/floating-ui';
             *
             * <template>
             *   <FloatingUI as |reference floating|>
             *     <button {{reference}}> ... </button>
             *     <menu {{floating}}> ... </menu>
             *   </FloatingUI>
             * </template>
             * ```
             */
            floating: undefined | WithBoundArgs<WithBoundPositionals<typeof anchorTo, 1>, keyof ModifierArgs>,
            /**
             * Special utilities for advanced usage
             */
            util: {
                /**
                 * If you want to have a single modifier with custom behavior
                 * on your reference element, you may use this `setReference`
                 * function to set the reference, rather than having multiple modifiers
                 * on that element.
                 */
                setReference: (element: HTMLElement | SVGElement) => void;
                /**
                 * Metadata exposed from floating-ui.
                 * Gives you x, y position, among other things.
                 */
                data?: MiddlewareState;
            }
        ];
    };
}
/**
 * A component that provides no DOM and yields two modifiers for creating
 * creating floating uis, such as menus, popovers, tooltips, etc.
 * This component currently uses [Floating UI](https://floating-ui.com/)
 * but will be switching to [CSS Anchor Positioning](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_anchor_positioning) when that lands.
 *
 * Example usage:
 * ```gjs
 * import { FloatingUI } from 'ember-primitives/floating-ui';
 *
 * <template>
 *   <FloatingUI as |reference floating|>
 *     <button {{reference}}> ... </button>
 *     <menu {{floating}}> ... </menu>
 *   </FloatingUI>
 * </template>
 * ```
 */
export declare class FloatingUI extends Component<Signature> {
    reference?: HTMLElement | SVGElement;
    data?: MiddlewareState;
    setData: ModifierArgs['setData'];
    setReference: (element: HTMLElement | SVGElement) => void;
}
export {};
//# sourceMappingURL=component.d.ts.map