import Component from "@glimmer/component";
import { cell } from "ember-resources";
import { Label } from './-private/typed-elements';
import type { TOC } from "@ember/component/template-only";
import type { WithBoundArgs } from "@glint/template";
export interface Signature {
    /**
     * The wrapping element.
     * An accessible name belongs on `Control`, or comes from `Label`.
     */
    Element: HTMLDivElement;
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
                 * The current state of the Switch.
                 *
                 * ```gjs
                 * import { Switch } from 'ember-primitives/components/switch';
                 *
                 * <template>
                 *   <Switch as |s|>
                 *     {{s.isChecked}}
                 *   </Switch>
                 * </template>
                 * ```
                 */
                isChecked: boolean;
                /**
                 * The Switch Element.
                 * It has a pre-wired `id` so that the relevant Label is
                 * appropriately associated via the `for` property of the Label.
                 *
                 * ```gjs
                 * import { Switch } from 'ember-primitives/components/switch';
                 *
                 * <template>
                 *   <Switch as |s|>
                 *     <s.Control />
                 *   </Switch>
                 * </template>
                 * ```
                 */
                Control: WithBoundArgs<typeof Checkbox, "checked" | "id" | "onChange">;
                /**
                 * The Switch element requires a label, and this label already has
                 * the association to the Control by setting the `for` attribute to the `id` of the Control
                 *
                 * ```gjs
                 * import { Switch } from 'ember-primitive/components/switchs';
                 *
                 * <template>
                 *   <Switch as |s|>
                 *     <s.Label />
                 *   </Switch>
                 * </template>
                 * ```
                 */
                Label: WithBoundArgs<typeof Label, "for">;
            }
        ];
    };
}
interface ControlSignature {
    Element: HTMLInputElement;
    Args: {
        id: string;
        checked?: ReturnType<typeof cell<boolean>>;
        onChange?: (checked: boolean, event: Event) => void;
    };
}
declare class Checkbox extends Component<ControlSignature> {
    handleClick: (event: Event) => void;
}
/**
 * @public
 */
export declare const Switch: TOC<Signature>;
export default Switch;
//# sourceMappingURL=switch.d.ts.map