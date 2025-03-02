import { Label } from "./-private/typed-elements";
import type { TOC } from '@ember/component/template-only';
import type { WithBoundArgs } from '@glint/template';
export interface Signature {
    Element: HTMLInputElement;
    Args: {
        /**
         * The initial checked value of the Switch.
         * This value is reactive, so if the value that
         * `@checked` is set to updates, the state of the Switch will also update.
         */
        checked?: boolean;
        /**
         * Callback when the Switch state is toggled
         */
        onChange?: (checked: boolean, event: Event) => void;
    };
    Blocks: {
        default?: [
            {
                /**
                 * The Switch Element.
                 * It has a pre-wired `id` so that the relevant Label is
                 * appropriately associated via the `for` property of the Label.
                 *
                 * ```gjs
                 * import { Switch } from 'ember-primitives';
                 *
                 * <template>
                 *   <Switch as |s|>
                 *     <s.Control />
                 *   </Switch>
                 * </template>
                 * ```
                 */
                Control: WithBoundArgs<typeof Checkbox, 'checked' | 'id' | 'onChange'>;
                /**
                 * The Switch element requires a label, and this label already has
                 * the association to the Control by setting the `for` attribute to the `id` of the Control
                 *
                 * ```gjs
                 * import { Switch } from 'ember-primitives';
                 *
                 * <template>
                 *   <Switch as |s|>
                 *     <s.Label />
                 *   </Switch>
                 * </template>
                 * ```
                 */
                Label: WithBoundArgs<typeof Label, 'for'>;
            }
        ];
    };
}
interface ControlSignature {
    Element: HTMLInputElement;
    Args: {
        id: string;
        checked?: boolean;
        onChange: () => void;
    };
}
declare const Checkbox: TOC<ControlSignature>;
/**
 * @public
 */
export declare const Switch: TOC<Signature>;
export default Switch;
//# sourceMappingURL=switch.d.ts.map