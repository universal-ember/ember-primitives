/**
 * Command Palette Component
 * 
 * A modal dialog-based command palette with search input and keyboard-navigable list.
 * 
 * References:
 * - https://www.w3.org/WAI/ARIA/apg/patterns/dialog-modal/
 * - https://www.w3.org/WAI/ARIA/apg/patterns/combobox/
 * 
 * Keyboard behaviors provided by tabster:
 * - Arrow keys navigate between items
 * - Escape closes the palette
 * - Focus is trapped within the dialog
 */

import Component from "@glimmer/component";
import { tracked } from "@glimmer/tracking";
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";
import { guidFor } from "@ember/object/internals";

import { modifier as eModifier } from "ember-modifier";
import { cell } from "ember-resources";
import { getTabster, getTabsterAttribute, MoverDirections, setTabsterAttribute } from "tabster";

import { Dialog } from "./dialog.gts";

import type { Signature as DialogSignature } from "./dialog.gts";
import type { TOC } from "@ember/component/template-only";
import type { ModifierLike, WithBoundArgs } from "@glint/template";

type Cell<V> = ReturnType<typeof cell<V>>;

const TABSTER_CONFIG_LIST = getTabsterAttribute(
  {
    mover: {
      direction: MoverDirections.Vertical,
      cyclic: true,
    },
  },
  true,
);

export interface Signature {
  Args: {
    /**
     * Optionally set the open state of the command palette
     * The state will still be managed internally,
     * so this does not need to be a maintained value, but whenever it changes,
     * the dialog element will reflect that change accordingly.
     */
    open?: boolean;
    /**
     * When the command palette is closed, this function will be called
     */
    onClose?: () => void;
  };
  Blocks: {
    default: [
      {
        /**
         * Represents the open state of the command palette
         */
        isOpen: boolean;

        /**
         * Closes the command palette
         */
        close: () => void;

        /**
         * Opens the command palette
         */
        open: () => void;

        /**
         * This modifier should be applied to the button that opens the command palette
         * so that it can be re-focused when the palette closes.
         */
        focusOnClose: ModifierLike<{ Element: HTMLElement }>;

        /**
         * The dialog element wrapper for the command palette
         */
        Dialog: WithBoundArgs<typeof CommandPaletteDialog, "state" | "dialogProps">;

        /**
         * The input element for search/filtering
         */
        Input: WithBoundArgs<typeof CommandPaletteInput, "state">;

        /**
         * The list container for command items
         */
        List: WithBoundArgs<typeof CommandPaletteList, "state">;

        /**
         * Individual command items
         */
        Item: WithBoundArgs<typeof CommandPaletteItem, "state">;
      },
    ];
  };
}

type CommandPaletteState = ReturnType<typeof createCommandPaletteState>;

interface PrivateItemSignature {
  Element: HTMLDivElement;
  Args: {
    state: CommandPaletteState;
    onSelect?: (event: Event) => void;
  };
  Blocks: { default: [] };
}

export interface ItemSignature {
  Element: PrivateItemSignature["Element"];
  Args: Omit<PrivateItemSignature["Args"], "state">;
  Blocks: PrivateItemSignature["Blocks"];
}

/**
 * We focus items on `pointerMove` to achieve the following:
 *
 * - Mouse over an item (it focuses)
 * - Leave mouse where it is and use keyboard to focus a different item
 * - Wiggle mouse without it leaving previously focused item
 * - Previously focused item should re-focus
 *
 * If we used `mouseOver`/`mouseEnter` it would not re-focus when the mouse
 * wiggles. This is to match native menu implementation.
 */
function focusOnHover(e: PointerEvent) {
  const item = e.currentTarget;

  if (item instanceof HTMLElement) {
    item?.focus();
  }
}

const CommandPaletteItem: TOC<PrivateItemSignature> = <template>
  {{! @glint-expect-error }}
  {{#let (if @onSelect (modifier on "click" @onSelect)) as |maybeClick|}}
    <div
      role="option"
      tabindex="-1"
      {{! @glint-expect-error }}
      {{maybeClick}}
      {{on "click" @state.close}}
      {{on "pointermove" focusOnHover}}
      ...attributes
    >
      {{yield}}
    </div>
  {{/let}}
</template>;

interface PrivateListSignature {
  Element: HTMLDivElement;
  Args: {
    state: CommandPaletteState;
    listId: string;
    inputId: string;
  };
  Blocks: { default: [] };
}

export interface ListSignature {
  Element: PrivateListSignature["Element"];
  Blocks: PrivateListSignature["Blocks"];
}

const CommandPaletteList: TOC<PrivateListSignature> = <template>
  <div
    role="listbox"
    id={{@listId}}
    data-tabster={{TABSTER_CONFIG_LIST}}
    aria-labelledby={{@inputId}}
    tabindex="0"
    ...attributes
  >
    {{yield}}
  </div>
</template>;

interface PrivateInputSignature {
  Element: HTMLInputElement;
  Args: {
    state: CommandPaletteState;
    inputId: string;
    listId: string;
  };
  Blocks: {};
}

export interface InputSignature {
  Element: PrivateInputSignature["Element"];
}

const focusInput = eModifier<{
  Element: HTMLInputElement;
}>((element) => {
  // Focus the input when it's rendered
  void (async () => {
    await Promise.resolve();
    element.focus();
  })();
});

const CommandPaletteInput: TOC<PrivateInputSignature> = <template>
  <input
    type="text"
    role="combobox"
    id={{@inputId}}
    aria-controls={{@listId}}
    aria-expanded="true"
    aria-autocomplete="list"
    autocomplete="off"
    {{focusInput}}
    ...attributes
  />
</template>;

interface PrivateDialogSignature {
  Element: HTMLDivElement;
  Args: {
    state: CommandPaletteState;
    dialogProps: DialogSignature["Blocks"]["default"][0];
  };
  Blocks: { default: [] };
}

export interface CommandPaletteDialogSignature {
  Element: PrivateDialogSignature["Element"];
  Blocks: PrivateDialogSignature["Blocks"];
}

const installDialog = eModifier<{
  Element: HTMLElement;
  Args: {
    Named: {
      state: CommandPaletteState;
    };
  };
}>((element, _: [], { state }) => {
  // Set tabster attributes for the dialog content
  setTabsterAttribute(element, {
    deloser: {},
  });

  // Listen for the escape key
  function onDocumentKeydown(e: KeyboardEvent) {
    if (e.key === "Escape") {
      state.close();
    }
  }

  document.addEventListener("keydown", onDocumentKeydown);

  return () => {
    document.removeEventListener("keydown", onDocumentKeydown);
  };
});

const CommandPaletteDialog: TOC<PrivateDialogSignature> = <template>
  <@dialogProps.Dialog ...attributes>
    <div {{installDialog state=@state}}>
      {{yield}}
    </div>
  </@dialogProps.Dialog>
</template>;

function createCommandPaletteState(
  dialog: DialogSignature["Blocks"]["default"][0],
  owner: object,
) {
  const guid = guidFor(owner);
  const inputId = `command-palette-input-${guid}`;
  const listId = `command-palette-list-${guid}`;

  return {
    inputId,
    listId,
    get isOpen() {
      return dialog.isOpen;
    },
    close: dialog.close,
    open: dialog.open,
    focusOnClose: dialog.focusOnClose,
  };
}

export class CommandPalette extends Component<Signature> {
  <template>
    <Dialog @open={{@open}} @onClose={{@onClose}} as |dialog|>
      {{#let (createCommandPaletteState dialog this) as |state|}}
        {{yield
          (hash
            isOpen=state.isOpen
            open=state.open
            close=state.close
            focusOnClose=state.focusOnClose
            Dialog=(component CommandPaletteDialog state=state dialogProps=dialog)
            Input=(component CommandPaletteInput state=state inputId=state.inputId listId=state.listId)
            List=(component
              CommandPaletteList state=state listId=state.listId inputId=state.inputId
            )
            Item=(component CommandPaletteItem state=state)
          )
        }}
      {{/let}}
    </Dialog>
  </template>
}

export default CommandPalette;
