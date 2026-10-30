import { expect, test } from '@playwright/test';

import { visitScenario } from '#tests/helpers.ts';

test('arrow keys do not change a readonly rating', async ({ page }) => {
  await visitScenario(page, 'rating/readonly-arrow-keys');

  const checked = page.locator('fieldset input:checked');

  await checked.focus();
  await page.keyboard.press('ArrowRight');

  await expect(checked).toHaveValue('2');
});
