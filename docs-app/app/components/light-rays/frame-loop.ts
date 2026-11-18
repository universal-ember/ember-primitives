export interface FrameLoop {
  destroy: () => void;
}

/**
 * Calls draw on every animation frame while the element is on screen.
 *
 * People who ask their system for reduced motion get isStill set to true and
 * no repeating frames. Draw is still called once, and again when the element
 * changes size, so the picture stays correct.
 */
export function createFrameLoop(element: Element, draw: (isStill: boolean) => void): FrameLoop {
  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
  let frame: number | null = null;
  let isOnScreen = true;

  const drawOnce = () => draw(reducedMotion.matches);

  const stop = () => {
    if (frame === null) return;

    cancelAnimationFrame(frame);
    frame = null;
  };

  const loop = () => {
    drawOnce();
    frame = requestAnimationFrame(loop);
  };

  // Runs the loop when it should be running and stops it when it should not.
  const update = () => {
    stop();

    if (reducedMotion.matches || !isOnScreen) {
      drawOnce();

      return;
    }

    loop();
  };

  const resizeObserver = new ResizeObserver(drawOnce);
  const intersectionObserver = new IntersectionObserver((entries) => {
    for (const entry of entries) {
      isOnScreen = entry.isIntersecting;
    }

    update();
  });

  resizeObserver.observe(element);
  intersectionObserver.observe(element);
  reducedMotion.addEventListener('change', update);
  update();

  return {
    destroy() {
      stop();
      resizeObserver.disconnect();
      intersectionObserver.disconnect();
      reducedMotion.removeEventListener('change', update);
    },
  };
}
