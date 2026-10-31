import { expect, test } from '@playwright/test';

import { visitScenario } from '#tests/helpers.ts';

test('Escape closes a modal and returns focus to the opener', async ({ page }) => {
  await visitScenario(page, 'modal/escape-closes');

  await page.locator('#open-modal').focus();
  await page.keyboard.press('Enter');
  await expect(page.getByRole('dialog', { name: 'Settings' })).toBeVisible();

  await page.keyboard.press('Escape');

  await expect(page.getByRole('dialog', { name: 'Settings' })).toBeHidden();
  await expect(page.locator('#open-modal')).toBeFocused();
});
