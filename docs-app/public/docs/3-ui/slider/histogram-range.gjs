import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { Shadowed,Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const min = 0;
const max = 1000;

const bins = [
  { value: 0, height: 20 },
  { value: 50, height: 35 },
  { value: 100, height: 30 },
  { value: 150, height: 55 },
  { value: 200, height: 70 },
  { value: 250, height: 62 },
  { value: 300, height: 80 },
  { value: 350, height: 60 },
  { value: 400, height: 45 },
  { value: 450, height: 50 },
  { value: 500, height: 75 },
  { value: 550, height: 68 },
  { value: 600, height: 58 },
  { value: 650, height: 48 },
  { value: 700, height: 40 },
  { value: 750, height: 52 },
  { value: 800, height: 65 },
  { value: 850, height: 42 },
  { value: 900, height: 28 },
  { value: 950, height: 18 },
  { value: 1000, height: 12 },
];

const range = cell([250, 750]);

const isInRange = (bin) => {
  const lo = range.current[0];
  const hi = range.current[1];

  return bin.value >= lo && bin.value <= hi;
};

export const HistogramRangeDemo = <template>
  <Shadowed>
    <div class="price-mini">
      <div class="hist-mini" aria-hidden="true">
        {{#each bins as |bin|}}
          <div class="bar-wrap">
            <div
              class="bar {{if (isInRange bin) 'active'}}"
              style={{htmlSafe (concat "height: " bin.height "%;" )}}
              title="{{bin.value}}"
            />
          </div>
        {{/each}}
      </div>

      <Slider @value={{range.current}} @onValueChange={{range.set}} @min={{min}} @max={{max}} @step={{10}} as |s|>
        <s.Track>
          <s.Range />

          {{#each s.thumbs as |thumb|}}
            <s.Thumb
              @value={{thumb.inputValue}}
              @index={{thumb.index}}
              class="thumb-input {{if thumb.active 'is-active'}}"
              aria-label="Price"
            />
            <div
              class="thumb {{if thumb.active 'is-active'}}"
              style={{htmlSafe (concat "left: " thumb.percent "%;" )}}
              aria-hidden="true"
            />
          {{/each}}
        </s.Track>
      </Slider>

      <div class="meta">Selected: {{range.current}}</div>
    </div>

    <SliderDemoStyles />

    <style>
      .price-mini {
        width: 100%;
      }

      .hist-mini {
        display: flex;
        gap: 2px;
        height: 56px;
        align-items: flex-end;
        background: #fafafa;
        border-radius: 6px;
        padding: 6px;
        margin-bottom: 0.5rem;
      }

      .hist-mini .bar-wrap {
        flex: 1;
        height: 100%;
        display: flex;
        align-items: flex-end;
      }

      .hist-mini .bar {
        width: 100%;
        background: #cfd8e3;
        border-radius: 4px 4px 0 0;
      }

      .hist-mini .bar.active {
        background: #1a73e8;
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
