import type { Accordion } from './components/accordion';
import type { AccordionContent } from './components/accordion/content';
import type { AccordionHeader } from './components/accordion/header';
import type { AccordionItem } from './components/accordion/item';
import type { AccordionTrigger } from './components/accordion/trigger';
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
export default interface Registry {
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
    service: typeof service;
}
//# sourceMappingURL=template-registry.d.ts.map