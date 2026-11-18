export const vertexSource = /* glsl */ `
attribute vec2 a_position;
varying vec2 v_uv;

void main() {
  v_uv = a_position * 0.5 + 0.5;
  gl_Position = vec4(a_position, 0.0, 1.0);
}
`;

/**
 * Beam positions, sizes and colours are measured from the home page design,
 * which is 1460px wide with a 600px tall hero. The shader works in those
 * design pixels and maps them onto the canvas.
 */
export const fragmentSource = /* glsl */ `
precision highp float;

varying vec2 v_uv;
uniform vec2 u_size;
// Seconds since the animation started.
uniform float u_time;
// 1.0 animates the beams. 0.0 draws the still image from the design.
uniform float u_motion;
// Pointer position relative to the canvas, with y pointing down.
// 0.0 to 1.0 is inside the canvas. The pointer can be outside it, anywhere on the page.
uniform vec2 u_pointer;
// 1.0 while the pointer is over the page, easing to 0.0 when it leaves the window.
uniform float u_pointerStrength;
// How stirred up the water is, from 0.0 (calm) to 1.0. Pointer movement raises it
// and it settles back to calm when the pointer stops.
uniform float u_disturbance;
// Grows only while the water is disturbed, faster the more disturbed it is.
// The extra movement is timed by this, so it slows to a stop as the water settles.
uniform float u_disturbancePhase;

const vec3 BASE = vec3(14.0, 15.0, 18.0) / 255.0;
const float DESIGN_WIDTH = 1460.0;
const float DESIGN_HEIGHT = 600.0;
// Below this canvas width the beams stop shrinking and the sides are cropped.
const float MIN_SCALED_WIDTH = 900.0;
// Every beam points away from this one point above the hero, so beams lean
// further the further they are from its x position.
const vec2 ORIGIN = vec2(667.0, -585.0);
// How much brighter the rays passing near the pointer get. 0.6 is 60% brighter.
const float POINTER_GLOW = 0.6;
// How much light is left at the left and right edges of the canvas. 1.0 is no dimming.
const float EDGE_LIGHT = 0.25;
// How far fully disturbed water bends a beam sideways, as a share of the beam's width.
const float DISTURBANCE_BEND = 0.09;
// How much stronger the streaks inside a beam get in fully disturbed water.
const float DISTURBANCE_STREAKS = 0.35;
// How wide the disturbed area around the pointer is, in design pixels at the top edge.
const float DISTURBANCE_WIDTH = 300.0;
// The share of the disturbance that reaches the whole canvas, however far from the pointer.
const float DISTURBANCE_EVERYWHERE = 0.2;

// How disturbed the water is above the pixel being drawn. Set in main.
float disturbed;
// How many extra beams fade in and out while animating.
const int PASSING_BEAMS = 6;

float hash(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

// Smooth noise between 0.0 and 1.0.
float noise(vec2 p) {
  vec2 i = floor(p);
  vec2 f = fract(p);
  vec2 u = f * f * (3.0 - 2.0 * f);

  return mix(
    mix(hash(i), hash(i + vec2(1.0, 0.0)), u.x),
    mix(hash(i + vec2(0.0, 1.0)), hash(i + vec2(1.0, 1.0)), u.x),
    u.y
  );
}

// Converts a canvas position (0.0 to 1.0, y pointing down) to design pixels.
vec2 toDesign(vec2 uv) {
  vec2 css = uv * u_size;
  float scale = max(u_size.x, MIN_SCALED_WIDTH) / DESIGN_WIDTH;

  return vec2(
    (css.x - 0.5 * u_size.x) / scale + 0.5 * DESIGN_WIDTH,
    max(0.0, css.y * DESIGN_HEIGHT / u_size.y)
  );
}

// Where the ray through a design position crosses the top edge.
float topEdgeX(vec2 p) {
  return ORIGIN.x + (p.x - ORIGIN.x) / (p.y - ORIGIN.y) * -ORIGIN.y;
}

// One beam of light.
// x0 is the centre at the top edge. The angle comes from where x0 is relative to ORIGIN.
// w0 is the width at the top edge and spread changes the width per pixel down.
// The beam fades out around len pixels down. A higher power gives a sharper end.
// A rise above zero fades the beam in over that many pixels from the top.
// The seed gives each beam its own timing.
vec3 beam(
  vec2 p, float x0, float w0, float spread,
  vec3 color, float len, float power, float rise, float seed
) {
  float time = u_time * u_motion;

  // Slow sway, as if the water surface above is moving.
  x0 += u_motion * 22.0 * sin(time * 0.31 + seed * 5.0);

  // Sideways movement of the beam centre per pixel down.
  float slope = (x0 - ORIGIN.x) / -ORIGIN.y;

  slope += u_motion * (0.06 * sin(time * 0.23 + seed * 3.1) + 0.03 * sin(time * 0.41 + seed * 1.7));

  float width = max(4.0, w0 + spread * p.y);
  float t = (p.x - (x0 + slope * p.y)) / width;

  // Ripple that bends the beam slightly along its length.
  t += u_motion * 0.12 * sin(p.y * 0.012 - time * 1.3 + seed * 4.0);

  // Disturbed water shakes the beam along its length. Each beam shakes on its own timing.
  float stir = u_disturbancePhase;

  t += disturbed * DISTURBANCE_BEND * (
    sin(p.y * 0.007 - stir * 2.5 + seed * 4.0) + 0.35 * sin(p.y * 0.015 + stir * 3.5 + seed * 9.0)
  );

  float light = exp(-t * t) * exp(-pow(p.y / len, power));

  // Streaks that run along the beam and drift across it, like light split by waves.
  // Disturbed water makes them stronger and makes them change faster.
  float wide = noise(vec2(t * 1.7 + seed * 17.0 + time * 0.15, time * 0.5 + stir * 0.8 + seed));
  float fine = noise(vec2(t * 3.6 - seed * 9.0 - time * 0.25, time * 0.9 + stir * 1.3 + seed * 3.0));
  float streaks = (0.9 * (wide - 0.5) + 0.4 * (fine - 0.5)) * (1.0 + DISTURBANCE_STREAKS * disturbed);
  float pulse = 0.22 * sin(time * 0.6 + seed * 2.3) + 0.12 * sin(time * 0.37 + seed * 6.1);

  light *= max(0.0, 1.0 + u_motion * (streaks + pulse));

  if (rise > 0.0) {
    float r = p.y / rise;
    light *= 1.0 - exp(-r * r);
  }

  return color / 255.0 * light;
}

// An extra beam that fades in at a random place, fades out, then moves somewhere new.
// These only show while animating, so the still image keeps matching the design.
vec3 passingBeam(vec2 p, float index) {
  float period = 8.0 + 7.0 * hash(vec2(index, 1.0));
  float clock = u_time / period + hash(vec2(index, 2.0));
  // The beam is invisible when the cycle changes, which hides the jump to a new place.
  float fade = sin(fract(clock) * 3.14159265);
  vec2 id = vec2(index, floor(clock));

  float x0 = mix(120.0, 1340.0, hash(id + 0.1));
  float width = mix(30.0, 70.0, hash(id + 0.3));
  float len = mix(160.0, 400.0, hash(id + 0.4));
  float tint = hash(id + 0.5);
  vec3 color = vec3(6.0, 20.0, 58.0);

  if (tint > 0.8) {
    color = vec3(20.0, 7.0, 6.0);
  } else if (tint > 0.55) {
    color = vec3(16.0, 13.0, 38.0);
  }

  return beam(p, x0, width, 0.02, color, len, 2.0, 0.0, index + 20.0) * fade * fade * u_motion;
}

// Many faint thin rays that fill the space between the main beams.
// They follow the same fan from ORIGIN and drift sideways over time.
vec3 fillRays(vec2 p) {
  float time = u_time * u_motion;
  float stir = u_disturbancePhase;
  float x0 = topEdgeX(p);

  // Disturbed water shakes these rays the same way it shakes the beams.
  x0 += disturbed * 5.0 * sin(p.y * 0.007 - stir * 2.5 + x0 * 0.01);

  float wide = noise(vec2(x0 / 48.0 + time * 0.1, time * 0.22 + stir * 0.6));
  float fine = noise(vec2(x0 / 19.0 - time * 0.17, time * 0.35 + stir * 1.0 + 7.0));
  // Never fully dark, so the gaps between beams keep some light.
  float rays = 0.35 + 0.65 * (0.6 * wide + 0.4 * fine);

  float across = (x0 - 760.0) / 430.0;
  float reach = exp(-across * across) * exp(-pow(p.y / 340.0, 2.5));
  vec3 color = mix(vec3(4.0, 12.0, 34.0), vec3(13.0, 9.0, 28.0), noise(vec2(x0 / 210.0, 3.0)));

  return color / 255.0 * rays * reach;
}

void main() {
  vec2 p = toDesign(vec2(v_uv.x, 1.0 - v_uv.y));
  vec2 pointer = toDesign(u_pointer);

  // Pointer movement disturbs the water most above the rays that point at the pointer.
  float acrossPointer = (topEdgeX(p) - topEdgeX(pointer)) / DISTURBANCE_WIDTH;

  disturbed = u_disturbance * u_motion
    * mix(DISTURBANCE_EVERYWHERE, 1.0, exp(-acrossPointer * acrossPointer));

  vec3 light = vec3(0.0);

  // Wide blue glow behind the beams.
  light += beam(p, 752.0, 353.0, -0.05, vec3(0.0, 17.1, 78.9), 150.0, 2.5, 0.0, 1.0);
  // Far left blue beam.
  light += beam(p, 222.5, 59.5, 0.016, vec3(6.2, 19.1, 55.1), 158.0, 1.46, 0.0, 2.0);
  // Left indigo beam and the rose light below it.
  light += beam(p, 471.0, 66.1, 0.02, vec3(16.3, 11.0, 25.2), 145.0, 2.83, 0.0, 3.0);
  light += beam(p, 434.6, 50.8, 0.043, vec3(15.8, 6.0, 5.8), 288.0, 5.15, 108.6, 4.0);
  // Centre beam, blue at the top and rose behind the logo.
  light += beam(p, 666.3, 53.5, 0.008, vec3(8.2, 16.9, 42.7), 414.0, 4.35, 0.0, 5.0);
  light += beam(p, 666.3, 61.9, 0.026, vec3(24.9, 6.0, 0.0), 473.0, 6.0, 0.0, 6.0);
  // Bright blue beam right of centre, with a pale core at the top.
  light += beam(p, 884.8, 63.3, 0.048, vec3(5.0, 18.3, 46.1), 382.0, 4.25, 0.0, 7.0);
  light += beam(p, 885.8, 24.9, -0.026, vec3(21.6, 20.3, 17.9), 131.0, 1.15, 0.0, 8.0);
  light += beam(p, 913.7, 67.6, -0.033, vec3(2.7, 5.2, 24.1), 248.0, 2.44, 140.7, 9.0);
  // Dim warm beams on the right.
  light += beam(p, 1092.6, 81.2, -0.045, vec3(10.4, 5.3, 6.5), 306.0, 4.12, 0.0, 10.0);
  light += beam(p, 1333.0, 78.9, 0.082, vec3(8.5, 2.8, 0.0), 115.0, 1.7, 0.0, 11.0);

  light += fillRays(p);

  for (int i = 0; i < PASSING_BEAMS; i++) {
    light += passingBeam(p, float(i));
  }

  // Brighten the rays that point at the pointer, along their whole length.
  // This also works when the pointer is below the canvas, further down the page.
  float acrossGlow = (topEdgeX(p) - topEdgeX(pointer)) / 170.0;

  light *= 1.0 + POINTER_GLOW * u_pointerStrength * exp(-acrossGlow * acrossGlow);

  // Dim the light towards the left and right edges so the central beams stand out.
  float fromCentre = abs(v_uv.x - 0.5) * 2.0;

  light *= mix(1.0, EDGE_LIGHT, smoothstep(0.25, 1.0, fromCentre));

  // Fine grain. It also hides colour banding in the dark gradients.
  float brightness = max(light.r, max(light.g, light.b));
  float grain = (hash(gl_FragCoord.xy) - 0.5) * (3.0 / 255.0) * smoothstep(0.0, 0.06, brightness);

  gl_FragColor = vec4(BASE + light + grain, 1.0);
}
`;
