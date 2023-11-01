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
} from './components/accordion';
export { Avatar } from './components/avatar';
export { Dialog, Dialog as Modal } from './components/dialog';
export { ExternalLink } from './components/external-link';
export { Form } from './components/form';
export { StickyFooter } from './components/layout/sticky-footer/index';
export { Link } from './components/link';
export { OTP, OTPInput } from './components/one-time-password/index';
export { Popover } from './components/popover';
export { Portal } from './components/portal';
export { PortalTargets } from './components/portal-targets';
export { TARGETS as PORTALS } from './components/portal-targets';
export { Progress } from './components/progress';
export { Shadowed } from './components/shadowed';
export { Switch } from './components/switch';
export { Toggle } from './components/toggle';
export * from './helpers';
