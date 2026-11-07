import "./resizable.css"
import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import { modifier } from 'ember-modifier';
import { Consume, Provide } from '../dom-context.js';
import { GroupState } from './resizable/state.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import templateOnly from '@ember/component/template-only';

;

/**
 * A resizable region within a `<Resizable>` group.
 *
 * Panels declare their constraints as data attributes, so the group
 * discovers them with DOM queries -- there is no registration, and a
 * Panel may contain another `<Resizable>` to nest layouts.
 */
let panelId = 0;
function nextPanelId() {
  return `ember-primitives__resizable__panel--${panelId++}`;
}
const Panel = setComponentTemplate(precompileTemplate("<div class=\"ember-primitives__resizable__panel\" data-min-size={{@minSize}} data-max-size={{@maxSize}} data-size={{@size}} data-collapsible={{if @collapsible \"true\"}} ...attributes {{!-- after ...attributes: the id is component-owned (the handles'\n      aria-controls depends on it being present and unique) --}} id={{(nextPanelId)}}>\n  {{yield}}\n</div>", {
  strictMode: true,
  scope: () => ({
    nextPanelId
  })
}), templateOnly());
function onPointerDown(state) {
  return event => state.startDrag(event.currentTarget, event);
}
function onKeyDown(state) {
  return event => state.handleKeyDown(event.currentTarget, event);
}
/**
 * The draggable (and keyboard-operable) divider between two Panels.
 *
 * Follows the WAI-ARIA window-splitter pattern, and controls the Panel
 * immediately before it. Finds its group via DOM context, so it must be
 * rendered inside a `<Resizable>`.
 *
 * Give each handle an accessible name (e.g. `aria-label="Resize sidebar"`).
 */
const Handle = setComponentTemplate(precompileTemplate("<Consume @key={{GroupState}} as |ctx|>\n  <div class=\"ember-primitives__resizable__handle\" role=\"separator\" tabindex=\"0\" data-orientation={{ctx.data.orientation}} {{on \"pointerdown\" (onPointerDown ctx.data)}} {{on \"keydown\" (onKeyDown ctx.data)}} ...attributes>\n    {{yield}}\n  </div>\n</Consume>", {
  strictMode: true,
  scope: () => ({
    Consume,
    GroupState,
    on,
    onPointerDown,
    onKeyDown
  })
}), templateOnly());
/**
 * A group of resizable panels, separated by draggable handles.
 *
 * Render `<Panel>` and `<Handle>` components inside -- they are their
 * own imports, and find the group via DOM context / DOM queries.
 *
 * Groups can be nested (a `<Resizable>` inside a Panel) to build
 * tree-shaped tiling layouts, i3 / tmux style.
 */
class Resizable extends Component {
  state = new GroupState({
    orientation: () => this.args.orientation,
    onLayoutChange: () => this.args.onLayoutChange
  });
  attach = modifier(element => this.state.attach(element));
  static {
    setComponentTemplate(precompileTemplate("<div class=\"ember-primitives__resizable\" data-orientation={{this.state.orientation}} {{this.attach}} ...attributes>\n  <Provide @data={{this.state}} @key={{GroupState}}>\n    {{yield}}\n  </Provide>\n</div>", {
      strictMode: true,
      scope: () => ({
        Provide,
        GroupState
      })
    }), this);
  }
}

export { Handle, Panel, Resizable };
//# sourceMappingURL=resizable.js.map
