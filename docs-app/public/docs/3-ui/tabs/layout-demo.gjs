import { Tabs } from 'ember-primitives/components/tabs';

import { BottomTabs } from './bottom-tabs.gjs';
import { LeftTabs } from './left-tabs.gjs';
import { RightTabs } from './right-tabs.gjs';

export const Demo = <template>
  <Tabs class="left-tabs inline-tabs" as |Tab|>
    <Tab @label="Tabs on Left">
      <LeftTabs />
    </Tab>
    <Tab @label="Tabs on Right">
      <RightTabs />
    </Tab>
    <Tab @label="Tabs on Bottom">
      <BottomTabs />
    </Tab>
  </Tabs>

  <style>
    /* https://caniuse.com/css-cascade-scope */
    @scope {
      .inline-tabs {
        > [role="tablist"] {
          min-width: 100%;

          > [role="tab"] {
            color: black;
            display: inline-block;
            padding: 0.25rem 0.5rem;
            background: hsl(220deg 20% 94%);
            outline: none;
            font-weight: bold;
            cursor: pointer;
            box-shadow: inset 0 -1px 1px black;
          }

          > [role="tab"][aria-selected="true"] {
            background: #efefef;
            box-shadow: inset 0 -4px 0px orange;
          }

          > [role="tab"]:first-of-type {
            border-top-left-radius: 0.25rem;
          }
          > [role="tab"]:last-of-type {
            border-top-right-radius: 0.25rem;
          }
        }

        > .ember-primitives__tabs__tabpanel {
          > [role="tabpanel"] {
            color: black;
            padding: 1rem;
            border-radius: 0 0.25rem 0.25rem;
            background: white;
            width: 100%;
            overflow: auto;
            font-family: ui-monospace monospace;
          }
        }
      }
    }
  </style>
</template>;
