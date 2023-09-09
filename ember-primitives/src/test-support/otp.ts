import { assert } from '@ember/debug';
import { fillIn, find, settled } from '@ember/test-helpers';

/**
 * @param {string} code the code to fill the input(s) with.
 * @param {string} [ selector ] if there are multiple OTP components on a page, this can be used to select one of them.
 */
export async function fillOTP(code: string, selector?: string) {
  let ancestor = selector ? find(selector) : document;

  assert(
    `Could not find ancestor element, does your selector match an existing element?`,
    ancestor,
  );

  let fieldset =
    ancestor instanceof HTMLFieldSetElement ? ancestor : ancestor.querySelector('fieldset');

  assert(
    `Could not find containing fieldset element (this holds the OTP Input fields). Was the OTP component rendered?`,
    fieldset,
  );

  let inputs = fieldset.querySelectorAll('input');

  assert(
    `code cannot be longer than the available inputs. code is of length ${code.length} but there are ${inputs.length}`,
    code.length <= inputs.length,
  );

  // let chars = code.split('');

  assert(`OTP Input for index 0 is missing!`, inputs[0]);

  /**
   * Relies on the paste functionality to be more relyable in test timings.
   */
  await fillIn(inputs[0], code);

  // Account for out-of-settled-system delay due to RAF debounce.
  await new Promise((resolve) => requestAnimationFrame(resolve));
  await settled();
}
