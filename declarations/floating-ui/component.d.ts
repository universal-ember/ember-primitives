import Component from '@glimmer/component';
import VelcroModifier from './modifier.ts';
import type { Signature as ModifierSignature } from './modifier.ts';
import type { MiddlewareState } from '@floating-ui/dom';
import type { WithBoundArgs, WithBoundPositionals } from '@glint/template';
import type { ModifierLike } from '@glint/template';
type ModifierArgs = ModifierSignature['Args']['Named'];
interface HookSignature {
    Element: HTMLElement | SVGElement;
}
export interface Signature {
    Args: {
        middleware?: ModifierArgs['middleware'];
        placement?: ModifierArgs['placement'];
        strategy?: ModifierArgs['strategy'];
        flipOptions?: ModifierArgs['flipOptions'];
        hideOptions?: ModifierArgs['hideOptions'];
        shiftOptions?: ModifierArgs['shiftOptions'];
        offsetOptions?: ModifierArgs['offsetOptions'];
    };
    Blocks: {
        default: [
            velcro: {
                hook: ModifierLike<HookSignature>;
                setHook: (element: HTMLElement | SVGElement) => void;
                loop?: WithBoundArgs<WithBoundPositionals<typeof VelcroModifier, 1>, keyof ModifierArgs>;
                data?: MiddlewareState;
            }
        ];
    };
}
export default class Velcro extends Component<Signature> {
    hook?: HTMLElement | SVGElement;
    velcroData?: MiddlewareState;
    setVelcroData: ModifierArgs['setVelcroData'];
    setHook: (element: HTMLElement | SVGElement) => void;
}
export {};
//# sourceMappingURL=component.d.ts.map