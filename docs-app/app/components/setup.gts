import { Tabs } from 'ember-primitives/components/tabs';

import type { TOC } from '@ember/component/template-only';

export const SetupInstructions: TOC<{
  Args: {
    name?: string;
  };
}> = <template>
  <Tabs class="tabs" @label="Install as a library" as |Tab|>
    <Tab @label="npm">npm add ember-primitives</Tab>
    <Tab @label="pnpm">pnpm add ember-primitives</Tab>
    <Tab @label="yarn">yarn add ember-primitives</Tab>
  </Tabs>

  {{#if @name}}
    <Tabs class="tabs" @label="Own the code" as |Tab|>
      <Tab @label="npx">npx ember-primitives -- emit {{@name}}</Tab>
      <Tab @label="pnpm dlx">pnpm dlx ember-primitives emit {{@name}}</Tab>
    </Tabs>
  {{/if}}

  <style scoped>
    .tabs {
      [role="tablist"] {
        min-width: 100%;
      }

      [role="tab"] {
        color: black;
        display: inline-block;
        padding: 0.25rem 0.5rem;
        background: hsl(220deg 20% 94%);
        outline: none;
        font-weight: bold;
        cursor: pointer;
        box-shadow: inset 0 -1px 1px black;
      }

      [role="tab"][aria-selected="true"] {
        background: white;
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
        border-radius: 0 0.25rem 0.25rem;
        background: white;
        width: 100%;
        overflow: auto;
        font-family: ui-monospace monospace;
      }
    }
  </style>
</template>;
