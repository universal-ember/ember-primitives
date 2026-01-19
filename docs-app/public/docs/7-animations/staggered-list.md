# Staggered List

A classic cascade animation that makes lists feel intentional while keeping motion subtle.

## Example

<div class="featured-demo">

```gjs live preview no-shadow
import { cell } from 'ember-resources';
import { on } from '@ember/modifier';

const items = cell([
  { title: 'Triage bugs', meta: 'Label, assign, and unblock the team.' },
  { title: 'Write changelog', meta: 'Summarize what actually shipped.' },
  { title: 'Publish docs', meta: 'Keep examples and API notes in sync.' },
  { title: 'Share the link', meta: 'Post a crisp demo and nudge feedback.' },
]);

function addItem() {
  const count = items.current.length + 1;
  items.set([
    ...items.current,
    { title: `New idea ${count}`, meta: 'Fresh list items animate on entry.' },
  ]);
}

function reset() {
  items.set(items.current.slice(0, 4));
}

function delay(index: number) {
  return `--i: ${index};`;
}

<template>
  <section class="animation-shell">
    <header class="animation-row">
      <div>
        <p class="eyebrow">Cascade animation</p>
        <h3 class="title">Staggered list</h3>
        <p class="muted">Animate each item with a small, consistent delay for a polished first impression.</p>
      </div>

      <div class="actions">
        <button type="button" class="action secondary" {{on 'click' reset}}>Reset</button>
        <button type="button" class="action" {{on 'click' addItem}}>Add item</button>
      </div>
    </header>

    <ol class="staggered-list">
      {{#each items.current as |item index|}}
        <li class="staggered-item" style="{{(delay index)}}">
          <div class="dot" aria-hidden="true"></div>
          <div>
            <p class="panel-title">{{item.title}}</p>
            <p class="panel-body">{{item.meta}}</p>
          </div>
        </li>
      {{/each}}
    </ol>
  </section>

  <style>
    .animation-shell {
      display: grid;
      gap: 1.25rem;
      max-width: 720px;
      border: 1px solid #e2e8f0;
      border-radius: 16px;
      padding: 1.35rem;
      background: linear-gradient(140deg, #f8fafc, #e0f2fe);
      color: #0f172a;
      box-shadow: 0 12px 34px rgba(15, 23, 42, 0.08);
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
      max-width: 44ch;
      line-height: 1.5;
    }

    .actions {
      display: flex;
      gap: 0.6rem;
      flex-wrap: wrap;
    }

    .action {
      padding: 0.6rem 0.95rem;
      border-radius: 12px;
      border: 1px solid #cbd5e1;
      background: #0f172a;
      color: #f8fafc;
      font-weight: 600;
      cursor: pointer;
      transition: transform 120ms ease, box-shadow 120ms ease, background 120ms ease;
    }

    .action.secondary {
      background: #ffffff;
      color: #0f172a;
    }

    .action:hover {
      transform: translateY(-1px);
      box-shadow: 0 10px 16px rgba(15, 23, 42, 0.16);
      background: #111827;
    }

    .action.secondary:hover {
      background: #f8fafc;
    }

    .action:active {
      transform: translateY(0);
      box-shadow: 0 6px 12px rgba(15, 23, 42, 0.14);
    }

    .staggered-list {
      margin: 0;
      padding: 0;
      list-style: none;
      display: grid;
      gap: 0.85rem;
    }

    .staggered-item {
      display: grid;
      grid-template-columns: auto 1fr;
      gap: 0.75rem;
      align-items: center;
      padding: 0.85rem 1rem;
      border-radius: 14px;
      background: #ffffff;
      border: 1px solid #e2e8f0;
      box-shadow: 0 10px 26px rgba(15, 23, 42, 0.08);
      animation: fade-up 320ms ease both;
      animation-delay: calc(var(--i) * 70ms);
    }

    .dot {
      width: 12px;
      height: 12px;
      border-radius: 999px;
      background: linear-gradient(135deg, #2563eb, #22d3ee);
      box-shadow: 0 0 0 6px #e0f2fe;
    }

    .panel-title {
      margin: 0;
      font-weight: 700;
      font-size: 1rem;
    }

    .panel-body {
      margin: 0.15rem 0 0;
      color: #475569;
      line-height: 1.5;
    }

    @keyframes fade-up {
      from {
        opacity: 0;
        transform: translateY(10px);
      }

      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    @media (prefers-reduced-motion: reduce) {
      .staggered-item {
        animation: none;
      }
    }
  </style>
</template>
```

</div>

## Tips

- Use consistent delays (here 70ms) so the motion feels intentional instead of random.
- Animations run when new items mount, making it great for streaming data or appended results.
- Remove animations entirely for `prefers-reduced-motion` to avoid motion sickness.
