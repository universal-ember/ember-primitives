import { modifier as eModifier } from 'ember-modifier';

import { PLACEMENT_CONFIG } from './placement.ts';

import type { Placement } from './placement.ts';

/**
 * Positions an arrow element on the side of its anchor-positioned parent
 * facing the reference element, centered along the cross-axis.
 *
 * Example:
 * ```gjs
 * import { attachArrow } from 'ember-primitives/anchor-position';
 *
 * <template>
 *   <div {{attachArrow placement="bottom"}}></div>
 * </template>
 * ```
 */
export const attachArrow = eModifier<{
  Element: Element;
  Args: {
    Named: {
      placement: Placement;
    };
  };
}>((el, _: [], { placement }) => {
  if (!(el instanceof HTMLElement)) return;

  const config = PLACEMENT_CONFIG[placement];

  el.style.setProperty('position', 'absolute');

  if (config.arrowIsVertical) {
    el.style.setProperty('left', '50%');
    el.style.setProperty('translate', '-50% 0');
  } else {
    el.style.setProperty('top', '50%');
    el.style.setProperty('translate', '0 -50%');
  }

  el.style.setProperty(config.arrowSide, '-4px');
});
