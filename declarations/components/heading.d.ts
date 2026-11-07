import Component from "@glimmer/component";
import type Owner from "@ember/owner";
export declare class Heading extends Component<{
    Element: HTMLElement;
    Blocks: {
        default: [];
    };
}> {
    headingScopeAnchor: Text;
    constructor(owner: Owner, args: object);
    get level(): 2 | 1 | 3 | 4 | 5 | 6;
    get hLevel(): string;
}
//# sourceMappingURL=heading.d.ts.map