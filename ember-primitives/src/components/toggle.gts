import type { TOC } from '@ember/component/template-only';

export interface Signature {
  Element: HTMLButtonElement;
  Args: {
    /**
     * The pressed-state of the toggle.
     *
     * Can be used to control the state of the component.
     */
    pressed?: boolean;
    /**
     * Callback for when the toggle's state is changed.
     *
     * Can be used to control the state of the component.
     */
    onChange?: () => void;
  };
  Blocks: {
    default: [];
  };
}

export const Toggle: TOC<Signature> = <template>
  <button type='button' aria-pressed='' ...attributes>
    {{yield}}
  </button>
</template>;

export default Toggle;
