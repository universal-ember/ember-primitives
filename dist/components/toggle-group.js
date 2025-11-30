
import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { hash } from '@ember/helper';
import { getTabsterAttribute, MoverDirections } from 'tabster';
import { TrackedSet } from 'tracked-built-ins';
import { localCopy } from 'tracked-toolbox';
import { Toggle } from './toggle.js';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';
import { g, i, n } from 'decorator-transforms/runtime';

const TABSTER_CONFIG = getTabsterAttribute({
  mover: {
    direction: MoverDirections.Both,
    cyclic: true
  }
}, true);
function isMulti(x) {
  return x === "multi";
}
class ToggleGroup extends Component {
  // See: https://github.com/typed-ember/glint/issues/715
  static {
    setComponentTemplate(precompileTemplate("\n    {{#if (isMulti this.args.type)}}\n      <MultiToggleGroup @value={{this.args.value}} @onChange={{this.args.onChange}} ...attributes as |x|>\n        {{yield x}}\n      </MultiToggleGroup>\n    {{else}}\n      <SingleToggleGroup @value={{this.args.value}} @onChange={{this.args.onChange}} ...attributes as |x|>\n        {{yield x}}\n      </SingleToggleGroup>\n    {{/if}}\n  ", {
      strictMode: true,
      scope: () => ({
        isMulti,
        MultiToggleGroup,
        SingleToggleGroup
      })
    }), this);
  }
}
class SingleToggleGroup extends Component {
  static {
    g(this.prototype, "activePressed", [localCopy("args.value")]);
  }
  #activePressed = (i(this, "activePressed"), void 0); // eslint-disable-next-line @typescript-eslint/no-unsafe-call
  handleToggle = value => {
    if (this.activePressed === value) {
      this.activePressed = undefined;
      return;
    }
    this.activePressed = value;
    this.args.onChange?.(this.activePressed);
  };
  isPressed = value => value === this.activePressed;
  static {
    setComponentTemplate(precompileTemplate("\n    <div data-tabster={{TABSTER_CONFIG}} ...attributes>\n      {{yield (hash Item=(component Toggle onChange=this.handleToggle isPressed=this.isPressed))}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        TABSTER_CONFIG,
        hash,
        Toggle
      })
    }), this);
  }
}
class MultiToggleGroup extends Component {
  /**
  * Normalizes @value to a Set
  * and makes sure that even if the input Set is reactive,
  * we don't mistakenly dirty it.
  */
  get activePressed() {
    const value = this.args.value;
    if (!value) {
      return new TrackedSet();
    }
    if (Array.isArray(value)) {
      return new TrackedSet(value);
    }
    if (value instanceof Set) {
      return new TrackedSet(value);
    }
    return new TrackedSet([value]);
  }
  static {
    n(this.prototype, "activePressed", [cached]);
  }
  handleToggle = value => {
    if (this.activePressed.has(value)) {
      this.activePressed.delete(value);
    } else {
      this.activePressed.add(value);
    }
    this.args.onChange?.(new Set(this.activePressed.values()));
  };
  isPressed = value => this.activePressed.has(value);
  static {
    setComponentTemplate(precompileTemplate("\n    <div data-tabster={{TABSTER_CONFIG}} ...attributes>\n      {{yield (hash Item=(component Toggle onChange=this.handleToggle isPressed=this.isPressed))}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        TABSTER_CONFIG,
        hash,
        Toggle
      })
    }), this);
  }
}

export { ToggleGroup };
//# sourceMappingURL=toggle-group.js.map
