import { Shadowed, Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const values = cell([25, 50, 75]);

export const MultiThumbDemo = <template>
  <Shadowed>
    <Slider @value={{values.current}} @onValueChange={{values.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value">
            <output class="tooltip">{{thumb.value}}%</output>
          </s.Thumb>
        {{/each}}
      </s.Track>
    </Slider>

    <div class="meta">Values: {{values.current}}</div>

    <SliderDemoStyles />
  </Shadowed>
</template>;
