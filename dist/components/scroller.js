import Component from '@glimmer/component';
import { isDestroyed, isDestroying } from '@ember/destroyable';
import { hash } from '@ember/helper';
import { modifier } from 'ember-modifier';
import { precompileTemplate } from '@ember/template-compilation';
import { setComponentTemplate } from '@ember/component';

class Scroller extends Component {
  withinElement;
  ref = modifier(el1 => {
    this.withinElement = el1;
  });
  #frame;
  scrollToBottom = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }
    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.withinElement.scrollTo({
        top: this.withinElement.scrollHeight,
        behavior: 'auto'
      });
    });
  };
  scrollToTop = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }
    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.withinElement.scrollTo({
        top: 0,
        behavior: 'auto'
      });
    });
  };
  scrollToLeft = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }
    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.withinElement.scrollTo({
        left: 0,
        behavior: 'auto'
      });
    });
  };
  scrollToRight = () => {
    if (this.#frame) {
      cancelAnimationFrame(this.#frame);
    }
    this.#frame = requestAnimationFrame(() => {
      if (isDestroyed(this) || isDestroying(this)) return;
      this.withinElement.scrollTo({
        left: this.withinElement.scrollWidth,
        behavior: 'auto'
      });
    });
  };
  static {
    setComponentTemplate(precompileTemplate("\n    <div tabindex=\"0\" ...attributes {{this.ref}}>\n      {{yield (hash scrollToBottom=this.scrollToBottom scrollToTop=this.scrollToTop scrollToLeft=this.scrollToLeft scrollToRight=this.scrollToRight)}}\n    </div>\n  ", {
      strictMode: true,
      scope: () => ({
        hash
      })
    }), this);
  }
}

export { Scroller };
//# sourceMappingURL=scroller.js.map
