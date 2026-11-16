import { modifier } from 'ember-modifier';

import { createLightRays } from './light-rays/renderer.ts';

import type { TOC } from '@ember/component/template-only';

const drawLightRays = modifier((canvas: HTMLCanvasElement) => {
  const renderer = createLightRays(canvas);

  if (!renderer) return;

  return () => renderer.destroy();
});

/**
 * Beams of light drawn with WebGL.
 * Fills its nearest positioned ancestor and sits behind that ancestor's content.
 */
export const LightRays: TOC<{
  Element: HTMLCanvasElement;
}> = <template>
  <canvas class="light-rays" aria-hidden="true" {{drawLightRays}} ...attributes></canvas>

  <style>
    .light-rays {
      position: absolute;
      inset: 0;
      z-index: 0;
      display: block;
      width: 100%;
      height: 100%;
      pointer-events: none;
    }
  </style>
</template>;
