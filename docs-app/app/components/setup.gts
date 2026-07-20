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
      [role="tablist"] {
        margin-top: 0.5rem;
        display: flex;
        border: 1px solid;
        border-bottom: none;
        width: min-content;
        border-top-left-radius: 0.25rem;
        border-top-right-radius: 0.25rem;
      }

      [role="tab"] {
        color: var(--color-foreground);
        width: max-content;
        display: inline-block;
        padding: 0.25rem 0.5rem;
        background: var(--color-page-background);
        outline: none;
        font-weight: bold;
        cursor: pointer;
        box-shadow: inset 0 -1px 0px black;
      }

      [role="tab"][aria-selected="true"] {
        box-shadow: inset 0 -4px 0px orange;
      }

      [role="tab"]:first-of-type {
        border-top-left-radius: 0.25rem;
      }
      [role="tab"]:last-of-type {
        border-top-right-radius: 0.25rem;
      }

      [role="tabpanel"] {
        color: var(--color-foreground);
        padding: 1rem;
        border: 1px solid;
        border-radius: 0 0.25rem 0.25rem;
        background: var(--color-page-background);
        width: 100%;
        overflow: auto;
        font-family: monospace;
      }
    }
  </style>
</template>;
