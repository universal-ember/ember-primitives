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
       * Is this item selected?
       */
      isSelected: boolean;
      /**
       * How much % of this item is selected?
       */
      percentSelected: number;
      /**
       * Which number of item is this item within the overall rating group.
       */
      value: number;
      /**
       * Should this be marked as readonly
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
   * Can change color when selected.
   */
  icon?: string;

  /**
   * The symbol to use for a half-selected variant of the icon.
   * Only rendered when using fractional ratings (step < 1).
   *
   * Defaults to the same as icon.
   * Typically used with different symbols like "⯨" for half-star
   */
  iconHalf?: string;
}
