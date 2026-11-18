import { tracked } from '@glimmer/tracking';

import { Slider } from 'ember-primitives';

import { SliderDemoStyles } from './demo-styles.gjs';

const range = tracked([25, 75]);

export const RangeDemo = <template>
  <div class="slider-demo">
    <Slider @value={{range.value}} @onValueChange={{range.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value">
            <output class="tooltip">{{thumb.value}}</output>
          </s.Thumb>
        {{/each}}
      </s.Track>
    </Slider>

    <div class="meta">Range: {{range.value}}</div>

    <SliderDemoStyles />
  </div>
</template>;
