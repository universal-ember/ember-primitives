import { html, LitElement } from 'lit';
import { createContext, consume, provide } from '@lit/context';
import { property } from 'lit/decorators.js';

let i = 0;
function uniqueId() {
  i++;
  return `primitiveId-${i}`;
}

const stateContext = createContext('switch-state');
/**
 * emits "change" event
 */
class Switch extends LitElement {
  static properties = {
    checked: { type: Boolean },
  };

  @provide({ context: stateContext }) id = uniqueId();

  handleChange = (event: Event) => {
    this.dispatchEvent(
      new CustomEvent('change', {
        detail: {
          checked: event.target.checked,
        },
        bubbles: true,
      })
    );
  };

  render() {
    return html`<div></div>`;
  }
}

class Control extends HTMLElement {
  @consume({ context: stateContext })
  @property({ attribute: false })
  declare id: string;

  constructor() {
    super();

    console.log('id', this.id);
    this.setAttribute('id', this.id);
    this.innerHTML = `<input id=${this.id}>`;
  }

  render() {
    return html`<input id=${this.id} />`;
  }
}

class Label extends HTMLElement {
  @consume({ context: stateContext })
  @property({ attribute: false })
  declare id: string;

  constructor() {
    super();

    console.log('id', this.id);
    this.setAttribute('for', this.id);
    this.innerHTML = `<label for=${this.id}></label>`;
  }
  // render() {
  //   return html`<label for=${this.id}></label>`;
  // }
}

Switch.Control = Control;
Switch.Label = Label;

customElements.define('primitive-switch', Switch);
customElements.define('primitive-switch-control', Switch.Control);
// either:
//  <primitive-switch-label>
//  or
//  <label is="primitive-switch-label">
customElements.define('primitive-switch-label', Switch.Label, {
  extends: 'label',
});
