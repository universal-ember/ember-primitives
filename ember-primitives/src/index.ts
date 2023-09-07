import { importSync, isDevelopingApp, macroCondition } from '@embroider/macros';

if (macroCondition(isDevelopingApp())) {
  importSync('./components/violations.css');
}

export {
  Accordion,
  type AccordionContentExternalSignature,
  type AccordionHeaderExternalSignature,
  type AccordionItemExternalSignature,
  type AccordionTriggerExternalSignature,
} from './components/accordion.gts';
export { Avatar } from './components/avatar.gts';
export { Dialog, Dialog as Modal } from './components/dialog.gts';
export { ExternalLink } from './components/external-link.gts';
export { Form } from './components/form.gts';
export { StickyFooter } from './components/layout/sticky-footer/index.gts';
export { Link } from './components/link.gts';
export { OTP, OTPInput } from './components/one-time-password/index.gts';
export { Popover } from './components/popover.gts';
export { Portal } from './components/portal.gts';
export { PortalTargets } from './components/portal-targets.gts';
export { TARGETS as PORTALS } from './components/portal-targets.gts';
export { Progress } from './components/progress.gts';
export { Shadowed } from './components/shadowed.gts';
export { Switch } from './components/switch.gts';
export { Toggle } from './components/toggle.gts';
export * from './helpers.ts';
