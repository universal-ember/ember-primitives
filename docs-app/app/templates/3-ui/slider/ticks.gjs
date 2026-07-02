import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { Shadowed, Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const tickValues = [0, 10, 20, 30, 40, 50];
const value = cell(20);
const percentAt = (index) => (index / (tickValues.length - 1)) * 100;

export const TicksDemo = <template>
  <Shadowed>
    <Slider @value={{value.current}} @step={{tickValues}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb @thumb={{thumb}} aria-label="Value" />
        {{/each}}
      </s.Track>
    </Slider>

    <div class="ticks" aria-hidden="true">
      {{#each tickValues as |tick idx|}}
        <span class="tick" style={{htmlSafe (concat "left: " (percentAt idx) "%;")}}>{{tick}}</span>
      {{/each}}
    </div>

    <div class="meta">Value: {{value.current}}</div>

    <SliderDemoStyles />

    <style>
      .ticks {
        position: relative;
        margin-top: 0.25rem;
        height: 18px;
      }

      .tick {
        position: absolute;
        transform: translateX(-50%);
        font-size: 0.75rem;
        color: #444;
        user-select: none;
      }
    </style>
  </Shadowed>
</template>;
