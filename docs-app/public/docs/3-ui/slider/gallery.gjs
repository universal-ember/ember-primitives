import { BasicDemo } from './basic.gjs';
import { DisabledDemo } from './disabled.gjs';
import { EqualizerDemo } from './equalizer.gjs';
import { HistogramRangeDemo } from './histogram-range.gjs';
import { MultiThumbDemo } from './multi.gjs';
import { RangeDemo } from './range.gjs';
import { TicksDemo } from './ticks.gjs';
import { VerticalDemo } from './vertical.gjs';
import { VerticalRangeDemo } from './vertical-range.gjs';

export const Gallery = <template>
  <div class="slider-gallery">
    <div class="gallery">
      <div class="card">
        <div class="card-title">Basic</div>
        <BasicDemo />
      </div>

      <div class="card">
        <div class="card-title">Range</div>
        <RangeDemo />
      </div>

      <div class="card">
        <div class="card-title">Ticks (Discrete)</div>
        <TicksDemo />
      </div>

      <div class="card">
        <div class="card-title">Multiple thumbs</div>
        <MultiThumbDemo />
      </div>

      <div class="card">
        <div class="card-title">Disabled</div>
        <DisabledDemo />
      </div>

      <div class="card">
        <div class="card-title">Histogram + Range</div>
        <HistogramRangeDemo />
      </div>

      <div class="card">
        <div class="card-title">Vertical</div>
        <VerticalDemo />
      </div>

      <div class="card">
        <div class="card-title">Vertical range</div>
        <VerticalRangeDemo />
      </div>

      <div class="card">
        <div class="card-title">Equalizer</div>
        <EqualizerDemo />
      </div>

    </div>

    <style>
      /* https://caniuse.com/css-cascade-scope */
      @scope (.slider-gallery) {
        .gallery {
          display: flex;
          flex-wrap: wrap;
          gap: 1rem;
          justify-content: center;
          margin: 1rem auto 2rem;
        }

        .card {
          display: grid;
          flex: 1 1 260px;
          max-width: 360px;
          padding: 1rem;
          border: 1px solid #eee;
          border-radius: 12px;
          background: white;
        }

        /* 3-up on wider screens */
        @media (min-width: 980px) {
          .card {
            flex-basis: calc(33.333% - 0.75rem);
            max-width: 380px;
          }
        }

        .card-title {
          font-weight: 600;
          color: #111;
          font-size: 0.95rem;
          margin-bottom: 0.75rem;
        }
      }
    </style>
  </div>
</template>;
