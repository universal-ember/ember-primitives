import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { Shadowed, Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const value = cell(50);

export const BasicDemo = <template>
  <Shadowed>
    <Slider @value={{value.current}} @onValueChange={{value.set}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb
            @value={{thumb.inputValue}}
            @index={{thumb.index}}
            class="thumb-input {{if thumb.active 'is-active'}}"
            aria-label="Value"
          />
          <div
            class="thumb {{if thumb.active 'is-active'}}"
            style={{htmlSafe (concat "left: " thumb.percent "%;")}}
            aria-hidden="true"
          />
        {{/each}}
      </s.Track>
    </Slider>

    <div class="meta">Value: {{value.current}}</div>

    <SliderDemoStyles />

    <style>
      .meta {
        margin-top: 0.75rem;
        font-variant-numeric: tabular-nums;
        color: #333;
        font-size: 0.9rem;
        text-align: center;
      }
    </style>
  </Shadowed>
</template>;
