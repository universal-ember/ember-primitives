import Component from "@glimmer/component";

/**
 * Allow only one disclosure to be open at a time
 */
export class SingleDisclosureManager extends Component<{
  Element: null;
  Args: {
    /**
     * Whether the disclosure is disabled. When `true`, all items cannot be expanded or collapsed.
     */
    disabled?: boolean;
    /**
     * When type is `single`, whether the disclosure is collapsible. When `true`, the selected item can be collapsed by clicking its trigger.
     */
    collapsible?: boolean;
    };
  Blocks: { default: [] };
}> {

}

/**
 * Allow multiple disclosures to be open at a time
 */
export class DisclosureMultipleManager extends Component<{
  Element: null;
  Args: {
    /**
     * Whether the disclosure is disabled. When `true`, all items cannot be expanded or collapsed.
     */
    disabled?: boolean;
      /**
       * The currently selected values. To be used in a controlled fashion in conjunction with `onValueChange`.
       */
      value: string[];
      /**
       * A callback that is called when the selected values change. To be used in a controlled fashion in conjunction with `value`.
       */
      onValueChange: (value?: string[] | undefined) => void;
      /**
       * Not available in a controlled fashion.
       */
      defaultValue?: never;
    }
  | {
    /**
     * Whether the disclosure is disabled. When `true`, all items cannot be expanded or collapsed.
     */
    disabled?: boolean;
      /**
       * Not available in an uncontrolled fashion.
       */
      value?: never;
      /**
       * Not available in an uncontrolled fashion.
       */
      onValueChange?: never;
      /**
       * The default values of the accordion. To be used in an uncontrolled fashion.
       */
      defaultValue?: string[];
      };

  Blocks: { default: [] };
}> {

}
