import { tracked } from '@glimmer/tracking';

import { Slider } from 'ember-primitives';

import { SliderDemoStyles } from './demo-styles.gjs';

const value = tracked(50);

export const BasicDemo = <template>
  <div class="slider-demo">
    {{! Without a block, the Slider renders its track, range, and thumb(s) for you }}
    <Slider @value={{value.value}} @onValueChange={{value.set}} />

    <div class="meta">Value: {{value.value}}</div>

    <SliderDemoStyles />
  </div>
</template>;
