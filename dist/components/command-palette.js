import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { assert } from '@ember/debug';
import { registerDestructor } from '@ember/destroyable';
import { hash } from '@ember/helper';
import { on } from '@ember/modifier';
import { guidFor } from '@ember/object/internals';
import { modifier } from 'ember-modifier';
import { getTabster } from 'tabster';
import { localCopy } from 'tracked-toolbox';
import { Link } from './link.js';
import { VisuallyHidden } from './visually-hidden.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';
import { g, i } from 'decorator-transforms/runtime';

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
function matches(event, hotkey) {
  const parts = hotkey.toLowerCase().split("+").map(part => part.trim());
  const key = parts.pop();
  const modifiers = new Set(parts);
  const mod = modifiers.has("mod");
  return event.key.toLowerCase() === key && event.metaKey === (modifiers.has("meta") || mod && isMac()) && event.ctrlKey === (modifiers.has("ctrl") || mod && !isMac()) && event.altKey === modifiers.has("alt") && event.shiftKey === modifiers.has("shift");
}
class Item extends Component {
  id = guidFor(this);
  get isActive() {
    return this.args.activeId === this.id;
  }
  static {
    setComponentTemplate(precompileTemplate("<div id={{this.id}} role=\"option\" tabindex=\"-1\" aria-selected=\"{{this.isActive}}\" data-active=\"{{this.isActive}}\" ...attributes>\n  {{yield}}\n</div>", {
      strictMode: true
    }), this);
  }
}
/**
 * An option that is also a link. <kbd>Enter</kbd> dispatches a real click on
 * the anchor, so the router navigates exactly as it would have for a mouse.
 */
class LinkItem extends Component {
  id = guidFor(this);
  get isActive() {
    return this.args.activeId === this.id;
  }
  static {
    setComponentTemplate(precompileTemplate("<Link id={{this.id}} role=\"option\" tabindex=\"-1\" aria-selected=\"{{this.isActive}}\" data-active=\"{{this.isActive}}\" @href={{@href}} @includeActiveQueryParams={{@includeActiveQueryParams}} @activeOnSubPaths={{@activeOnSubPaths}} ...attributes>\n  {{yield}}\n</Link>", {
      strictMode: true,
      scope: () => ({
        Link
      })
    }), this);
  }
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
const List = setComponentTemplate(precompileTemplate("<div id={{@id}} role=\"listbox\" {{@register}} {{on \"click\" @onClick}} {{on \"pointermove\" @onPointerMove}} ...attributes>\n  {{yield (hash Item=@item LinkItem=@linkItem)}}\n</div>", {
  strictMode: true,
  scope: () => ({
    on,
    hash
  })
}), templateOnly());
const Input = setComponentTemplate(precompileTemplate("<input type=\"text\" role=\"combobox\" autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\" aria-autocomplete=\"list\" aria-expanded=\"true\" aria-controls={{@listId}} aria-activedescendant={{@activeId}} value={{@query}} {{on \"input\" @onInput}} {{on \"keydown\" @onKeydown}} ...attributes />", {
  strictMode: true,
  scope: () => ({
    on
  })
}), templateOnly());
/**
 * One entry in the default layout. A bare string is the label.
 */

const labelOf = item => typeof item === "string" ? item : item.label;
const descriptionOf = item => typeof item === "string" ? undefined : item.description;
const iconOf = item => typeof item === "string" ? undefined : item.icon;
/**
 * The default layout: hand it the rows and it renders the whole palette.
 */

/**
 * The composed form: you render the rows.
 */

class CommandPalette extends Component {
  listId = guidFor(this);
  /**
  * Held rather than looked up by id, because `document.getElementById` does
  * not cross into a shadow root. A plain field: it is read when a key is
  * pressed, never while rendering.
  */
  #list;
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
  static {
    g(this.prototype, "activeId", [tracked]);
  }
  #activeId = (i(this, "activeId"), void 0);
  static {
    g(this.prototype, "_query", [localCopy("args.query")]);
  }
  #_query = (i(this, "_query"), void 0); // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  constructor(owner, args) {
    super(owner, args);
    document.addEventListener("keydown", this.handleHotkey);
    registerDestructor(this, () => {
      document.removeEventListener("keydown", this.handleHotkey);
    });
  }
  get placeholder() {
    return this.args.placeholder ?? "Search";
  }
  get resultsText() {
    const count = this.args.items?.length ?? 0;
    const custom = this.args.resultsText?.(count);
    return custom ?? (count === 1 ? "1 result" : `${count} results`);
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
  #select(option, event) {
    if (this.args.items === undefined) {
      this.args.onSelect?.(event);
      return;
    }
    const entry = this.#entryFor(option, this.args.items);
    assert("[BUG] a row of the default layout was chosen, but is not among `@items`", entry !== undefined);
    this.args.onSelect?.(entry, event);
  }
  /**
  * `@items` and a block are two ways to say the same thing, and saying both
  * means one of them is being quietly ignored.
  */
  get bothGiven() {
    assert("<CommandPalette> was given both `@items` and a block. Use one: `@items` renders the rows for you, a block renders them yourself.", false);
    return "";
  }
  get query() {
    return this._query ?? "";
  }
  set query(value) {
    this._query = value;
  }
  registerList = modifier(element => {
    this.#list = element;
  });
  get #activeElement() {
    const {
      activeId
    } = this;
    if (!activeId) return undefined;
    // scoped to the listbox, so this works inside a shadow root
    return this.#list?.querySelector(`[id="${activeId}"]`) ?? undefined;
  }
  /**
  * The next, previous, first or last option.
  *
  * Tabster does the finding, so hidden and inert options are skipped by the
  * same rules as everything else that moves around the page. It has to be
  * set up by the app, the same way `<Menu>` requires it.
  */
  #find(direction) {
    const container = this.#list;
    if (!container) return undefined;
    const tabster = getTabster(window);
    assert("<CommandPalette> needs tabster, which the application sets up. " + "Call `setupTabster` from 'ember-primitives/tabster' in your application route. " + "See https://tabster.io/docs/core", tabster);
    const options = {
      container,
      includeProgrammaticallyFocusable: true
    };
    const currentElement = this.#activeElement;
    const {
      focusable
    } = tabster;
    if (direction === "first") return focusable.findFirst(options);
    if (direction === "last") return focusable.findLast(options);
    if (!currentElement) {
      return direction === "next" ? focusable.findFirst(options) : focusable.findLast(options);
    }
    const found = direction === "next" ? focusable.findNext({
      ...options,
      currentElement
    }) : focusable.findPrev({
      ...options,
      currentElement
    });
    // wrap, rather than stop, at either end
    return found ?? (direction === "next" ? focusable.findFirst(options) : focusable.findLast(options));
  }
  #activate(element) {
    if (!element) return;
    this.activeId = element.id;
    element.scrollIntoView({
      block: "nearest"
    });
  }
  setQuery = query => {
    this.query = query;
    // the results are about to be somebody else's; whatever was active is not
    this.activeId = undefined;
    this.args.onQueryChange?.(query);
  };
  handleInput = event => {
    const {
      target
    } = event;
    assert("[BUG] input event without an input", target instanceof HTMLInputElement);
    this.setQuery(target.value);
  };
  handlePointerMove = event => {
    const {
      target
    } = event;
    if (!(target instanceof Element)) return;
    const option = target.closest(OPTION);
    if (option) {
      this.activeId = option.id;
    }
  };
  handleKeydown = event => {
    // mid-composition (IME), the arrow keys belong to the candidate window
    if (event.isComposing) return;
    switch (event.key) {
      case "ArrowDown":
        {
          event.preventDefault();
          this.#activate(this.#find("next"));
          return;
        }
      case "ArrowUp":
        {
          event.preventDefault();
          this.#activate(this.#find("prev"));
          return;
        }
      case "Enter":
        {
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
    }
  };
  handleHotkey = event => {
    const {
      hotkey,
      onOpen
    } = this.args;
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
  #entryFor(option, items) {
    const options = this.#list?.querySelectorAll(OPTION);
    for (let i = 0; i < (options?.length ?? 0); i++) {
      if (options?.[i] === option) return items[i];
    }
    return undefined;
  }
  /**
  * Choosing is delegated, so a row is markup rather than a listener, and
  * `@onSelect` is reached the same way however the rows were rendered.
  */
  handleClick = event => {
    const {
      target
    } = event;
    if (!(target instanceof Element)) return;
    const option = target.closest(OPTION);
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
  static {
    setComponentTemplate(precompileTemplate("{{#let (component Input listId=this.listId activeId=this.activeId query=this.query onInput=this.handleInput onKeydown=this.handleKeydown) (component List id=this.listId register=this.registerList onPointerMove=this.handlePointerMove onClick=this.handleClick item=(component Item activeId=this.activeId) linkItem=(component LinkItem activeId=this.activeId)) as |PaletteInput PaletteList|}}\n  {{#if this.hasItems}}\n    {{#if (has-block)}}{{this.bothGiven}}{{/if}}\n\n    <PaletteInput class=\"ember-primitives__command-palette__input\" placeholder={{this.placeholder}} aria-label={{this.placeholder}} />\n\n    <PaletteList class=\"ember-primitives__command-palette__list\" as |l|>\n      {{#each @items as |item|}}\n        <l.Item class=\"ember-primitives__command-palette__item\">\n          {{#if (iconOf item)}}\n            <span class=\"ember-primitives__command-palette__icon\">{{iconOf item}}</span>\n          {{/if}}\n          <span class=\"ember-primitives__command-palette__label\">{{labelOf item}}</span>\n          {{#if (descriptionOf item)}}\n            <span class=\"ember-primitives__command-palette__description\">{{descriptionOf item}}</span>\n          {{/if}}\n        </l.Item>\n      {{/each}}\n    </PaletteList>\n\n    <VisuallyHidden role=\"status\">{{this.resultsText}}</VisuallyHidden>\n  {{else}}\n    {{yield (hash query=this.query setQuery=this.setQuery Input=PaletteInput List=PaletteList)}}\n  {{/if}}\n{{/let}}", {
      strictMode: true,
      scope: () => ({
        Input,
        List,
        Item,
        LinkItem,
        iconOf,
        labelOf,
        descriptionOf,
        VisuallyHidden,
        hash
      })
    }), this);
  }
}

export { CommandPalette, CommandPalette as default };
//# sourceMappingURL=command-palette.js.map
