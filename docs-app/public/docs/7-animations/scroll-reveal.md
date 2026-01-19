# Scroll Reveal

Reveal content as it enters the viewport, pairing lazy rendering with a light entrance animation.

## Example

<div class="featured-demo">

```gjs live preview no-shadow
import { InViewport } from 'ember-primitives/viewport';

const cards = [
  {
    title: 'Capture intent',
    copy: 'Render expensive bits only once they are on-screen.',
  },
  {
    title: 'Guide attention',
    copy: 'Use a small translate and fade to lead the eye without jarring jumps.',
  },
  {
    title: 'Stay polite',
    copy: 'Respect reduced-motion users and avoid long bounces or overshoot.',
  },
  {
    title: 'Chain sections',
    copy: 'Stack multiple reveals to create a guided scroll story.',
  },
];

function delay(index: number) {
  return `--i: ${index};`;
}

<template>
  <div class="reveal-frame">
    <p class="muted">Scroll inside the frame to trigger reveals.</p>

    <div class="reveal-track" tabindex="0">
      <div class="spacer">Start scrolling</div>

      {{#each cards as |card index|}}
        <InViewport @mode="replace">
          <article class="reveal-card" style="{{(delay index)}}">
            <p class="eyebrow">Scroll reveal</p>
            <h3 class="card-title">{{card.title}}</h3>
            <p class="card-copy">{{card.copy}}</p>
          </article>
        </InViewport>
      {{/each}}

      <div class="spacer">The end</div>
    </div>
  </div>

  <style>
    .reveal-frame {
      border: 1px solid #e2e8f0;
      border-radius: 18px;
      padding: 1.1rem;
      max-width: 720px;
      background: linear-gradient(140deg, #f8fafc, #eef2ff);
      color: #0f172a;
      box-shadow: 0 14px 40px rgba(15, 23, 42, 0.08);
    }

    .muted {
      margin: 0 0 0.75rem;
      color: #475569;
      line-height: 1.5;
    }

    .reveal-track {
      border: 1px dashed #cbd5e1;
      border-radius: 14px;
      padding: 1rem;
      height: 320px;
      overflow: auto;
      display: grid;
      gap: 1rem;
      background: #ffffff;
    }

    .spacer {
      display: grid;
      place-items: center;
      color: #94a3b8;
      font-weight: 600;
      height: 120px;
      border-radius: 12px;
      background: repeating-linear-gradient(
        45deg,
        #f8fafc,
        #f8fafc 14px,
        #eef2ff 14px,
        #eef2ff 28px
      );
    }

    .reveal-card {
      border: 1px solid #e2e8f0;
      border-radius: 14px;
      padding: 1rem 1.1rem;
      background: #0b1224;
      color: #e2e8f0;
      box-shadow: 0 12px 34px rgba(15, 23, 42, 0.3);
      animation: lift-in 260ms ease both;
      animation-delay: calc(var(--i) * 60ms);
    }

    .eyebrow {
      margin: 0;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      font-size: 0.75rem;
      color: #a5b4fc;
      font-weight: 600;
    }

    .card-title {
      margin: 0.2rem 0 0.35rem;
      font-size: 1.25rem;
      color: #e2e8f0;
    }

    .card-copy {
      margin: 0;
      color: #cbd5e1;
      line-height: 1.6;
    }

    @keyframes lift-in {
      from {
        opacity: 0;
        transform: translateY(14px) scale(0.99);
      }

      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }

    @media (prefers-reduced-motion: reduce) {
      .reveal-card {
        animation: none;
      }
    }
  </style>
</template>
```

</div>

## Notes

- `InViewport` renders each card only when it is near the scroll frame, so expensive content can stay idle until needed.
- The animation uses a small translate and scale to keep the entrance grounded and fast (260ms).
- Reduced-motion users see the content instantly with no animation.
