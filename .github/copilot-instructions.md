# Copilot Instructions for ember-primitives

## Repository Overview

This repository contains **ember-primitives**, a library providing UI primitives for building Ember.js applications faster. The project is a monorepo using pnpm workspaces and turbo for builds.

**Documentation**: https://ember-primitives.pages.dev/

## Technology Stack

- **Framework**: Ember.js v6+ (Octane edition)
- **Language**: TypeScript with Glimmer Component Syntax (`.gts` and `.gjs` files)
- **Package Manager**: pnpm (v10.26.2)
- **Build System**: Rollup with turbo for monorepo orchestration
- **Testing**: Ember QUnit (tests run in `test-app` subdirectory)
- **Linting**: ESLint with `@nullvoxpopuli/eslint-configs`
- **Formatting**: Prettier with `prettier-plugin-ember-template-tag`

## Project Structure

```
ember-primitives/
├── ember-primitives/     # Main addon package (v2 addon format)
│   └── src/
│       └── components/   # Glimmer components (.gts files)
├── test-app/             # Test application
├── docs-app/             # Documentation site
├── packages/             # Additional packages
│   ├── docs-support/
│   └── which-heading-do-i-need/
└── dev/                  # Development utilities
```

## Essential Commands

### Setup
```bash
pnpm install
pnpm build
```

### Development
```bash
pnpm dev              # Start development mode with TUI
pnpm build            # Build all packages
```

### Linting
```bash
pnpm lint             # Run all linters
pnpm lint:fix         # Auto-fix linting issues
```

### Testing
```bash
cd test-app
pnpm start            # Start test server
# Visit /tests in browser
```

## Code Style Guidelines

### TypeScript & JavaScript
- **File extensions**: Use `.gts` for Glimmer TypeScript components, `.ts` for utilities
- **Quotes**: Single quotes for strings (enforced by prettier)
- **Print width**: 100 characters
- **Trailing commas**: ES5 style
- **Type annotations**: TypeScript is required; `@typescript-eslint/no-explicit-any` is disabled

### Glimmer Components
- Components use the `.gts` format combining TypeScript and templates
- Use `@glimmer/component` as the base class
- Define explicit signatures with `Element`, `Args`, and `Blocks`
- Use template-only components (TOC) when no JavaScript is needed

Example:
```typescript
import Component from '@glimmer/component';

export class MyComponent extends Component<{
  Element: HTMLDivElement;
  Args: {
    value: string;
  };
  Blocks: {
    default: [];
  };
}> {
  <template>
    <div ...attributes>
      {{@value}}
      {{yield}}
    </div>
  </template>
}
```

### Imports
- Use double quotes for imports (per prettier config)
- Import from `@ember/*` for framework APIs
- Import from `@glimmer/*` for component and tracking
- Use `ember-element-helper` for dynamic element rendering
- Use `ember-resources` for reactive state management
- Use `reactiveweb` for reactive utilities

### State Management
- Use `@tracked` from `@glimmer/tracking` for reactive properties
- Use `cell` from `ember-resources` for local reactive state
- Use `tracked-built-ins` for tracked data structures

## Important Patterns

### Component Signatures
Always define explicit TypeScript signatures for components:
- `Element`: The HTML element type (e.g., `HTMLButtonElement`)
- `Args`: Component arguments with descriptions
- `Blocks`: Named blocks with their yielded values

### Accessibility
- Components should be accessible by default
- Use proper ARIA attributes and roles
- Follow WAI-ARIA best practices for interactive components

### Testing
- Tests are located in `test-app/tests`
- Use `@ember/test-helpers` for component testing
- Use `@ember/test-waiters` for async operations

## Ember MCP Server

**Always use the ember-mcp server** when working with Ember code in this repository. The ember-mcp server from `ember-tooling/ember-mcp` provides Ember-specific tooling and context that is essential for working with Ember.js applications and addons.

The server is configured in `.vscode/settings.json` and provides:
- Ember-specific code understanding
- Component and addon structure awareness
- Ember conventions and best practices

## V2 Addon Format

This is an Ember v2 addon (using `@embroider/addon-dev`):
- Source code in `src/` directory
- Exports defined in `package.json` exports field
- Built output in `dist/` directory
- Type declarations in `declarations/` directory

## Dependencies

### Key Runtime Dependencies
- `@glimmer/component`, `@glimmer/tracking` - Core Ember primitives
- `ember-element-helper` - Dynamic element rendering
- `ember-resources` - Reactive state management
- `reactiveweb` - Reactive utilities
- `@floating-ui/dom` - Positioning engine for popovers/tooltips
- `tabster` - Focus management

### Development Workflow
1. Make changes in `ember-primitives/src/`
2. Build with `pnpm build` or watch with `pnpm dev`
3. Test in `test-app/` by running `pnpm start` and visiting `/tests`
4. Lint with `pnpm lint` before committing

## Additional Notes

- The repository uses conventional commits
- All packages are published from the monorepo root
- The project uses `release-plan` for automated releases
- Prettier and ESLint configurations are consistent across all packages
- Node.js version 20+ is required
