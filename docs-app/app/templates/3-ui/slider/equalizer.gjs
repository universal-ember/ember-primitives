import { concat } from '@ember/helper';
import { on } from '@ember/modifier';
import { htmlSafe } from '@ember/template';

import { Shadowed, Slider } from 'ember-primitives';
import { cell } from 'ember-resources';

import { SliderDemoStyles } from './demo-styles.gjs';

const eq60 = cell(2);
const eq250 = cell(1);
const eq1k = cell(-1);
const eq4k = cell(-3);
const eq16k = cell(2);

const bands = [
  { label: '60', value: eq60 },
  { label: '250', value: eq250 },
  { label: '1k', value: eq1k },
  { label: '4k', value: eq4k },
  { label: '16k', value: eq16k },
];

const draggingLabel = cell(null);

const startDrag = (label) => () => draggingLabel.set(label);
const endDrag = () => draggingLabel.set(null);
const isDragging = (label) => draggingLabel.current === label;

export const EqualizerDemo = <template>
  <Shadowed>
    <div class="eq-mini" role="group" aria-label="Equalizer">
      {{#each bands as |band|}}
        <div class="eq-band">
          <Slider
            style="--slider-v-height: 120px;"
            @value={{band.value.current}}
            @onValueChange={{band.value.set}}
            @min={{-5}}
            @max={{5}}
            @orientation="vertical"
            as |s|
          >
            <s.Track>
              <s.Range />

              {{#each s.thumbs as |thumb|}}
                <s.Thumb
                  @value={{thumb.inputValue}}
                  @index={{thumb.index}}
                  class="thumb-input {{if thumb.active 'is-active'}}"
                  aria-label={{band.label}}
                  {{on "pointerup" (startDrag band.label)}}
                  {{on "gotpointercapture" (startDrag band.label)}}
                  {{on "input" (startDrag band.label)}}
                  {{on "pointerup" endDrag}}
                  {{on "pointercancel" endDrag}}
                  {{on "lostpointercapture" endDrag}}
                  {{on "change" endDrag}}
                  {{on "blur" endDrag}}
                />
                <div
                  class="thumb {{if thumb.active 'is-active'}}"
                  style={{htmlSafe (concat "bottom: " thumb.percent "%;")}}
                  aria-hidden="true"
                />
                {{#if (isDragging band.label)}}
                  <output
                    class="tooltip tooltip--vertical"
                    style={{htmlSafe (concat "bottom: " thumb.percent "%;")}}
                  >
                    {{thumb.value}}
                  </output>
                {{/if}}
              {{/each}}
            </s.Track>
          </Slider>

          <div class="eq-label" aria-hidden="true">{{band.label}}</div>
        </div>
      {{/each}}
    </div>

    <SliderDemoStyles />

    <style>
      .eq-mini {
        display: flex;
        justify-content: center;
        gap: 0.75rem;
        padding: 0.25rem 0;
      }

      .eq-band {
        display: grid;
        justify-items: center;
        gap: 0.25rem;
      }

      .eq-label {
        font-size: 0.7rem;
        color: #333;
        user-select: none;
      }
    </style>
  </Shadowed>
</template>;
