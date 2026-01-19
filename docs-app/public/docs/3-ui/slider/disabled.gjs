import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';
import { Slider, Shadowed } from 'ember-primitives';

import { SliderDemoStyles } from './demo-styles.gjs';

export const DisabledDemo = <template>
  <Shadowed>
    <Slider @value={{60}} @disabled={{true}} as |s|>
      <s.Track>
        <s.Range />

        {{#each s.thumbs as |thumb|}}
          <s.Thumb
            @value={{thumb.inputValue}}
            @index={{thumb.index}}
            class="thumb-input"
            aria-label="Value"
          />
          <div
            class="thumb is-disabled"
            style={{htmlSafe (concat "left: " thumb.percent "%;" )}}
            aria-hidden="true"
          />
        {{/each}}
      </s.Track>
    </Slider>

    <div class="meta">Value: 60</div>

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
