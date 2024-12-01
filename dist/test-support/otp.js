import { assert } from '@ember/debug';
import { find, fillIn, settled } from '@ember/test-helpers';

/**
 * @param {string} code the code to fill the input(s) with.
 * @param {string} [ selector ] if there are multiple OTP components on a page, this can be used to select one of them.
 */
async function fillOTP(code, selector) {
  let ancestor = selector ? find(selector) : document;
  assert(`Could not find ancestor element, does your selector match an existing element?`, ancestor);
  let fieldset = ancestor instanceof HTMLFieldSetElement ? ancestor : ancestor.querySelector('fieldset');
  assert(`Could not find containing fieldset element (this holds the OTP Input fields). Was the OTP component rendered?`, fieldset);
  let inputs = fieldset.querySelectorAll('input');
  assert(`code cannot be longer than the available inputs. code is of length ${code.length} but there are ${inputs.length}`, code.length <= inputs.length);
  let chars = code.split('');
  assert(`OTP Input for index 0 is missing!`, inputs[0]);
  assert(`Character at index 0 is missing`, chars[0]);
  for (let i = 0; i < chars.length; i++) {
    let input = inputs[i];
    let char = chars[i];
    assert(`Input at index ${i} is missing`, input);
    assert(`Character at index ${i} is missing`, char);
    input.value = char;
  }
  await fillIn(inputs[0], chars[0]);

  // Account for out-of-settled-system delay due to RAF debounce.
  await new Promise(resolve => requestAnimationFrame(resolve));
  await settled();
}

export { fillOTP };
//# sourceMappingURL=otp.js.map
