// Easily allow apps, which are not yet using strict mode templates, to consume your Glint types, by importing this file.
// Add all your components, helpers and modifiers to the template registry here, so apps don't have to do this.
// See https://typed-ember.gitbook.io/glint/using-glint/ember/authoring-addons

import type { Dialog } from './components/dialog';
import type { ExternalLink } from './components/external-link';
import type { Link } from './components/link';
import type { Popover } from './components/popover';
import type { Portal } from './components/portal';
import type { PortalTargets } from './components/portal-targets';
import type { Shadowed } from './components/shadowed';
import type { Switch } from './components/switch';
import type { Toggle } from './components/toggle';
import type { service } from './helpers/service';

// import type MyComponent from './components/my-component';

// Remove this once entries have been added! 👇
// eslint-disable-next-line @typescript-eslint/no-empty-interface
export default interface Registry {
  // components
  Dialog: typeof Dialog;
  ExternalLink: typeof ExternalLink;
  Link: typeof Link;
  Popover: typeof Popover;
  PortalTargets: typeof PortalTargets;
  Portal: typeof Portal;
  Shadowed: typeof Shadowed;
  Switch: typeof Switch;
  Toggle: typeof Toggle;

  // helpers
  service: typeof service;
}
