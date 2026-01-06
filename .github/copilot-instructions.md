# Copilot Instructions for ember-primitives

## Repository Overview

This repository provides UI primitives for building Ember.js applications faster.

**Documentation**: https://ember-primitives.pages.dev/

## Ember MCP Server

**Always use the ember-mcp server** when working with Ember code in this repository. The ember-mcp server from `ember-tooling/ember-mcp` provides Ember-specific tooling and context that is essential for working with Ember.js applications and addons.

## Code Conventions

### Glimmer Components
- Components use the `.gts` format combining TypeScript and templates
- Always define explicit signatures with `Element`, `Args`, and `Blocks`

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

### State Management
- Use `@tracked` from `@glimmer/tracking` for reactive properties
- Use `cell` from `ember-resources` for local reactive state
- Use `tracked-built-ins` for tracked data structures

### Accessibility
- Components should be accessible by default
- Use proper ARIA attributes and roles
- Follow WAI-ARIA best practices for interactive components
