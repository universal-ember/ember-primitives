import type { ComponentIcons, StringIcons } from "./public-types.ts";
import type { TOC } from "@ember/component/template-only";
export declare const Stars: TOC<{
    Args: {
        stars: number[];
        icon: StringIcons["icon"] | ComponentIcons["icon"];
        isReadonly: boolean;
        name: string;
        currentValue: number;
        total: number;
    };
}>;
//# sourceMappingURL=stars.d.ts.map