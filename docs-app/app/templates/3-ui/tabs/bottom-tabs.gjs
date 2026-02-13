import { Tabs } from 'ember-primitives/components/tabs';

export const BottomTabs = <template>
  <Tabs @label="Install with your favorite package-manager" as |Tab|>
    <Tab @label="npm">npm add ember-primitives</Tab>
    <Tab @label="pnpm">pnpm add ember-primitives</Tab>
    <Tab @label="yarn">yarn add ember-primitives</Tab>
  </Tabs>
  <style>
    /* https://caniuse.com/css-cascade-scope */
    @scope {
      .ember-primitives__tabs {
        display: grid;
        grid-template-areas:
          "label label"
          "tabpanel tabpanel"
          "tablist tablist";
      }
      .ember-primitives__tabs__label {
        grid-area: label;
      }
      .ember-primitives__tabs__tabpanel {
        grid-area: tabpanel;
        display: flex;
        border: 1px solid;
      }

      [role="tablist"] {
        grid-area: tablist;
        display: flex;
        flex-wrap: wrap;
      }

      [role="tab"] {
        border-radius: 0;
        color: black;
        padding: 0.25rem 0.5rem;
        background: hsl(220deg 20% 94%);
        outline: none;
        font-weight: bold;
        cursor: pointer;
        box-shadow: inset 1px 0px 1px black;

        &:focus-visible {
          z-index: 1;
        }
      }

      [role="tab"][aria-selected="true"] {
        background: #efefef;
        box-shadow: inset 0 4px 0px orange;
      }

      [role="tab"]:first-of-type {
        border-bottom-left-radius: 0.25rem;
      }
      [role="tab"]:last-of-type {
        border-bottom-right-radius: 0.25rem;
      }

      [role="tabpanel"] {
        flex-grow: 1;
        color: black;
        padding: 1rem;
        border-radius: 0.25rem 0.25rem 0.25rem 0;
        background: white;
        overflow: auto;
        font-family: ui-monospace monospace;
      }
    }
  </style>
</template>;
