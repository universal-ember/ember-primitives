import type { TOC } from '@ember/component/template-only';
export declare const PageLoader: TOC<{
    Blocks: {
        defaultl: [];
    };
}>;
export declare function hasReason(error: unknown): error is {
    reason: string;
    original: Error;
};
export declare const PageError: TOC<{
    Args: {
        error: string | {
            reason: string;
            original: Error;
        };
    };
}>;
export declare const PageLayout: TOC<{
    Blocks: {
        logoLink: [];
        topRight: [];
        editLink: [typeof EditLink];
        error: [error: string | {
            reason: string;
            original: Error;
        }];
    };
}>;
declare const EditLink: TOC<{
    Args: {
        href: string;
    };
    Blocks: {
        default: [];
    };
}>;
export declare const TopRight: TOC<{
    Blocks: {
        default: [];
    };
}>;
export {};
//# sourceMappingURL=page-layout.d.ts.map