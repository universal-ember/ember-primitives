import { expect, test } from '@playwright/test';

import { visitScenario } from '#tests/helpers.ts';

test('Escape closes a menu inside a modal, and the modal stays open', async ({ page }) => {
  await visitScenario(page, 'menu/escape-in-modal');

  await page.locator('#open-modal').click();
  await page.locator('#menu-trigger').click();
  await expect(page.getByRole('menuitem', { name: 'One' })).toBeFocused();

  await page.keyboard.press('Escape');

  await expect(page.locator('#menu-content')).toHaveCount(0);
  await expect(page.getByRole('dialog', { name: 'Settings' })).toBeVisible();
  await expect(page.locator('#menu-trigger')).toBeFocused();
});
