import { createFrameLoop } from './frame-loop.ts';
import { fragmentSource, vertexSource } from './shader.ts';

export interface LightRaysRenderer {
  destroy: () => void;
}

// The image is soft, so one canvas pixel per CSS pixel is enough.
const MAX_PIXEL_RATIO = 1;
// Seconds for the pointer effects to cover most of the distance to the pointer.
const POINTER_EASE_SECONDS = 0.3;
// The pointer has to travel this many CSS pixels to fully disturb calm water.
const DISTURBANCE_DISTANCE = 1400;
// The longest step the animation takes in one frame, in seconds.
// It stops the animation jumping ahead after the tab or the canvas was hidden.
const MAX_FRAME_SECONDS = 0.1;
// Seconds for disturbed water to settle to about a third of its disturbance.
const DISTURBANCE_SETTLE_SECONDS = 1.6;

function compile(gl: WebGLRenderingContext, type: number, source: string): WebGLShader | null {
  const shader = gl.createShader(type);

  if (!shader) return null;

  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.warn(gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);

    return null;
  }

  return shader;
}

function link(gl: WebGLRenderingContext): WebGLProgram | null {
  const vertex = compile(gl, gl.VERTEX_SHADER, vertexSource);
  const fragment = compile(gl, gl.FRAGMENT_SHADER, fragmentSource);
  const program = gl.createProgram();

  if (!vertex || !fragment || !program) return null;

  gl.attachShader(program, vertex);
  gl.attachShader(program, fragment);
  gl.linkProgram(program);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.warn(gl.getProgramInfoLog(program));

    return null;
  }

  return program;
}

/**
 * Draws the light rays into the canvas and keeps the drawing sized to it.
 * Returns null when WebGL is unavailable, so the caller can leave the canvas empty.
 *
 * People who ask their system for reduced motion get one still image with no pointer effects.
 */
export function createLightRays(canvas: HTMLCanvasElement): LightRaysRenderer | null {
  const gl = canvas.getContext('webgl', { antialias: false, alpha: false });

  if (!gl) return null;

  const program = link(gl);

  if (!program) return null;

  gl.useProgram(program);

  // One triangle that covers the whole canvas.
  const buffer = gl.createBuffer();

  gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);

  const position = gl.getAttribLocation(program, 'a_position');

  gl.enableVertexAttribArray(position);
  gl.vertexAttribPointer(position, 2, gl.FLOAT, false, 0, 0);

  const uniforms = {
    size: gl.getUniformLocation(program, 'u_size'),
    time: gl.getUniformLocation(program, 'u_time'),
    motion: gl.getUniformLocation(program, 'u_motion'),
    pointer: gl.getUniformLocation(program, 'u_pointer'),
    pointerStrength: gl.getUniformLocation(program, 'u_pointerStrength'),
    disturbance: gl.getUniformLocation(program, 'u_disturbance'),
    disturbancePhase: gl.getUniformLocation(program, 'u_disturbancePhase'),
  };

  let lastDrawAt = performance.now();
  let isContextLost = false;
  // Seconds the animation has run for. It does not advance while paused.
  let time = 0;

  // The target is where the pointer is. The current values ease toward it each frame.
  const pointer = { x: 0.5, y: 0.5, strength: 0 };
  const pointerTarget = { x: 0.5, y: 0.5, strength: 0 };
  // Pointer movement adds to the target. The current value eases toward it each frame.
  const water = { disturbance: 0, target: 0, phase: 0 };
  let lastPointer: { x: number; y: number } | null = null;

  const onPointerMove = (event: PointerEvent) => {
    // Touch has no hover, so it would leave the effect stuck where the finger lifted.
    if (event.pointerType === 'touch') return;

    const rect = canvas.getBoundingClientRect();

    if (rect.width === 0 || rect.height === 0) return;

    // The pointer counts anywhere on the page, so these can be outside 0 to 1.
    pointerTarget.x = (event.clientX - rect.left) / rect.width;
    pointerTarget.y = (event.clientY - rect.top) / rect.height;
    pointerTarget.strength = 1;

    // Moving the pointer stirs the water. The further it travels, the more disturbed it gets.
    if (lastPointer) {
      const travelled = Math.hypot(event.clientX - lastPointer.x, event.clientY - lastPointer.y);

      water.target = Math.min(1, water.target + travelled / DISTURBANCE_DISTANCE);
    }

    lastPointer = { x: event.clientX, y: event.clientY };
  };

  const onPointerLeave = () => {
    pointerTarget.strength = 0;
  };

  const draw = (isStill: boolean) => {
    const width = canvas.clientWidth;
    const height = canvas.clientHeight;

    if (isContextLost || width === 0 || height === 0) return;

    const ratio = Math.min(window.devicePixelRatio || 1, MAX_PIXEL_RATIO);
    const pixelWidth = Math.round(width * ratio);
    const pixelHeight = Math.round(height * ratio);

    if (canvas.width !== pixelWidth || canvas.height !== pixelHeight) {
      canvas.width = pixelWidth;
      canvas.height = pixelHeight;
    }

    const now = performance.now();
    const seconds = Math.min((now - lastDrawAt) / 1000, MAX_FRAME_SECONDS);
    const ease = 1 - Math.exp(-seconds / POINTER_EASE_SECONDS);

    lastDrawAt = now;

    if (!isStill) {
      time += seconds;
      pointer.x += (pointerTarget.x - pointer.x) * ease;
      pointer.y += (pointerTarget.y - pointer.y) * ease;
      pointer.strength += (pointerTarget.strength - pointer.strength) * ease;
      water.target *= Math.exp(-seconds / DISTURBANCE_SETTLE_SECONDS);
      water.disturbance += (water.target - water.disturbance) * ease;
      water.phase += seconds * water.disturbance;
    }

    gl.viewport(0, 0, pixelWidth, pixelHeight);
    gl.uniform2f(uniforms.size, width, height);
    gl.uniform1f(uniforms.time, time);
    gl.uniform1f(uniforms.motion, isStill ? 0 : 1);
    gl.uniform2f(uniforms.pointer, pointer.x, pointer.y);
    gl.uniform1f(uniforms.pointerStrength, isStill ? 0 : pointer.strength);
    gl.uniform1f(uniforms.disturbance, isStill ? 0 : water.disturbance);
    gl.uniform1f(uniforms.disturbancePhase, water.phase);
    gl.drawArrays(gl.TRIANGLES, 0, 3);
  };

  const onContextLost = (event: Event) => {
    // The browser took the WebGL context away. Hide the canvas so the plain
    // background colour behind it shows.
    event.preventDefault();
    isContextLost = true;
    canvas.hidden = true;
    frameLoop.destroy();
  };

  canvas.addEventListener('webglcontextlost', onContextLost);
  // The canvas ignores pointer events so it cannot block the content above it.
  window.addEventListener('pointermove', onPointerMove, { passive: true });
  document.documentElement.addEventListener('pointerleave', onPointerLeave);

  const frameLoop = createFrameLoop(canvas, draw);

  return {
    destroy() {
      frameLoop.destroy();
      canvas.removeEventListener('webglcontextlost', onContextLost);
      window.removeEventListener('pointermove', onPointerMove);
      document.documentElement.removeEventListener('pointerleave', onPointerLeave);
      // Give the GPU memory back now instead of waiting for garbage collection.
      gl.getExtension('WEBGL_lose_context')?.loseContext();
    },
  };
}
