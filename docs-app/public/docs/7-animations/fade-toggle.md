# Fade + Slide

A simple presence animation for showing and hiding UI without overwhelming the layout.

## Example

<div class="featured-demo">

```gjs live preview no-shadow
import { cell } from 'ember-resources';
import { on } from '@ember/modifier';

const isOpen = cell(true);

function toggle() {
  isOpen.set(!isOpen.current);
}

<template>
  <section class="animation-shell">
    <header class="animation-row">
      <div>
        <p class="eyebrow">Presence animation</p>
        <h3 class="title">Fade + slide</h3>
        <p class="muted">Great for banners, drawers, or inline explanations.</p>
      </div>

      <button
        type="button"
        class="action"
        aria-pressed={{isOpen.current}}
        {{on 'click' toggle}}
      >
        {{if isOpen.current "Hide" "Show"}}
      </button>
    </header>

    <article class="panel" data-state={{if isOpen.current "open" "closed"}}>
      <p class="panel-title">Keep it lightweight</p>
      <p class="panel-body">
        Use short durations and small offsets to keep the motion crisp. This pattern
        works well for toast-like banners or inline callouts.
      </p>
      <div class="chips">
        <span>180ms</span>
        <span>ease-out</span>
        <span>prefers-reduced-motion aware</span>
      </div>
    </article>
  </section>

  <style>
    .animation-shell {
      display: grid;
      gap: 1rem;
      max-width: 640px;
      border: 1px solid #e2e8f0;
      border-radius: 16px;
      padding: 1.25rem;
      background: linear-gradient(120deg, #f8fafc, #eef2ff);
      color: #0f172a;
      box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
    }

    .animation-row {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      gap: 1rem;
      flex-wrap: wrap;
    }

    .eyebrow {
      margin: 0;
      letter-spacing: 0.08em;
      text-transform: uppercase;
      font-size: 0.75rem;
      color: #475569;
      font-weight: 600;
    }

    .title {
      margin: 0.1rem 0 0.25rem;
      font-size: 1.25rem;
    }

    .muted {
      margin: 0;
      color: #475569;
      max-width: 34ch;
      line-height: 1.5;
    }

    .action {
      padding: 0.65rem 1rem;
      border-radius: 12px;
      border: 1px solid #cbd5e1;
      background: #0f172a;
      color: #f8fafc;
      font-weight: 600;
      cursor: pointer;
      transition: transform 120ms ease, box-shadow 120ms ease, background 120ms ease;
    }

    .action:hover {
      transform: translateY(-1px);
      box-shadow: 0 10px 16px rgba(15, 23, 42, 0.16);
      background: #111827;
    }

    .action:active {
      transform: translateY(0);
      box-shadow: 0 6px 12px rgba(15, 23, 42, 0.14);
    }

    .panel {
      border: 1px solid #cbd5e1;
      background: #ffffff;
      border-radius: 14px;
      padding: 1rem 1.1rem;
      display: grid;
      gap: 0.5rem;
      box-shadow: 0 14px 40px rgba(15, 23, 42, 0.08);
      transition: opacity 160ms ease, transform 160ms ease, padding 160ms ease,
        margin-top 160ms ease, box-shadow 160ms ease;
    }

    .panel[data-state='closed'] {
      opacity: 0;
      transform: translateY(8px);
      pointer-events: none;
      padding-top: 0;
      padding-bottom: 0;
      margin-top: -0.5rem;
      box-shadow: none;
    }

    .panel-title {
      margin: 0;
      font-weight: 700;
      font-size: 1rem;
    }

    .panel-body {
      margin: 0;
      color: #475569;
      line-height: 1.6;
    }

    .chips {
      display: flex;
      flex-wrap: wrap;
      gap: 0.5rem;
    }

    .chips span {
      display: inline-flex;
      align-items: center;
      gap: 0.35rem;
      padding: 0.35rem 0.65rem;
      border-radius: 999px;
      background: #eef2ff;
      color: #4338ca;
      font-weight: 600;
      font-size: 0.85rem;
    }

    @media (prefers-reduced-motion: reduce) {
      .panel,
      .action {
        transition: none;
      }

      .panel[data-state='closed'] {
        transform: none;
      }
    }
  </style>
</template>
```

</div>

## Why it works

- Uses a small translate offset so the animation feels responsive instead of floaty.
- Hides pointer events while closed so the focus ring never lands on a hidden element.
- Respects `prefers-reduced-motion` by removing transitions for sensitive users.
