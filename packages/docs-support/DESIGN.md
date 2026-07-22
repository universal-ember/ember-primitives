---
version: alpha
name: docs-support
description: >
  Dark-first documentation theme for Ember primitives and
  Universal Ember documentation apps.
colors:
  # Surfaces
  bg: "#FFFFFF"
  bg-alt: "#F6F6F7"
  bg-elv: "#FFFFFF"
  bg-soft: "#F6F6F7"
  bg-dark: "#1B1B1F"
  bg-alt-dark: "#161618"
  bg-elv-dark: "#202127"
  bg-soft-dark: "#202127"

  # Text
  text-1: "#3C3C43"
  text-2: "#67676C"
  text-3: "#929295"
  text-1-dark: "#DFDFD6"
  text-2-dark: "#98989F"
  text-3-dark: "#6A6A71"

  # Brand indigo
  brand-1: "#3451B2"
  brand-2: "#3A5CCC"
  brand-3: "#5672CD"
  brand-soft: "rgba(100, 108, 255, 0.14)"
  brand-1-dark: "#A8B1FF"
  brand-2-dark: "#5C73E7"
  brand-3-dark: "#3E63DD"
  brand-soft-dark: "rgba(100, 108, 255, 0.16)"

  # Structural
  divider: "#E2E2E3"
  divider-dark: "#2E2E32"
  border: "rgba(60, 60, 67, 0.12)"
  border-dark: "rgba(255, 255, 255, 0.10)"

  # Personality accents
  mark: "#F5C518"
  ember: "#E04E39"
  success: "#30A46C"
  warning: "#9F6A00"
  danger: "#E0575B"

  # Semantic aliases
  primary: "{colors.brand-1-dark}"
  secondary: "{colors.text-2-dark}"
  tertiary: "{colors.mark}"
  neutral: "{colors.bg-dark}"
typography:
  display:
    fontFamily: Inter
    fontSize: 56px
    fontWeight: 700
    lineHeight: 1.1
    letterSpacing: -0.02em
  h1:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: 700
    lineHeight: 1.25
    letterSpacing: -0.02em
  h2:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: 600
    lineHeight: 1.3
    letterSpacing: -0.01em
  h3:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: 600
    lineHeight: 1.4
  body:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.7
  body-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.6
  label:
    fontFamily: Inter
    fontSize: 13px
    fontWeight: 500
    lineHeight: 1.4
  nav:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.5
  code:
    fontFamily: "ui-monospace, Menlo, Monaco, Consolas, Liberation Mono, Courier New, monospace"
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.6
  kbd:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1
rounded:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 20px
  pill: 9999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  2xl: 48px
  3xl: 64px
  gutter: 24px
  margin: 32px
  sidebar: 272px
  content-max: 780px
  page-max: 1280px
  nav-height: 64px
components:
  button-primary:
    backgroundColor: "{colors.brand-3-dark}"
    textColor: "#FFFFFF"
    rounded: "{rounded.pill}"
    typography: "{typography.nav}"
  button-secondary:
    backgroundColor: "{colors.bg-soft-dark}"
    textColor: "{colors.text-1-dark}"
    borderColor: "{colors.border-dark}"
    rounded: "{rounded.pill}"
    typography: "{typography.nav}"
  feature-card:
    backgroundColor: "{colors.bg-soft-dark}"
    borderColor: "{colors.border-dark}"
    rounded: "{rounded.md}"
  callout:
    backgroundColor: "{colors.brand-soft-dark}"
    borderColor: "{colors.brand-2-dark}"
    rounded: "{rounded.sm}"
  sidebar-active:
    textColor: "{colors.brand-1-dark}"
    borderColor: "{colors.brand-1-dark}"
  focus-ring:
    outlineColor: "{colors.brand-1-dark}"
    offsetColor: "{colors.bg-dark}"
---

# docs-support

Design system for `@universal-ember/docs-support` — the shared documentation shell used by ember-primitives docs and sibling Universal Ember documentation apps.

Follows the [Google DESIGN.md](https://github.com/google-labs-code/DESIGN.md) format used by [getdesign.md](https://getdesign.md/).

## Overview

**docs-support** is a dark-first, developer-manual aesthetic: quiet charcoal surfaces, a single indigo brand signal, and reading-optimized prose. It should feel like a precise engineering handbook — not a marketing splash page, not a dashboard, not a playful SaaS landing.

Personality:

- **Calm authority** — confident headlines, short supporting lines, no hype clutter.
- **Clear docs structure** — sticky top nav, left sidebar with active rail, soft elevated cards, pill CTAs.
- **Ember-ecosystem warmth** — optional amber mark (logo tile) and Ember coral reserved for rare critical emphasis — never as the primary brand wash.

Default theme is **dark**. Light mode is a first-class twin of the same tokens, not an afterthought invert.

Audience: Ember / TypeScript engineers reading API docs, guides, and interactive demos. Density favors scanability over decoration.

## Colors

One indigo brand family drives links, active nav, primary buttons, and inline code accents.

- **Background (`bg` / `bg-dark`):** Pure doc canvas — white in light, `#1B1B1F` in dark.
- **Alt / Soft (`bg-alt`, `bg-soft`):** Sidebar, code blocks, feature cards — one step off the canvas so hierarchy comes from surface shift, not heavy shadows.
- **Text 1 / 2 / 3:** Primary body, muted secondary, and placeholders. Never use pure `#000` / `#FFF` for long-form text on dark.
- **Brand 1–3 + soft:** Indigo scale. Dark mode uses `#A8B1FF` → `#5C73E7` → `#3E63DD`. Light mode uses deeper indigo for AA contrast on white.
- **Divider / Border:** Hairline separators; cards use translucent white/black borders (`~10–12%`) rather than hard gray boxes.
- **Mark (`#F5C518`):** Amber logo / brand-mark tile only. Do not flood UI with yellow.
- **Ember (`#E04E39`):** Legacy Ember signal — focus rings and critical callouts only when “Ember identity” must be explicit. Prefer brand indigo for day-to-day interaction.

Semantic roles:

| Role | Token | Use |
| --- | --- | --- |
| Interactive | `brand-*` | Links, active sidebar, primary CTA, code accent |
| Structure | `bg-*`, `divider` | Shell, sidebar, cards |
| Reading | `text-1..3` | Prose hierarchy |
| Brand mark | `mark` | Logo tile / hero emblem |
| Danger / warn / ok | `danger`, `warning`, `success` | Callout variants only |

## Typography

**Inter** for all UI and prose. Monospace system stack for code.

- **Display / H1:** Heavy weight, tight tracking — used on home hero and page titles. Hero product name may use brand color or a subtle indigo→violet gradient on the name only, never on whole paragraphs.
- **Body:** 16px / 1.7 line-height for long-form markdown readability.
- **Nav / Label:** 13–14px medium — sidebar and header links stay compact.
- **Code:** Slightly smaller than body; inline code uses brand-tinted text on soft bg.

Do not introduce a display serif or a second UI sans. No Inter + Lexend split unless migrating fonts deliberately in a follow-up.

## Layout

Three-zone docs layout:

1. **Top nav** — fixed/sticky, `nav-height` 64px, logo left, search center (or left-of-actions), utility links + theme toggle + social icons right. Hairline bottom border.
2. **Sidebar** — ~272px, sticky under nav, section headings + nested links with a 2px left rail; active item uses `brand-1` text + rail.
3. **Content** — max readable width ~780px. TOC (on this page) may sit right on wide screens.

Home / index:

- Hero: two-column on desktop (copy + mark/art), single column on mobile.
- Primary CTA solid brand pill; secondary CTAs ghost pills (soft bg + border).
- Feature grid: 2–4 equal soft cards, icon + title + 2–3 lines muted text.

Spacing uses an 8px rhythm (`spacing.*`). Generous vertical section gaps (`2xl`–`3xl`) on marketing/home; tighter (`md`–`lg`) inside article prose.

Mobile: collapse sidebar into a drawer (existing `ember-mobile-menu` shell); keep top nav slim.

## Elevation & Depth

Prefer **surface steps** over drop shadows:

- Canvas → soft/alt → elevated for floating menus and sticky header when scrolled.
- Cards: `bg-soft` + translucent border; optional 1px inner highlight — no multi-layer shadows.
- Hero art may use a soft radial brand glow behind the mark (low opacity indigo/cyan), never neon bloom spam.
- Code blocks sit on `bg-alt`; do not raise them with heavy shadow.

Scrolled header may add a subtle `bg-elv` fill + divider; avoid frosted-glass blur unless performance-safe.

## Shapes

- **Pills (`rounded.pill`):** Primary/secondary buttons, search chip, theme toggle track.
- **Cards / callouts:** `md` (12px) — approachable but not bubbly.
- **Inputs / code:** `sm` (8px).
- **Logo mark tile:** `lg`–`xl` square/rounded rectangle.
- Avoid fully circular icon buttons except social glyphs and avatars.

## Components

### Shell

`Shell` sets color-scheme class on `body` and loads global tokens. Dark is default for first paint when system prefers dark; respect explicit user toggle.

### Top nav / Header

Sticky; transparent → elevated on scroll. Logo wordmark left. Actions right: docs links, tests, GitHub, theme toggle. No mega-menus.

### Sidebar

Left rail navigation. Active route: brand text + brand rail. Hover: soft bg wash. Group titles use `text-2`, not loud color.

### Page layout

Article column + optional right TOC. “Edit this page” link muted, brand on hover.

### Buttons / CTAs

- Primary: solid `brand-3` (dark) / `brand-3` (light), white label, pill.
- Secondary: soft surface + border, pill.
- Text links in prose: brand underline or brand colored text; hover shifts `brand-1` → `brand-2`.

### Feature cards

Home grid only. Soft surface, thin border, small colorful glyph, bold title, muted body. Equal height; no shadow stacks.

### Callouts

Soft brand-tinted background for tips; success/warning/danger variants use semantic soft tints. Icon + short title optional.

### Code

Shiki themes aligned to light/dark surfaces. Inline code: brand-1 text on soft bg. Block: `bg-alt`, rounded `sm`, max-height with internal scroll when tall.

### Theme toggle

Compact switch in header; focus ring uses brand (indigo), not Ember coral — unless deliberately showcasing Ember focus styling in a demo.

### Focus

Visible focus: 2px brand ring + 2px canvas offset. Never `outline: none` without a replacement.

## Do's and Don'ts

**Do**

- Keep one indigo brand family for interaction.
- Use surface steps (`bg` / `bg-soft` / `bg-elv`) for hierarchy.
- Default to dark canvas `#1B1B1F` with brand indigo.
- Reserve amber mark for logo/hero emblem.
- Keep nav + sidebar + prose as the docs information architecture.
- Write short hero lines; put depth in the guides.

**Don't**

- Don't purple-wash whole pages or use glow-heavy “AI SaaS” gradients as the main idea.
- Don't make Ember coral the primary brand color for the shell.
- Don't use large drop shadows, glassmorphism everywhere, or dashboard card walls on the home hero.
- Don't mix a second display font or decorative serifs.
- Don't place stats strips, promo chips, or floating badges over hero media.
- Don't invert dark/light carelessly — retoken both modes from this file.

## Implementation notes (for agents)

- Source of truth for tokens: this file.
- Apply tokens in `packages/docs-support/src/site-css/*.css` and component `<style>` blocks (`shell`, `page-layout`, `side-nav`, `index-page`, `theme-toggle`).
- Prefer CSS custom properties mapped 1:1 from front matter (`--doc-bg`, `--doc-brand-1`, …) with light/dark pairs on `:root` / `.dark` (or existing `html[style*="color-scheme: dark"]` selector).
- `docs-app` should consume the shell via `@universal-ember/docs-support` — avoid one-off marketing CSS in the app unless it is page content.
- Validate with: `npx @google/design.md lint packages/docs-support/DESIGN.md` when available.
