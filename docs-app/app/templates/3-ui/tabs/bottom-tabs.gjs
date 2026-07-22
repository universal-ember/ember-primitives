import { Tabs } from 'ember-primitives/components/tabs';

export const BottomTabs = <template>
  <Tabs class="bottom-tabs" @label="Package manager" as |Tab|>
    <Tab @label="npm"><code>npm add ember-primitives</code></Tab>
    <Tab @label="pnpm"><code>pnpm add ember-primitives</code></Tab>
    <Tab @label="yarn"><code>yarn add ember-primitives</code></Tab>
  </Tabs>

  <style>
    @scope {
      .bottom-tabs {
        display: grid;
        grid-template-areas:
          "label"
          "tabpanel"
          "tablist";
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
        border-top: 1px solid var(--doc-border);
        background: var(--doc-bg-soft);
      }

      [role="tab"] {
        position: relative;
        border: 0;
        border-radius: 0;
        padding: 0.55rem 0.85rem;
        background: transparent;
        color: var(--doc-text-3);
        font-family: var(--font-sans);
        font-size: 0.8125rem;
        font-weight: 500;
        cursor: pointer;
      }

      [role="tab"][aria-selected="true"] {
        color: var(--doc-brand-1);
        font-weight: 600;
      }

      [role="tab"][aria-selected="true"]::before {
        content: "";
        position: absolute;
        left: 0.55rem;
        right: 0.55rem;
        top: -1px;
        height: 2px;
        background: var(--doc-brand-1);
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
