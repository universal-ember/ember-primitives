import { html, LitElement } from 'lit';

let i = 0;
function uniqueId() {
  i++;
  return `primitiveId-${i}`;
}

function getContext(startAt) {
  let node;
  while ((node = startAt)) {
    let parent = node.parentElement;
    if (!parent) return;

    if (parent.tagName === 'primitive-switch') {
      return parent;
    }
  }
}

/**
 * emits "change" event
 */
class Switch extends HTMLElement {
  static properties = {
    checked: { type: Boolean },
  };

  id = uniqueId();

  handleChange = (event) => {
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
  get id() {
    return getContext(this).id;
  }

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
  get id() {
    return getContext(this).id;
  }

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
