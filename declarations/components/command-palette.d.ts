/**
 * References:
 * - https://www.w3.org/WAI/ARIA/apg/patterns/combobox/
 * - https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Reference/Attributes/aria-activedescendant
 *
 * A combobox (the input) over a listbox (the results).
 *
 * Focus never leaves the input; `aria-activedescendant` is what moves. This is
 * why there is no tabster mover here: the arrow keys must not move focus, or
 * the user stops being able to type. Tabster still does the finding.
 *
 * Filtering is not this component's job. Render the results you want, in the
 * order you want.
 */
import Component from "@glimmer/component";
import { type Signature as LinkSignature } from './link';
import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { ModifierLike, WithBoundArgs } from "@glint/template";
export interface ItemSignature {
    Element: HTMLDivElement;
    Blocks: {
        default: [];
    };
}
interface PrivateItemSignature {
    Element: ItemSignature["Element"];
    Args: {
        activeId: string | undefined;
    };
    Blocks: ItemSignature["Blocks"];
}
declare class Item extends Component<PrivateItemSignature> {
    id: string;
    get isActive(): boolean;
}
export interface LinkItemSignature {
    Element: HTMLAnchorElement;
    Args: LinkSignature["Args"];
    Blocks: {
        default: [];
    };
}
interface PrivateLinkItemSignature {
    Element: LinkItemSignature["Element"];
    Args: LinkItemSignature["Args"] & {
        activeId: string | undefined;
    };
    Blocks: LinkItemSignature["Blocks"];
}
/**
 * An option that is also a link. <kbd>Enter</kbd> dispatches a real click on
 * the anchor, so the router navigates exactly as it would have for a mouse.
 */
declare class LinkItem extends Component<PrivateLinkItemSignature> {
    id: string;
    get isActive(): boolean;
}
export interface ListSignature {
    Element: HTMLDivElement;
    Blocks: {
        default: [
            {
                Item: WithBoundArgs<typeof Item, "activeId">;
                LinkItem: WithBoundArgs<typeof LinkItem, "activeId">;
            }
        ];
    };
}
interface PrivateListSignature {
    Element: ListSignature["Element"];
    Args: {
        id: string;
        register: ModifierLike<{
            Element: HTMLElement;
        }>;
        onPointerMove: (event: PointerEvent) => void;
        onClick: (event: MouseEvent) => void;
        item: ListSignature["Blocks"]["default"][0]["Item"];
        linkItem: ListSignature["Blocks"]["default"][0]["LinkItem"];
    };
    Blocks: ListSignature["Blocks"];
}
/**
 * The pointer is handled here rather than on each option, and on
 * `pointermove` rather than `pointerenter`, so that an option under a resting
 * cursor re-activates when the cursor moves after the keyboard has activated
 * something else. Native menus behave this way.
 *
 * `:hover` cannot do this job. There is one active option, it is what
 * <kbd>Enter</kbd> chooses, and it is what `aria-activedescendant` reports.
 * Hovering while the keyboard has a different option active would light two
 * rows and tell a screen reader about neither, so the pointer sets the same
 * state the arrow keys do instead of painting its own.
 */
declare const List: TOC<PrivateListSignature>;
export interface InputSignature {
    Element: HTMLInputElement;
}
interface PrivateInputSignature {
    Element: InputSignature["Element"];
    Args: {
        listId: string;
        activeId: string | undefined;
        query: string;
        onInput: (event: Event) => void;
        onKeydown: (event: KeyboardEvent) => void;
    };
}
declare const Input: TOC<PrivateInputSignature>;
/**
 * One entry in the default layout. A bare string is the label.
 */
export type PaletteItem = string | {
    label: string;
    description?: string;
    icon?: string;
};
/**
 * The default layout: hand it the rows and it renders the whole palette.
 */
export interface ItemsSignature {
    Args: {
        /**
         * The text in the input.
         *
         * The state is managed internally, so this does not need to be a
         * maintained value, but whenever it changes, the input reflects it. Pair
         * it with `@onQueryChange` to keep the query somewhere else, such as a
         * query param.
         */
        query?: string;
        /**
         * Called with the input's text every time it changes.
         */
        onQueryChange?: (query: string) => void;
        /**
         * A key combination that calls `@onOpen` from anywhere on the page, such
         * as `"mod+k"`. `mod` is <kbd>Meta</kbd> on macOS and <kbd>Control</kbd>
         * everywhere else.
         *
         * Needs `@onOpen` to have anything to do. No listener is installed
         * without both.
         */
        hotkey?: string;
        /**
         * Called when `@hotkey` is pressed. Hand it the `open` of whatever the
         * palette is in:
         *
         * ```hbs
         * <CommandPalette @hotkey="mod+k" @onOpen={{d.open}} />
         * ```
         */
        onOpen?: () => void;
        /**
         * The entries to render. Each is a string, or an object with a `label`
         * and optionally a `description` and an `icon`.
         */
        items: PaletteItem[];
        /**
         * Called every time a row is chosen, with the entry that was chosen.
         * This is where a modal palette closes itself:
         *
         * ```hbs
         * <Dialog as |d|>
         *   <CommandPalette @items={{this.commands}} @onSelect={{d.close}} />
         * </Dialog>
         * ```
         *
         * Also where a row's own action goes, since the entry it is handed says
         * which row was chosen.
         */
        onSelect?: (item: PaletteItem, event: Event) => void;
        /**
         * The input's placeholder, and its accessible name.
         *
         * Defaults to "Search".
         */
        placeholder?: string;
        /**
         * What a screen reader announces when the number of results changes.
         *
         * Defaults to "1 result" and "3 results".
         */
        resultsText?: (count: number) => string;
    };
    /**
     * No blocks: this form renders the rows. Passing one is an error.
     */
    Blocks: Record<string, never>;
}
/**
 * The composed form: you render the rows.
 */
export interface BlockSignature {
    Args: {
        /**
         * The text in the input.
         *
         * The state is managed internally, so this does not need to be a
         * maintained value, but whenever it changes, the input reflects it. Pair
         * it with `@onQueryChange` to keep the query somewhere else, such as a
         * query param.
         */
        query?: string;
        /**
         * Called with the input's text every time it changes.
         */
        onQueryChange?: (query: string) => void;
        /**
         * A key combination that calls `@onOpen` from anywhere on the page, such
         * as `"mod+k"`. `mod` is <kbd>Meta</kbd> on macOS and <kbd>Control</kbd>
         * everywhere else.
         *
         * Needs `@onOpen` to have anything to do. No listener is installed
         * without both.
         */
        hotkey?: string;
        /**
         * Called when `@hotkey` is pressed. Hand it the `open` of whatever the
         * palette is in:
         *
         * ```hbs
         * <CommandPalette @hotkey="mod+k" @onOpen={{d.open}} />
         * ```
         */
        onOpen?: () => void;
        /**
         * Not for this form: the rows come from the block.
         */
        items?: never;
        /**
         * Not for this form: set it on `Input` yourself.
         */
        placeholder?: never;
        /**
         * Not for this form: the rows are yours, and so is announcing them.
         */
        resultsText?: never;
        /**
         * Called every time a row is chosen. Hand it `close` to make a modal
         * palette close itself.
         *
         * The rows are yours here, so there is no entry to hand back. Which row
         * was chosen is `event.target.closest("[role=option]")`.
         */
        onSelect?: (event: Event) => void;
    };
    Blocks: {
        default: [
            {
                /**
                 * The current text of the input.
                 */
                query: string;
                /**
                 * Sets the text of the input, for a "clear" button or a suggestion.
                 */
                setQuery: (query: string) => void;
                /**
                 * The `<input>`, wired as a combobox over `List`.
                 *
                 * It needs a name: pass `aria-label`, or an `id` and a `<label>`.
                 */
                Input: WithBoundArgs<typeof Input, "listId" | "activeId" | "query" | "onInput" | "onKeydown">;
                /**
                 * The listbox the rows are rendered into.
                 */
                List: WithBoundArgs<typeof List, "id" | "register" | "onPointerMove" | "onClick" | "item" | "linkItem">;
            }
        ];
    };
}
export type Signature = ItemsSignature | BlockSignature;
export declare class CommandPalette extends Component<Signature> {
    #private;
    listId: string;
    /**
     * Which row is active, as an id rather than an element or a focus state.
     *
     * This is unusual for this library, where keyboard navigation means tabster
     * moving focus. A combobox cannot do that: focus has to stay in the
     * `<input>` or the reader stops being able to type. So nothing among the
     * rows is ever focused, there is no focus for tabster to track, and what
     * moves instead is `aria-activedescendant` -- which is an id, on the input,
     * pointing at a row. Holding the id is holding exactly what that attribute
     * needs.
     *
     * Tabster still does the finding, in `#find`. This only remembers which of
     * the rows it landed on.
     */
    activeId: string | undefined;
    _query: string;
    constructor(owner: Owner, args: Signature["Args"]);
    get placeholder(): string;
    get resultsText(): string;
    /**
     * Whether `@items` was passed, not whether it has anything in it: an empty
     * array is falsy in a template, and a palette whose results have gone away
     * still has to render the input they would be typed into.
     */
    get hasItems(): boolean;
    /**
     * `@items` and a block are two ways to say the same thing, and saying both
     * means one of them is being quietly ignored.
     */
    get bothGiven(): string;
    get query(): string;
    set query(value: string);
    registerList: import("ember-modifier").FunctionBasedModifier<{
        Args: {
            Positional: unknown[];
            Named: import("ember-modifier/-private/signature").EmptyObject;
        };
        Element: HTMLElement;
    }>;
    setQuery: (query: string) => void;
    handleInput: (event: Event) => void;
    handlePointerMove: (event: PointerEvent) => void;
    handleKeydown: (event: KeyboardEvent) => void;
    handleHotkey: (event: KeyboardEvent) => void;
    /**
     * Choosing is delegated, so a row is markup rather than a listener, and
     * `@onSelect` is reached the same way however the rows were rendered.
     */
    handleClick: (event: MouseEvent) => void;
}
export default CommandPalette;
//# sourceMappingURL=command-palette.d.ts.map