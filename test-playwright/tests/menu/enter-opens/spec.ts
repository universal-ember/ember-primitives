import { expect, test } from '@playwright/test';

import { visitScenario } from '#tests/helpers.ts';

test('Enter on the trigger opens the menu and focuses the first item', async ({ page }) => {
  await visitScenario(page, 'menu/enter-opens');

  await page.locator('#menu-trigger').focus();
  await page.keyboard.press('Enter');

  await expect(page.getByRole('menuitem', { name: 'One' })).toBeFocused();
});
