import { hash } from '@ember/helper';
import { on } from '@ember/modifier';

import { elementState, ElementState } from './element-state';
import { dialogState } from './state';

import type { DialogState } from './state';
import type { TOC } from '@ember/component/template-only';
import type { ModifierLike, WithBoundArgs } from '@glint/template';

const DialogElement: TOC<{
  Element: HTMLDialogElement;
  Args: {
    /**
     * @internal
     */
    onClose: () => void;

    /**
     * @internal
     */
    register: ModifierLike<{ Element: HTMLDialogElement }>;
  };
  Blocks: { default: [] };
}> = <template>
  <dialog ...attributes {{on 'close' @onClose}} {{@register}}>
    {{yield}}
  </dialog>
</template>;

export interface Signature {
  Args: {
    /**
     * Optionally set the open state of the <dialog>
     * The state will still be managed internally,
     * so this does not need to be a maintained value, but whenever it changes,
     * the dialog element will reflect that change accordingly.
     */
    open?: boolean;
    /**
     * When the <dialog> is closed, this function will be called
     * and the <dialog>'s `returnValue` will be passed.
     *
     * This can be used to determine which button was clicked to close the modal
     */
    onClose?: (returnValue: string) => void;
  };
  Blocks: {
    default: [
      {
        isOpen: boolean;
        close: () => void;
        open: () => void;
        Dialog: WithBoundArgs<typeof DialogElement, 'onClose' | 'register'>;
      }
    ];
  };
}

function useEffect(
  eState: ElementState,
  state: DialogState,
  userProvidedValue: boolean | undefined
) {
  if (userProvidedValue === undefined) return;

  requestAnimationFrame(() => {
    if (!eState.element) {
      return;
    }

    if (userProvidedValue) {
      state.open();
    } else {
      state.close();
    }
  });
}

export const Dialog: TOC<Signature> = <template>
  {{#let (elementState) as |elementState|}}
    {{#let (dialogState elementState @onClose) as |state|}}

      {{yield
        (hash
          isOpen=state.isOpen
          open=state.open
          close=state.close
          Dialog=(component DialogElement onClose=state.handleClose register=elementState.register)
        )
      }}

      {{!
        no-op under best use case,
        double render when folks want to control the state
        (double renders and other state maintenance issues are why
         folks should avoid "useEffect" in all frameworks)
      }}
      {{(useEffect elementState state @open)}}
    {{/let}}
  {{/let}}
</template>;

export const Modal = Dialog;

export default Dialog;
