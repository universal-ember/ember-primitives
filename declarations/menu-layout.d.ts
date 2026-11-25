import type { TOC } from '@ember/component/template-only';
import type { ComponentLike, WithBoundArgs } from '@glint/template';
declare const Toggle: TOC<{
    Args: {
        toggle: ComponentLike<{
            Blocks: {
                default: [];
            };
        }>;
    };
}>;
export declare const ResponsiveMenuLayout: TOC<{
    Blocks: {
        content: [];
        header: [toggle: WithBoundArgs<typeof Toggle, 'toggle'>];
    };
}>;
export {};
//# sourceMappingURL=menu-layout.d.ts.map