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
import { tracked } from "@glimmer/tracking";
import { assert } from "@ember/debug";
import { registerDestructor } from "@ember/destroyable";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";
import { guidFor } from "@ember/object/internals";

import { modifier as eModifier } from "ember-modifier";
import { getTabster } from "tabster";
// temp
//  https://github.com/tracked-tools/tracked-toolbox/issues/38
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-expect-error
import { localCopy } from "tracked-toolbox";

import { Link, type Signature as LinkSignature } from "./link.gts";

import type { TOC } from "@ember/component/template-only";
import type Owner from "@ember/owner";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

const OPTION = '[role="option"]';

function isMac() {
  return navigator.userAgent.includes("Mac OS");
}

/**
 * Matches a hotkey description, such as `"mod+k"`, against a keyboard event.
 *
 * `mod` is <kbd>Meta</kbd> on macOS and <kbd>Control</kbd> everywhere else,
 * the same normalization `<KeyCombo>` uses to render one.
 */
function matches(event: KeyboardEvent, hotkey: string) {
  const parts = hotkey
    .toLowerCase()
    .split("+")
    .map((part) => part.trim());
  const key = parts.pop();
  const modifiers = new Set(parts);
  const mod = modifiers.has("mod");

  return (
    event.key.toLowerCase() === key &&
    event.metaKey === (modifiers.has("meta") || (mod && isMac())) &&
    event.ctrlKey === (modifiers.has("ctrl") || (mod && !isMac())) &&
    event.altKey === modifiers.has("alt") &&
    event.shiftKey === modifiers.has("shift")
  );
}

export interface ItemSignature {
  Element: HTMLDivElement;
  Blocks: { default: [] };
}

interface PrivateItemSignature {
  Element: ItemSignature["Element"];
  Args: { activeId: string | undefined };
  Blocks: ItemSignature["Blocks"];
}

class Item extends Component<PrivateItemSignature> {
  id = guidFor(this);

  get isActive() {
    return this.args.activeId === this.id;
  }

  <template>
    <div
      id={{this.id}}
      role="option"
      tabindex="-1"
      aria-selected="{{this.isActive}}"
      data-active="{{this.isActive}}"
      ...attributes
    >
      {{yield}}
    </div>
  </template>
}

export interface LinkItemSignature {
  Element: HTMLAnchorElement;
  Args: LinkSignature["Args"];
  Blocks: { default: [] };
}

interface PrivateLinkItemSignature {
  Element: LinkItemSignature["Element"];
  Args: LinkItemSignature["Args"] & { activeId: string | undefined };
  Blocks: LinkItemSignature["Blocks"];
}

/**
 * An option that is also a link. <kbd>Enter</kbd> dispatches a real click on
 * the anchor, so the router navigates exactly as it would have for a mouse.
 */
class LinkItem extends Component<PrivateLinkItemSignature> {
  id = guidFor(this);

  get isActive() {
    return this.args.activeId === this.id;
  }

  <template>
    <Link
      id={{this.id}}
      role="option"
      tabindex="-1"
      aria-selected="{{this.isActive}}"
      data-active="{{this.isActive}}"
      @href={{@href}}
      @includeActiveQueryParams={{@includeActiveQueryParams}}
      @activeOnSubPaths={{@activeOnSubPaths}}
      ...attributes
    >
      {{yield}}
    </Link>
  </template>
}

export interface ListSignature {
  Element: HTMLDivElement;
  Blocks: {
    default: [
      {
        Item: WithBoundArgs<typeof Item, "activeId">;
        LinkItem: WithBoundArgs<typeof LinkItem, "activeId">;
      },
    ];
  };
}

interface PrivateListSignature {
  Element: ListSignature["Element"];
  Args: {
    id: string;
    register: ModifierLike<{ Element: HTMLElement }>;
    onPointerMove: (event: PointerEvent) => void;
    onClick: (event: MouseEvent) => void;
    Item: ListSignature["Blocks"]["default"][0]["Item"];
    LinkItem: ListSignature["Blocks"]["default"][0]["LinkItem"];
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
const List: TOC<PrivateListSignature> = <template>
  <div
    id={{@id}}
    role="listbox"
    {{@register}}
    {{on "click" @onClick}}
    {{on "pointermove" @onPointerMove}}
    ...attributes
  >
    {{yield (hash Item=@Item LinkItem=@LinkItem)}}
  </div>
</template>;

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

const Input: TOC<PrivateInputSignature> = <template>
  <input
    type="text"
    role="combobox"
    autocomplete="off"
    autocorrect="off"
    autocapitalize="off"
    spellcheck="false"
    aria-autocomplete="list"
    aria-expanded="true"
    aria-controls={{@listId}}
    aria-activedescendant={{@activeId}}
    value={{@query}}
    {{on "input" @onInput}}
    {{on "keydown" @onKeydown}}
    ...attributes
  />
</template>;

/**
 * One entry in the default layout. A bare string is the label.
 */
export type PaletteItem =
  | string
  | {
      label: string;
      description?: string;
      icon?: string;
    };

const labelOf = (item: PaletteItem) => (typeof item === "string" ? item : item.label);
const descriptionOf = (item: PaletteItem) =>
  typeof item === "string" ? undefined : item.description;
const iconOf = (item: PaletteItem) => (typeof item === "string" ? undefined : item.icon);

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
         */
        Input: WithBoundArgs<
          typeof Input,
          "listId" | "activeId" | "query" | "onInput" | "onKeydown"
        >;
        /**
         * The listbox the rows are rendered into.
         */
        List: WithBoundArgs<
          typeof List,
          "id" | "register" | "onPointerMove" | "onClick" | "Item" | "LinkItem"
        >;
      },
    ];
  };
}

export type Signature = ItemsSignature | BlockSignature;

export class CommandPalette extends Component<Signature> {
  listId = guidFor(this);

  /**
   * Held rather than looked up by id, because `document.getElementById` does
   * not cross into a shadow root. A plain field: it is read when a key is
   * pressed, never while rendering.
   */
  #list: HTMLElement | undefined;

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
  @tracked activeId: string | undefined;

  // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  @localCopy("args.query") declare _query: string;

  constructor(owner: Owner, args: Signature["Args"]) {
    super(owner, args);

    document.addEventListener("keydown", this.handleHotkey);

    registerDestructor(this, () => {
      document.removeEventListener("keydown", this.handleHotkey);
    });
  }

  get placeholder() {
    return this.args.placeholder ?? "Search";
  }

  /**
   * Whether `@items` was passed, not whether it has anything in it: an empty
   * array is falsy in a template, and a palette whose results have gone away
   * still has to render the input they would be typed into.
   */
  get hasItems() {
    return this.args.items !== undefined;
  }

  /**
   * Each form is called the way its own type describes: with the entry that
   * was chosen, or with the event alone when the rows are the caller's.
   *
   * `@items` is what tells the two apart, and it is `never` on the form that
   * does not take it, so testing it narrows `this.args` to one of them.
   */
  #select(option: HTMLElement, event: Event) {
    if (this.args.items === undefined) {
      this.args.onSelect?.(event);

      return;
    }

    const entry = this.#entryFor(option, this.args.items);

    assert(
      "[BUG] a row of the default layout was chosen, but is not among `@items`",
      entry !== undefined,
    );

    this.args.onSelect?.(entry, event);
  }

  /**
   * `@items` and a block are two ways to say the same thing, and saying both
   * means one of them is being quietly ignored.
   */
  get bothGiven() {
    assert(
      "<CommandPalette> was given both `@items` and a block. Use one: `@items` renders the rows for you, a block renders them yourself.",
      false,
    );

    return "";
  }

  get query() {
    return this._query ?? "";
  }
  set query(value: string) {
    this._query = value;
  }

  registerList = eModifier((element: HTMLElement) => {
    this.#list = element;
  });

  get #activeElement() {
    const { activeId } = this;

    if (!activeId) return undefined;

    // scoped to the listbox, so this works inside a shadow root
    return this.#list?.querySelector<HTMLElement>(`[id="${activeId}"]`) ?? undefined;
  }

  /**
   * The next, previous, first or last option.
   *
   * Tabster does the finding, so hidden and inert options are skipped by the
   * same rules as everything else that moves around the page. It has to be
   * set up by the app, the same way `<Menu>` requires it.
   */
  #find(direction: "next" | "prev" | "first" | "last") {
    const container = this.#list;

    if (!container) return undefined;

    const tabster = getTabster(window);

    assert(
      "<CommandPalette> needs tabster, which the application sets up. " +
        "Call `setupTabster` from 'ember-primitives/tabster' in your application route. " +
        "See https://tabster.io/docs/core",
      tabster,
    );

    const options = { container, includeProgrammaticallyFocusable: true };
    const currentElement = this.#activeElement;
    const { focusable } = tabster;

    if (direction === "first") return focusable.findFirst(options);
    if (direction === "last") return focusable.findLast(options);

    if (!currentElement) {
      return direction === "next" ? focusable.findFirst(options) : focusable.findLast(options);
    }

    const found =
      direction === "next"
        ? focusable.findNext({ ...options, currentElement })
        : focusable.findPrev({ ...options, currentElement });

    // wrap, rather than stop, at either end
    return (
      found ?? (direction === "next" ? focusable.findFirst(options) : focusable.findLast(options))
    );
  }

  #activate(element: HTMLElement | null | undefined) {
    if (!element) return;

    this.activeId = element.id;
    element.scrollIntoView({ block: "nearest" });
  }

  setQuery = (query: string) => {
    this.query = query;
    // the results are about to be somebody else's; whatever was active is not
    this.activeId = undefined;
    this.args.onQueryChange?.(query);
  };

  handleInput = (event: Event) => {
    const { target } = event;

    assert("[BUG] input event without an input", target instanceof HTMLInputElement);

    this.setQuery(target.value);
  };

  handlePointerMove = (event: PointerEvent) => {
    const { target } = event;

    if (!(target instanceof Element)) return;

    const option = target.closest<HTMLElement>(OPTION);

    if (option) {
      this.activeId = option.id;
    }
  };

  handleKeydown = (event: KeyboardEvent) => {
    // mid-composition (IME), the arrow keys belong to the candidate window
    if (event.isComposing) return;

    switch (event.key) {
      case "ArrowDown": {
        event.preventDefault();
        this.#activate(this.#find("next"));

        return;
      }
      case "ArrowUp": {
        event.preventDefault();
        this.#activate(this.#find("prev"));

        return;
      }
      case "Enter": {
        // nothing arrowed yet chooses the first result, so a reader can type
        // and press Enter without leaving the keys they were already on
        const active = this.#activeElement ?? this.#find("first");

        if (!active) return;

        event.preventDefault();
        // a real click, so one handler covers the mouse and the keyboard, and
        // an anchor navigates the way the browser would have
        active.click();

        return;
      }
      /**
       * Home and End are left to the browser: in an editable combobox they
       * move the caret, which is what the APG asks for.
       */
    }
  };

  handleHotkey = (event: KeyboardEvent) => {
    const { hotkey, onOpen } = this.args;

    if (!hotkey || !onOpen) return;
    if (!matches(event, hotkey)) return;

    event.preventDefault();
    onOpen();
  };

  /**
   * The entry a row came from, for the default layout. Rows are rendered one
   * per entry and in order, so a row's position among the options is its
   * entry's position in `@items`. A block form has no entries, and gets
   * `undefined`.
   */
  #entryFor(option: HTMLElement, items: PaletteItem[]) {
    const options = this.#list?.querySelectorAll<HTMLElement>(OPTION);

    for (let i = 0; i < (options?.length ?? 0); i++) {
      if (options?.[i] === option) return items[i];
    }

    return undefined;
  }

  /**
   * Choosing is delegated, so a row is markup rather than a listener, and
   * `@onSelect` is reached the same way however the rows were rendered.
   */
  handleClick = (event: MouseEvent) => {
    const { target } = event;

    if (!(target instanceof Element)) return;

    const option = target.closest<HTMLElement>(OPTION);

    if (!option) return;

    /**
     * A modified click on a link opens it somewhere else and leaves the
     * reader where they are, so the palette stays where they left it.
     */
    if (option.closest("a")) {
      if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return;
      if (event.button !== 0) return;
    }

    this.#select(option, event);
  };

  <template>
    {{#let
      (component
        Input
        listId=this.listId
        activeId=this.activeId
        query=this.query
        onInput=this.handleInput
        onKeydown=this.handleKeydown
      )
      (component
        List
        id=this.listId
        register=this.registerList
        onPointerMove=this.handlePointerMove
        onClick=this.handleClick
        Item=(component Item activeId=this.activeId)
        LinkItem=(component LinkItem activeId=this.activeId)
      )
      as |PaletteInput PaletteList|
    }}
      {{#if this.hasItems}}
        {{#if (has-block)}}{{this.bothGiven}}{{/if}}

        <PaletteInput
          class="ember-primitives__command-palette__input"
          placeholder={{this.placeholder}}
          aria-label={{this.placeholder}}
        />

        <PaletteList class="ember-primitives__command-palette__list" as |l|>
          {{#each @items as |item|}}
            <l.Item class="ember-primitives__command-palette__item">
              {{#if (iconOf item)}}
                <span class="ember-primitives__command-palette__icon">{{iconOf item}}</span>
              {{/if}}
              <span class="ember-primitives__command-palette__label">{{labelOf item}}</span>
              {{#if (descriptionOf item)}}
                <span class="ember-primitives__command-palette__description">{{descriptionOf
                    item
                  }}</span>
              {{/if}}
            </l.Item>
          {{/each}}
        </PaletteList>
      {{else}}
        {{yield (hash query=this.query setQuery=this.setQuery Input=PaletteInput List=PaletteList)}}
      {{/if}}
    {{/let}}
  </template>
}

export default CommandPalette;
