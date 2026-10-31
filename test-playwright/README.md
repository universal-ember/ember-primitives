# test-playwright

Real key presses in a real browser, with Playwright. Use this package for native behavior that `triggerKeyEvent` cannot start: Tab order, Escape on a `<dialog>`, and arrow keys on radios.

Each scenario has its own folder:

```
tests/{component-name}/{scenario-name}/
  scenario.gts
  spec.ts
```

`spec.ts` opens `scenario.gts` with `visitScenario(page, '{component-name}/{scenario-name}')`.

Run the tests after a build of the addon:

```bash
pnpm build
pnpm i -f
pnpm --filter test-playwright test:playwright
```

The tests use the installed Chrome (`channel: 'chrome'`).
