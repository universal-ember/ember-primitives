import { htmlSafe } from '@ember/template';

import type { SafeString } from '@ember/template';

export type Placement =
  | 'top'
  | 'top-start'
  | 'top-end'
  | 'bottom'
  | 'bottom-start'
  | 'bottom-end'
  | 'left'
  | 'left-start'
  | 'left-end'
  | 'right'
  | 'right-start'
  | 'right-end';

export type OffsetOptions = number | { mainAxis?: number; crossAxis?: number };

export interface PlacementConfig {
  positionArea: string;
  selfProp: string;
  selfValue: string;
  offsetMargin: string;
  crossOffsetMargin: string;
  arrowSide: string;
  arrowIsVertical: boolean;
}

/**
 * Static lookup for CSS Anchor Positioning properties per placement.
 *
 * The position-area grid has the anchor element at center.
 * For -start/-end variants, we use span-right/span-left (or span-bottom/span-top)
 * to create an area starting at the anchor's edge, then align within that area.
 */
export const PLACEMENT_CONFIG: Record<Placement, PlacementConfig> = {
  top: {
    positionArea: 'top',
    selfProp: 'justify-self',
    selfValue: 'anchor-center',
    offsetMargin: 'margin-bottom',
    crossOffsetMargin: 'margin-left',
    arrowSide: 'bottom',
    arrowIsVertical: true,
  },
  'top-start': {
    positionArea: 'top span-right',
    selfProp: 'justify-self',
    selfValue: 'start',
    offsetMargin: 'margin-bottom',
    crossOffsetMargin: 'margin-left',
    arrowSide: 'bottom',
    arrowIsVertical: true,
  },
  'top-end': {
    positionArea: 'top span-left',
    selfProp: 'justify-self',
    selfValue: 'end',
    offsetMargin: 'margin-bottom',
    crossOffsetMargin: 'margin-left',
    arrowSide: 'bottom',
    arrowIsVertical: true,
  },
  bottom: {
    positionArea: 'bottom',
    selfProp: 'justify-self',
    selfValue: 'anchor-center',
    offsetMargin: 'margin-top',
    crossOffsetMargin: 'margin-left',
    arrowSide: 'top',
    arrowIsVertical: true,
  },
  'bottom-start': {
    positionArea: 'bottom span-right',
    selfProp: 'justify-self',
    selfValue: 'start',
    offsetMargin: 'margin-top',
    crossOffsetMargin: 'margin-left',
    arrowSide: 'top',
    arrowIsVertical: true,
  },
  'bottom-end': {
    positionArea: 'bottom span-left',
    selfProp: 'justify-self',
    selfValue: 'end',
    offsetMargin: 'margin-top',
    crossOffsetMargin: 'margin-left',
    arrowSide: 'top',
    arrowIsVertical: true,
  },
  left: {
    positionArea: 'left',
    selfProp: 'align-self',
    selfValue: 'anchor-center',
    offsetMargin: 'margin-right',
    crossOffsetMargin: 'margin-top',
    arrowSide: 'right',
    arrowIsVertical: false,
  },
  'left-start': {
    positionArea: 'left span-bottom',
    selfProp: 'align-self',
    selfValue: 'start',
    offsetMargin: 'margin-right',
    crossOffsetMargin: 'margin-top',
    arrowSide: 'right',
    arrowIsVertical: false,
  },
  'left-end': {
    positionArea: 'left span-top',
    selfProp: 'align-self',
    selfValue: 'end',
    offsetMargin: 'margin-right',
    crossOffsetMargin: 'margin-top',
    arrowSide: 'right',
    arrowIsVertical: false,
  },
  right: {
    positionArea: 'right',
    selfProp: 'align-self',
    selfValue: 'anchor-center',
    offsetMargin: 'margin-left',
    crossOffsetMargin: 'margin-top',
    arrowSide: 'left',
    arrowIsVertical: false,
  },
  'right-start': {
    positionArea: 'right span-bottom',
    selfProp: 'align-self',
    selfValue: 'start',
    offsetMargin: 'margin-left',
    crossOffsetMargin: 'margin-top',
    arrowSide: 'left',
    arrowIsVertical: false,
  },
  'right-end': {
    positionArea: 'right span-top',
    selfProp: 'align-self',
    selfValue: 'end',
    offsetMargin: 'margin-left',
    crossOffsetMargin: 'margin-top',
    arrowSide: 'left',
    arrowIsVertical: false,
  },
};

/**
 * Build the inline CSS that positions a floating element relative to its
 * anchor using CSS Anchor Positioning.
 *
 * The returned string covers placement (`position-area`), self-alignment,
 * fallback flipping (`position-try-fallbacks`), and viewport-aware visibility
 * (`position-visibility`). Optional `mainAxis` / `crossAxis` offsets are
 * expressed as margins in the appropriate direction for the chosen placement.
 */
export function anchorPositionStyle(
  placement: Placement,
  anchorName: string,
  offsetOptions?: OffsetOptions
): SafeString {
  const config = PLACEMENT_CONFIG[placement];

  const offsetOpts = offsetOptions ?? 0;
  const mainAxis = typeof offsetOpts === 'number' ? offsetOpts : (offsetOpts?.mainAxis ?? 0);
  const crossAxis = typeof offsetOpts === 'number' ? 0 : (offsetOpts?.crossAxis ?? 0);

  let style = `position: fixed; inset: auto; overflow: visible; border: none; position-anchor: ${anchorName}; position-area: ${config.positionArea}; ${config.selfProp}: ${config.selfValue}; width: max-content; margin: 0; position-try-fallbacks: flip-block; position-visibility: anchors-visible`;

  if (mainAxis) {
    style += `; ${config.offsetMargin}: ${mainAxis}px`;
  }

  if (crossAxis) {
    style += `; ${config.crossOffsetMargin}: ${crossAxis}px`;
  }

  return htmlSafe(style);
}
