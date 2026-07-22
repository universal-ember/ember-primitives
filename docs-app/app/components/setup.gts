import { Tabs } from 'ember-primitives/components/tabs';

import { Link } from '@universal-ember/docs-support';

import type { TOC } from '@ember/component/template-only';

function dropExtension(name: string | undefined) {
  if (!name) return;

  return name.replace(/\.g?(j|t)s/, '');
}

function orDefault(name: string | undefined) {
  return name || 'ember-primitives';
}

/**
 * ember-primitives releases were tagged `ember-primitives@<version>`
 * up through 0.10.1, and `v<version>-<package-name>` from 0.10.2 onward.
 */
function isOldStyleTag(version: string) {
  const [major = 0, minor = 0, patch = 0] = version.split('.').map(Number);

  return major === 0 && (minor < 10 || (minor === 10 && patch < 2));
}

function releaseURL(name: string | undefined, version: string) {
  const packageName = orDefault(name);
  const tag =
    packageName === 'ember-primitives' && isOldStyleTag(version)
      ? `ember-primitives@${version}`
      : `v${version}-${packageName}`;

  return `https://github.com/universal-ember/ember-primitives/releases/tag/${tag}`;
}

export const SetupInstructions: TOC<{
  Args: {
    name?: string;
    src?: string;
    since?: string;
  };
}> = <template>
  <Tabs class="tabs not-prose" @label="Install as a library" as |Tab|>
    <Tab @label="npm">npm add {{orDefault @name}}</Tab>
    <Tab @label="pnpm">pnpm add {{orDefault @name}}</Tab>
    <Tab @label="yarn">yarn add {{orDefault @name}}</Tab>
  </Tabs>

  {{#if @src}}
    <br />
    <Tabs class="tabs not-prose" @label="Own the code" as |Tab|>
      <Tab @label="npx">npx ember-primitives -- emit {{dropExtension @src}}</Tab>
      <Tab @label="pnpm dlx">pnpm dlx ember-primitives emit {{dropExtension @src}}</Tab>
      <Tab @label="Copy from GitHub">
        <Link
          href="https://github.com/universal-ember/ember-primitives/blob/main/ember-primitives/src/{{@src}}"
        >
          Edit or Copy from the Source
        </Link>
      </Tab>
    </Tabs>
  {{/if}}

  {{#if @since}}
    <p>
      Introduced in
      <Link href={{releaseURL @name @since}}>{{@since}}</Link>
    </p>
  {{/if}}

  <style scoped>
    .tabs {
      margin: 1rem 0 1.5rem;

      [role="tablist"] {
        display: flex;
        gap: 0.25rem;
        width: max-content;
        max-width: 100%;
        padding: 0.25rem;
        border: 1px solid var(--doc-border);
        border-radius: var(--doc-radius-sm) var(--doc-radius-sm) 0 0;
        background: var(--doc-bg-soft);
        border-bottom: none;
      }

      [role="tab"] {
        color: var(--doc-text-2);
        width: max-content;
        display: inline-flex;
        align-items: center;
        padding: 0.4rem 0.75rem;
        background: transparent;
        outline: none;
        font-weight: 500;
        font-size: 0.8125rem;
        font-family: var(--font-sans);
        cursor: pointer;
        border: 0;
        border-radius: var(--doc-radius-xs);
        box-shadow: none;
        transition:
          color 0.12s ease,
          background-color 0.12s ease;
      }

      [role="tab"]:hover {
        color: var(--doc-text-1);
        background: color-mix(in srgb, var(--doc-text-1) 6%, transparent);
      }

      [role="tab"][aria-selected="true"] {
        color: var(--doc-brand-1);
        background: var(--doc-bg);
        box-shadow: inset 0 -2px 0 var(--doc-brand-1);
      }

      [role="tabpanel"] {
        color: var(--doc-text-1);
        padding: 1rem 1.15rem;
        border: 1px solid var(--doc-border);
        border-radius: 0 var(--doc-radius-sm) var(--doc-radius-sm) var(--doc-radius-sm);
        background: var(--doc-bg-alt);
        width: 100%;
        overflow: auto;
        font-family: var(--font-mono);
        font-size: 0.875rem;
        line-height: 1.6;
      }
    }
  </style>
</template>;
