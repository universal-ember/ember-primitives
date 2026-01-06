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
import { hash } from "@ember/helper";
import { on } from "@ember/modifier";
import { guidFor } from "@ember/object/internals";

// @ts-expect-error, really, no types?
import { focusTrap } from "ember-focus-trap";
import { modifier as eModifier } from "ember-modifier";
import { getTabsterAttribute, MoverDirections } from "tabster";

import { Dialog } from "./dialog.gts";

import type { Signature as DialogSignature } from "./dialog.gts";
import type { TOC } from "@ember/component/template-only";
import type { ModifierLike, WithBoundArgs } from "@glint/template";
import Menu from "./menu.gts";

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
        Input: WithBoundArgs<typeof CommandPaletteInput, "state" | "inputId" | "listId">;

        /**
         * The list container for command items
         */
        List: WithBoundArgs<typeof CommandPaletteList, "state" | "listId" | "inputId">;

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
    item.focus();
  }
}

const CommandPaletteItem: TOC<PrivateItemSignature> = <template>
  {{! @glint-expect-error }}
  {{#let (if @onSelect (modifier on "click" @onSelect)) as |maybeClick|}}
    <div
      role="option"
      tabindex="-1"
      aria-selected="false"
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
  Blocks: Record<string, never>;
}

export interface InputSignature {
  Element: PrivateInputSignature["Element"];
}

const focusInput = eModifier<{ Element: HTMLInputElement }>((element) => {
  requestAnimationFrame(() => {
    element.focus();
  });
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

const CommandPaletteDialog: TOC<{
  Element: HTMLDivElement;
  Args: {
    dialog: DialogSignature["Blocks"]["default"][0];
  };
  Blocks: { default: [] };
}> = <template>
  <@dialog.Dialog
    ...attributes
    {{focusTrap isActive=@dialog.isOpen focusTrapOptions=focusTrapOptions}}
  >
    {{yield}}
  </@dialog.Dialog>
</template>;

const focusTrapOptions = {
  clickOutsideDeactivates: true,
  allowOutsideClick: true,
};

export class CommandPalette extends Component<Signature> {
  guid = guidFor(this);
  inputId = `command-palette-input-${this.guid}`;
  listId = `command-palette-list-${this.guid}`;

  <template>
    <Dialog as |dialog|>
      {{yield
        (hash
          isOpen=dialog.isOpen
          open=dialog.open
          close=dialog.close
          focusOnClose=dialog.focusOnClose
          Dialog=(component CommandPaletteDialog dialog=dialog)
          Input=(component CommandPaletteInput inputId=this.inputId listId=this.listId)
          List=(component CommandPaletteList state=dialog listId=this.listId inputId=this.inputId)
          Item=(component CommandPaletteItem state=dialog)
        )
      }}

    </Dialog>
  </template>
}

export default CommandPalette;
