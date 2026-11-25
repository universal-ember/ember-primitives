import type { TOC } from "@ember/component/template-only";
export interface KeyComboSignature {
    Element: HTMLElement;
    Args: {
        keys: string[] | string;
        mac?: string[] | string;
    };
}
export declare const KeyCombo: TOC<KeyComboSignature>;
export interface KeySignature {
    Element: HTMLElement;
    Blocks: {
        default?: [];
    };
}
export declare const Key: TOC<KeySignature>;
//# sourceMappingURL=keys.d.ts.map