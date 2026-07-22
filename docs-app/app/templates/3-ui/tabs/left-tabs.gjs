import { Tabs } from 'ember-primitives/components/tabs';

export const LeftTabs = <template>
  <Tabs class="side-tabs" @label="Package manager" as |Tab|>
    <Tab @label="npm"><code>npm add ember-primitives</code></Tab>
    <Tab @label="pnpm"><code>pnpm add ember-primitives</code></Tab>
    <Tab @label="yarn"><code>yarn add ember-primitives</code></Tab>
  </Tabs>

  <style>
    @scope {
      .side-tabs {
        display: grid;
        grid-template-areas:
          "label label"
          "tablist tabpanel";
        grid-template-columns: max-content minmax(0, 1fr);
        border: 1px solid var(--doc-border);
        border-radius: 0.75rem;
        overflow: hidden;
        background: var(--doc-bg);
      }

      .ember-primitives__tabs__label {
        grid-area: label;
        padding: 0.65rem 0.85rem 0.25rem;
        font-size: 0.75rem;
        font-weight: 600;
        letter-spacing: 0.04em;
        text-transform: uppercase;
        color: var(--doc-text-3);
      }

      .ember-primitives__tabs__tabpanel {
        grid-area: tabpanel;
      }

      [role="tablist"] {
        grid-area: tablist;
        display: flex;
        flex-direction: column;
        border-right: 1px solid var(--doc-border);
        background: var(--doc-bg-soft);
      }

      [role="tab"] {
        border: 0;
        border-radius: 0;
        padding: 0.55rem 0.85rem;
        background: transparent;
        color: var(--doc-text-3);
        font-family: var(--font-sans);
        font-size: 0.8125rem;
        font-weight: 500;
        text-align: left;
        cursor: pointer;
      }

      [role="tab"][aria-selected="true"] {
        color: var(--doc-brand-1);
        background: var(--doc-bg);
        box-shadow: inset 2px 0 0 var(--doc-brand-1);
        font-weight: 600;
      }

      [role="tabpanel"] {
        padding: 1rem 1.1rem;
        color: var(--doc-text-1);
        font-family: var(--font-mono);
        font-size: 0.875rem;
      }

      code {
        font: inherit;
      }
    }
  </style>
</template>;
