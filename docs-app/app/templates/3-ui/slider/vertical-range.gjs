import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { Shadowed, Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const range = cell([30, 70]);

export const VerticalRangeDemo = <template>
  <Shadowed>
    <div class="v-row">
      <Slider @value={{range.current}} @onValueChange={{range.set}} @orientation="vertical" as |s|>
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
              style={{htmlSafe (concat "bottom: " thumb.percent "%;")}}
              aria-hidden="true"
            />
            <output
              class="tooltip tooltip--vertical"
              style={{htmlSafe (concat "bottom: " thumb.percent "%;")}}
            >
              {{thumb.value}}
            </output>
          {{/each}}
        </s.Track>
      </Slider>
    </div>

    <div class="meta">Range: {{range.current}}</div>

    <SliderDemoStyles />

    <style>
      .v-row {
        display: flex;
        align-items: center;
        justify-content: center;
        min-height: 170px;
      }

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
