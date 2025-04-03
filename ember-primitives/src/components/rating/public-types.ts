import type { ComponentLike } from '@glint/template';

/**
 * @public
 */
export interface ComponentIcons {
  /**
   * It's possible to completely manage the state of an individual Icon yourself
   * by passing a component that has ...attributes on its outer element and receives
   * a @isSelected argument which is true for selected and false for unselected.
   *
   * There is also argument passed which is the percent-amount of selection if you want fractional ratings, @selectedPercent
   */
  icon: ComponentLike<{
    Element: HTMLElement;
    Args: {
      /**
       *
       */
      isDisabled: boolean;
      /**
       *
       */
      selectedPercent: number;
      /**
       *
       */
      value: number;
      /**
       *
       */
      readonly: boolean;
    };
  }>;
}

/**
 * @public
 */
export interface StringIcons {
  /**
   * The symbol to use for an unselected variant of the icon
   *
   * Defaults to "★";
   *  Can change color when selected.
   */
  icon?: string;
}
