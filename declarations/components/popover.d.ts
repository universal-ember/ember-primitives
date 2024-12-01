import { cell } from 'ember-resources';
import type { Signature as FloatingUiComponentSignature } from '../floating-ui/component.ts';
import type { Signature as HookSignature } from '../floating-ui/modifier.ts';
import type { TOC } from '@ember/component/template-only';
import type { ModifierLike, WithBoundArgs } from '@glint/template';
export interface Signature {
    Args: {
        /**
         * See the Floating UI's [flip docs](https://floating-ui.com/docs/flip) for possible values.
         *
         * This argument is forwarded to the `<FloatingUI>` component.
         */
        flipOptions?: HookSignature['Args']['Named']['flipOptions'];
        /**
         * Array of one or more objects to add to Floating UI's list of [middleware](https://floating-ui.com/docs/middleware)
         *
         * This argument is forwarded to the `<FloatingUI>` component.
         */
        middleware?: HookSignature['Args']['Named']['middleware'];
        /**
         * See the Floating UI's [offset docs](https://floating-ui.com/docs/offset) for possible values.
         *
         * This argument is forwarded to the `<FloatingUI>` component.
         */
        offsetOptions?: HookSignature['Args']['Named']['offsetOptions'];
        /**
         * One of the possible [`placements`](https://floating-ui.com/docs/computeposition#placement). The default is 'bottom'.
         *
         * Possible values are
         * - top
         * - bottom
         * - right
         * - left
         *
         * And may optionally have `-start` or `-end` added to adjust position along the side.
         *
         * This argument is forwarded to the `<FloatingUI>` component.
         */
        placement?: `${'top' | 'bottom' | 'left' | 'right'}${'' | '-start' | '-end'}`;
        /**
         * See the Floating UI's [shift docs](https://floating-ui.com/docs/shift) for possible values.
         *
         * This argument is forwarded to the `<FloatingUI>` component.
         */
        shiftOptions?: HookSignature['Args']['Named']['shiftOptions'];
        /**
         * CSS position property, either `fixed` or `absolute`.
         *
         * Pros and cons of each strategy are explained on [Floating UI's Docs](https://floating-ui.com/docs/computePosition#strategy)
         *
         * This argument is forwarded to the `<FloatingUI>` component.
         */
        strategy?: HookSignature['Args']['Named']['strategy'];
        /**
         * By default, the popover is portaled.
         * If you don't control your CSS, and the positioning of the popover content
         * is misbehaving, you may pass "@inline={{true}}" to opt out of portalling.
         *
         * Inline may also be useful in nested menus, where you know exactly how the nesting occurs
         */
        inline?: boolean;
    };
    Blocks: {
        default: [
            {
                reference: FloatingUiComponentSignature['Blocks']['default'][0];
                setReference: FloatingUiComponentSignature['Blocks']['default'][2]['setReference'];
                Content: WithBoundArgs<typeof Content, 'floating'>;
                data: FloatingUiComponentSignature['Blocks']['default'][2]['data'];
                arrow: WithBoundArgs<ModifierLike<AttachArrowSignature>, 'arrowElement' | 'data'>;
            }
        ];
    };
}
/**
 * Allows lazy evaluation of the portal target (do nothing until rendered)
 * This is useful because the algorithm for finding the portal target isn't cheap.
 */
declare const Content: TOC<{
    Element: HTMLDivElement;
    Args: {
        floating: ModifierLike<{
            Element: HTMLElement;
        }>;
        inline?: boolean;
        /**
         * By default the popover content is wrapped in a div.
         * You may change this by supplying the name of an element here.
         *
         * For example:
         * ```gjs
         * <Popover as |p|>
         *  <p.Content @as="dialog">
         *    this is now focus trapped
         *  </p.Content>
         * </Popover>
         * ```
         */
        as?: string;
    };
    Blocks: {
        default: [];
    };
}>;
interface AttachArrowSignature {
    Element: HTMLElement;
    Args: {
        Named: {
            arrowElement: ReturnType<typeof ArrowElement>;
            data?: any;
        };
    };
}
declare const ArrowElement: () => ReturnType<typeof cell<HTMLElement>>;
export declare const Popover: TOC<Signature>;
export default Popover;
//# sourceMappingURL=popover.d.ts.map