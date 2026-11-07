// Easily allow apps, which are not yet using strict mode templates, to consume your Glint types, by importing this file.
// Add all your components, helpers and modifiers to the template registry here, so apps don't have to do this.
// See https://typed-ember.gitbook.io/glint/using-glint/ember/authoring-addons

import type { Accordion } from './components/accordion.gts';
import type { AccordionContent } from './components/accordion/content.gts';
import type { AccordionHeader } from './components/accordion/header.gts';
import type { AccordionItem } from './components/accordion/item.gts';
import type { AccordionTrigger } from './components/accordion/trigger.gts';
import type { Dialog } from './components/dialog.gts';
import type { ExternalLink } from './components/external-link.gts';
import type { Link } from './components/link.gts';
import type { Popover } from './components/popover.gts';
import type { Portal } from './components/portal.gts';
import type { PortalTargets } from './components/portal-targets.gts';
import type { Shadowed } from './components/shadowed.gts';
import type { Switch } from './components/switch.gts';
import type { Toggle } from './components/toggle.gts';
import type { service } from './helpers/service.ts';

// import type MyComponent from './components/my-component';

// Remove this once entries have been added! 👇

export default interface Registry {
  // components
  Accordion: typeof Accordion;
  AccordionItem: typeof AccordionItem;
  AccordionHeader: typeof AccordionHeader;
  AccordionContent: typeof AccordionContent;
  AccordionTrigger: typeof AccordionTrigger;
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
