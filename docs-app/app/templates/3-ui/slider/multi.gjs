import { tracked } from '@glimmer/tracking';

import { Slider } from 'ember-primitives';

import { SliderDemoStyles } from './demo-styles.gjs';

const values = tracked([25, 50, 75]);

export const MultiThumbDemo = <template>
  <div class="slider-demo">
    <Slider @value={{values.value}} @onValueChange={{values.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value">
            <output class="tooltip">{{thumb.value}}%</output>
          </s.Thumb>
        {{/each}}
      </s.Track>
    </Slider>

    <div class="meta">Values: {{values.value}}</div>

    <SliderDemoStyles />
  </div>
</template>;
