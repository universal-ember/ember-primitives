import { tracked } from '@glimmer/tracking';

import { Slider } from 'ember-primitives';

import { SliderDemoStyles } from './demo-styles.gjs';

const range = tracked([30, 70]);

export const VerticalRangeDemo = <template>
  <div class="slider-demo">
    <div class="v-row">
      <Slider @value={{range.value}} @onValueChange={{range.set}} @orientation="vertical" as |s|>
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

    <div class="meta">Range: {{range.value}}</div>

    <SliderDemoStyles />

    <style>
      @scope {
        .v-row {
          display: flex;
          align-items: center;
          justify-content: center;
          min-height: 170px;
        }
      }
    </style>
  </div>
</template>;
