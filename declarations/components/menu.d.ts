import Component from '@glimmer/component';
import { cell } from 'ember-resources';
import { type Signature as PopoverSignature } from "./popover";
import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';
type Cell<V> = ReturnType<typeof cell<V>>;
type PopoverArgs = PopoverSignature['Args'];
type PopoverBlockParams = PopoverSignature['Blocks']['default'][0];
export interface Signature {
    Args: PopoverArgs;
    Blocks: {
        default: [
            {
                arrow: PopoverBlockParams['arrow'];
                trigger: WithBoundArgs<typeof trigger, 'triggerElement' | 'contentId' | 'isOpen' | 'setReference'>;
                Trigger: WithBoundArgs<typeof Trigger, 'triggerModifier'>;
                Content: WithBoundArgs<typeof Content, 'triggerElement' | 'contentId' | 'isOpen' | 'PopoverContent'>;
                isOpen: boolean;
            }
        ];
    };
}
export interface SeparatorSignature {
    Element: HTMLDivElement;
    Blocks: {
        default: [];
    };
}
declare const Separator: TOC<SeparatorSignature>;
export interface ItemSignature {
    Element: HTMLButtonElement;
    Args: {
        onSelect?: (event: Event) => void;
    };
    Blocks: {
        default: [];
    };
}
declare const Item: TOC<ItemSignature>;
interface PrivateContentSignature {
    Element: HTMLDivElement;
    Args: {
        triggerElement: Cell<HTMLElement>;
        contentId: string;
        isOpen: Cell<boolean>;
        PopoverContent: PopoverBlockParams['Content'];
    };
    Blocks: {
        default: [{
            Item: typeof Item;
            Separator: typeof Separator;
        }];
    };
}
export interface ContentSignature {
    Element: PrivateContentSignature['Element'];
    Blocks: PrivateContentSignature['Blocks'];
}
declare const Content: TOC<PrivateContentSignature>;
interface PrivateTriggerModifierSignature {
    Element: HTMLElement;
    Args: {
        Named: {
            triggerElement: Cell<HTMLElement>;
            isOpen: Cell<boolean>;
            contentId: string;
            setReference: PopoverBlockParams['setReference'];
            stopPropagation?: boolean;
            preventDefault?: boolean;
        };
    };
}
export interface TriggerModifierSignature {
    Element: PrivateTriggerModifierSignature['Element'];
}
declare const trigger: import("ember-modifier").FunctionBasedModifier<{
    Element: HTMLElement;
    Args: {
        Named: {
            triggerElement: Cell<HTMLElement>;
            isOpen: Cell<boolean>;
            contentId: string;
            setReference: PopoverBlockParams["setReference"];
            stopPropagation?: boolean;
            preventDefault?: boolean;
        };
        Positional: [];
    };
}>;
interface PrivateTriggerSignature {
    Element: HTMLButtonElement;
    Args: {
        triggerModifier: WithBoundArgs<typeof trigger, 'triggerElement' | 'contentId' | 'isOpen' | 'setReference'>;
        stopPropagation?: boolean;
        preventDefault?: boolean;
    };
    Blocks: {
        default: [];
    };
}
export interface TriggerSignature {
    Element: PrivateTriggerSignature['Element'];
    Blocks: PrivateTriggerSignature['Blocks'];
}
declare const Trigger: TOC<PrivateTriggerSignature>;
export declare class Menu extends Component<Signature> {
    contentId: string;
}
export default Menu;
//# sourceMappingURL=menu.d.ts.map