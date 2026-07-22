import { Tabs } from 'ember-primitives/components/tabs';

import { Link } from '@universal-ember/docs-support';

import type { TOC } from '@ember/component/template-only';

/** Install / copy-code instructions with package-manager tabs. */
function dropExtension(name: string | undefined) {
  if (!name) return;

  return name.replace(/\.g?(j|t)s/, '');
}

function orDefault(name: string | undefined) {
  return name || 'ember-primitives';
}

/**
 * ember-primitives releases were tagged `ember-primitives@<version>`
 * up through 0.10.1, and `v<version>-<package-name>` from 0.10.2 onward.
 */
function isOldStyleTag(version: string) {
  const [major = 0, minor = 0, patch = 0] = version.split('.').map(Number);

  return major === 0 && (minor < 10 || (minor === 10 && patch < 2));
}

function releaseURL(name: string | undefined, version: string) {
  const packageName = orDefault(name);
  const tag =
    packageName === 'ember-primitives' && isOldStyleTag(version)
      ? `ember-primitives@${version}`
      : `v${version}-${packageName}`;

  return `https://github.com/universal-ember/ember-primitives/releases/tag/${tag}`;
}

export const SetupInstructions: TOC<{
  Args: {
    name?: string;
    src?: string;
    since?: string;
  };
}> = <template>
  {{! template-lint-disable no-forbidden-elements }}
  <div data-setup class="not-prose">
    <Tabs data-setup-group @label="Install as a library" as |Tab|>
      <Tab @label="npm">
        <code>npm add {{orDefault @name}}</code>
      </Tab>
      <Tab @label="pnpm">
        <code>pnpm add {{orDefault @name}}</code>
      </Tab>
      <Tab @label="yarn">
        <code>yarn add {{orDefault @name}}</code>
      </Tab>
    </Tabs>

    {{#if @src}}
      <Tabs data-setup-group @label="Own the code" as |Tab|>
        <Tab @label="npx">
          <code>npx ember-primitives -- emit {{dropExtension @src}}</code>
        </Tab>
        <Tab @label="pnpm dlx">
          <code>pnpm dlx ember-primitives emit {{dropExtension @src}}</code>
        </Tab>
        <Tab @label="GitHub">
          <Link
            href="https://github.com/universal-ember/ember-primitives/blob/main/ember-primitives/src/{{@src}}"
          >
            Edit or copy from source
          </Link>
        </Tab>
      </Tabs>
    {{/if}}

    {{#if @since}}
      <p data-setup-since>
        Introduced in
        <Link href={{releaseURL @name @since}}>{{@since}}</Link>
      </p>
    {{/if}}
  </div>

  {{!
    Attribute selectors stay stable under ember-scoped-css (unlike class names).
    Keep these here so live ```hbs``` previews always get spacing — not only app.css.
  }}
  <style>
    [data-setup] {
      display: flex;
      flex-direction: column;
      gap: 1.25rem;
      margin: 1.25rem 0 1.75rem;
    }

    [data-setup-group].ember-primitives__tabs,
    .ember-primitives__tabs[data-setup-group] {
      display: flex;
      flex-direction: column;
      margin: 0;
      border: 1px solid var(--doc-border);
      border-radius: var(--doc-radius-md);
      background: var(--doc-bg-alt);
      overflow: hidden;
    }

    [data-setup-group] > .ember-primitives__tabs__label {
      margin: 0;
      padding: 0.85rem 1.15rem 0.35rem;
      font-family: var(--font-sans);
      font-size: 0.75rem;
      font-weight: 600;
      letter-spacing: 0.04em;
      text-transform: uppercase;
      color: var(--doc-text-3);
    }

    [data-setup-group] > [role="tablist"],
    [data-setup-group] > .ember-primitives__tabs__tablist {
      display: flex;
      flex-wrap: wrap;
      gap: 0.15rem;
      width: 100%;
      min-width: 0;
      margin: 0;
      padding: 0.15rem 0.85rem 0;
      border: 0;
      border-bottom: 1px solid var(--doc-border);
      background: transparent;
      border-radius: 0;
    }

    [data-setup-group] [role="tab"] {
      position: relative;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      margin: 0;
      padding: 0.55rem 0.9rem 0.75rem;
      border: 0;
      border-radius: 0;
      background: transparent !important;
      color: var(--doc-text-3);
      font-family: var(--font-sans);
      font-size: 0.8125rem;
      font-weight: 500;
      line-height: 1.2;
      cursor: pointer;
      box-shadow: none !important;
      transition: color 0.12s ease;
    }

    [data-setup-group] [role="tab"]:hover {
      color: var(--doc-text-1);
      background: transparent !important;
    }

    [data-setup-group] [role="tab"][aria-selected="true"] {
      color: var(--doc-brand-1);
      background: transparent !important;
      font-weight: 600;
      box-shadow: none !important;
    }

    [data-setup-group] [role="tab"][aria-selected="true"]::after {
      content: "";
      position: absolute;
      left: 0.55rem;
      right: 0.55rem;
      bottom: -1px;
      height: 2px;
      border-radius: 2px 2px 0 0;
      background: var(--doc-brand-1);
    }

    [data-setup-group] > .ember-primitives__tabs__tabpanel {
      min-width: 0;
      padding: 0;
    }

    [data-setup-group] [role="tabpanel"] {
      display: block;
      margin: 0;
      padding: 1.1rem 1.15rem !important;
      border: 0 !important;
      border-radius: 0 !important;
      background: transparent !important;
      color: var(--doc-text-1);
      font-family: var(--font-mono);
      font-size: 0.875rem;
      line-height: 1.6;
      letter-spacing: -0.01em;
      overflow-x: auto;
    }

    [data-setup-group] [role="tabpanel"] code {
      font: inherit;
      color: inherit;
      background: transparent;
      padding: 0;
      border-radius: 0;
    }

    [data-setup-group] [role="tabpanel"] a {
      color: var(--doc-brand-1);
      font-family: var(--font-sans);
      font-weight: 500;
      text-decoration: none;
    }

    [data-setup-group] [role="tabpanel"] a:hover {
      text-decoration: underline;
      text-underline-offset: 0.18em;
    }

    [data-setup-since] {
      margin: 0;
      padding: 0 0.15rem;
      font-size: 0.875rem;
      color: var(--doc-text-2);
    }
  </style>
</template>;
