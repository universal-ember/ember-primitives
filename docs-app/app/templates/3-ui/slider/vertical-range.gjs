import { Shadowed, Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const range = cell([30, 70]);

export const VerticalRangeDemo = <template>
  <Shadowed>
    <div class="v-row">
      <Slider @value={{range.current}} @onValueChange={{range.set}} @orientation="vertical" as |s|>
        <s.Track>
          <s.Range />

          {{#each s.thumbs as |thumb|}}
            <s.Thumb @thumb={{thumb}} aria-label="Value">
              <output class="tooltip tooltip--vertical">{{thumb.value}}</output>
            </s.Thumb>
          {{/each}}
        </s.Track>
      </Slider>
    </div>

    <div class="meta">Range: {{range.current}}</div>

    <SliderDemoStyles />

    <style>
      .v-row {
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 170px;
      }
    </style>
  </Shadowed>
</template>;
