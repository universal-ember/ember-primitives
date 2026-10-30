import { expect, test } from '@playwright/test';

import { visitScenario } from '#tests/helpers.ts';

test('Tab lands on the selected tab and does not change the selection', async ({ page }) => {
  await visitScenario(page, 'tabs/tab-to-selected');

  await page.locator('#before-tabs').focus();
  await page.keyboard.press('Tab');

  await expect(page.getByRole('tab', { name: 'Banana' })).toBeFocused();
  await expect(page.getByRole('tab', { name: 'Banana' })).toHaveAttribute('aria-selected', 'true');
});
