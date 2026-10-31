import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests',
  testMatch: '**/spec.ts',
  reporter: 'line',
  use: {
    baseURL: 'http://localhost:4210',
    channel: 'chrome',
  },
  webServer: {
    command: 'pnpm vite --port 4210 --strictPort',
    url: 'http://localhost:4210',
  },
});
