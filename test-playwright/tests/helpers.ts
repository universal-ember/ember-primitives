import { expect, type Page } from '@playwright/test';

/**
 * @param path `{component-name}/{scenario-name}`, the folder of the scenario in tests/
 */
export async function visitScenario(page: Page, path: string) {
  await page.goto(`/?scenario=${path}`);
  await expect(page.locator('body')).toHaveAttribute('data-ready', 'true');
}
