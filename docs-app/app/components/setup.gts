import { Tabs } from 'ember-primitives/components/tabs';
import { Link } from '@universal-ember/docs-support';

import type { TOC } from '@ember/component/template-only';

function dropExtension(name: string | undefined) {
  if (!name) return;

  return name.replace(/\.g?(j|t)s/, '');
}

export const SetupInstructions: TOC<{
  Args: {
    src?: string;
  };
}> = <template>
  <Tabs class="tabs not-prose" @label="Install as a library" as |Tab|>
    <Tab @label="npm">npm add ember-primitives</Tab>
    <Tab @label="pnpm">pnpm add ember-primitives</Tab>
    <Tab @label="yarn">yarn add ember-primitives</Tab>
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
          https://github.com/universal-ember/ember-primitives/blob/main/ember-primitives/src/{{@src}}
        </Link>
      </Tab>
    </Tabs>
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
        color: black;
        width: max-content;
        display: inline-block;
        padding: 0.25rem 0.5rem;
        background: hsl(220deg 20% 94%);
        outline: none;
        font-weight: bold;
        cursor: pointer;
        box-shadow: inset 0 -1px 1px black;
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
        color: black;
        padding: 1rem;
        border: 1px solid;
        border-radius: 0 0.25rem 0.25rem;
        background: white;
        width: 100%;
        overflow: auto;
        font-family: monospace;
      }
    }
  </style>
</template>;
