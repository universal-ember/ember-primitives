import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const range = cell([25, 75]);

export const RangeDemo = <template>
  <div class="slider-demo">
    <Slider @value={{range.current}} @onValueChange={{range.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value">
            <output class="tooltip">{{thumb.value}}</output>
          </s.Thumb>
        {{/each}}
      </s.Track>
    </Slider>

    <div class="meta">Range: {{range.current}}</div>

    <SliderDemoStyles />
  </div>
</template>;
