import { Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const value = cell(50);

export const BasicDemo = <template>
  <div class="slider-demo">
    {{! Without a block, the Slider renders its track, range, and thumb(s) for you }}
    <Slider @value={{value.current}} @onValueChange={{value.set}} />

    <div class="meta">Value: {{value.current}}</div>

    <SliderDemoStyles />
  </div>
</template>;
