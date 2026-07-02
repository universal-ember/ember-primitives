import { Shadowed, Slider } from 'ember-primitives';

import { SliderDemoStyles } from './demo-styles.gjs';

export const DisabledDemo = <template>
  <Shadowed>
    <Slider @value={{60}} @disabled={{true}} />

    <div class="meta">Value: 60</div>

    <SliderDemoStyles />
  </Shadowed>
</template>;
