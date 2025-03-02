import { assert } from '@ember/debug';

function getInputs(current) {
  let fieldset = current.closest('fieldset');
  assert('[BUG]: fieldset went missing', fieldset);
  return [...fieldset.querySelectorAll('input')];
}
function nextInput(current) {
  let inputs = getInputs(current);
  let currentIndex = inputs.indexOf(current);
  return inputs[currentIndex + 1];
}
function selectAll(event) {
  let target = event.target;
  assert(`selectAll is only meant for use with input elements`, target instanceof HTMLInputElement);
  target.select();
}
function handlePaste(event) {
  let target = event.target;
  assert(`handlePaste is only meant for use with input elements`, target instanceof HTMLInputElement);
  let clipboardData = event.clipboardData;
  assert(`Could not get clipboardData while handling the paste event on OTP. Please report this issue on the ember-primitives repo with a reproduction. Thanks!`, clipboardData);

  // This is typically not good to prevent paste.
  // But because of the UX we're implementing,
  // we want to split the pasted value across
  // multiple text fields
  event.preventDefault();
  let value = clipboardData.getData('Text');
  const digits = value;
  let i = 0;
  let currElement = target;
  while (currElement) {
    currElement.value = digits[i++] || '';
    let next = nextInput(currElement);
    if (next instanceof HTMLInputElement) {
      currElement = next;
    } else {
      break;
    }
  }

  // We want to select the first field again
  // so that if someone holds paste, or
  // pastes again, they get the same result.
  target.select();
}
function handleNavigation(event) {
  switch (event.key) {
    case 'Backspace':
      return handleBackspace(event);
    case 'ArrowLeft':
      return focusLeft(event);
    case 'ArrowRight':
      return focusRight(event);
  }
}
function focusLeft(event) {
  let target = event.target;
  assert(`only allowed on input elements`, target instanceof HTMLInputElement);
  let input = previousInput(target);
  input?.focus();
  requestAnimationFrame(() => {
    input?.select();
  });
}
function focusRight(event) {
  let target = event.target;
  assert(`only allowed on input elements`, target instanceof HTMLInputElement);
  let input = nextInput(target);
  input?.focus();
  requestAnimationFrame(() => {
    input?.select();
  });
}
const syntheticEvent = new InputEvent('input');
function handleBackspace(event) {
  if (event.key !== 'Backspace') return;

  /**
   * We have to prevent default because we
   * - want to clear the whole field
   * - have the focus behavior keep up with the key-repeat
   *   speed of the user's computer
   */
  event.preventDefault();
  let target = event.target;
  if (target && 'value' in target) {
    if (target.value === '') {
      focusLeft({
        target
      });
    } else {
      target.value = '';
    }
  }
  target?.dispatchEvent(syntheticEvent);
}
function previousInput(current) {
  let inputs = getInputs(current);
  let currentIndex = inputs.indexOf(current);
  return inputs[currentIndex - 1];
}
const autoAdvance = event => {
  assert('[BUG]: autoAdvance called on non-input element', event.target instanceof HTMLInputElement);
  let value = event.target.value;
  if (value.length === 0) return;
  if (value.length > 0) {
    if ('data' in event && event.data && typeof event.data === 'string') {
      event.target.value = event.data;
    }
    return focusRight(event);
  }
};
function getCollectiveValue(elementTarget, length) {
  if (!elementTarget) return;
  assert(`[BUG]: somehow the element target is not HTMLElement`, elementTarget instanceof HTMLElement);
  let parent;

  // TODO: should this logic be extracted?
  //       why is getting the target element within a shadow root hard?
  if (!(elementTarget instanceof HTMLInputElement)) {
    if (elementTarget.shadowRoot) {
      parent = elementTarget.shadowRoot;
    } else {
      parent = elementTarget.closest('fieldset');
    }
  } else {
    parent = elementTarget.closest('fieldset');
  }
  assert(`[BUG]: somehow the input fields were rendered without a parent element`, parent);
  let elements = parent.querySelectorAll('input');
  let value = '';
  assert(`found elements (${elements.length}) do not match length (${length}). Was the same OTP input rendered more than once?`, elements.length === length);
  for (let element of elements) {
    assert('[BUG]: how did the queried elements become a non-input element?', element instanceof HTMLInputElement);
    value += element.value;
  }
  return value;
}

export { autoAdvance, getCollectiveValue, handleNavigation, handlePaste, selectAll };
//# sourceMappingURL=utils.js.map
