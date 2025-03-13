/**
 * DANGER: this is a *barrel file*
 *
 * It forces the whole library to be loaded and all dependencies.
 *
 * If you have a small app, you probably don't want to import from here -- instead import from each sub-path.
 */
import { importSync, isDevelopingApp, macroCondition } from '@embroider/macros';

if (macroCondition(isDevelopingApp())) {
  importSync('./components/violations.css');
}

export { Accordion } from './components/accordion.gts';
export type {
  AccordionContentExternalSignature,
  AccordionHeaderExternalSignature,
  AccordionItemExternalSignature,
  AccordionTriggerExternalSignature,
} from './components/accordion/public.ts';
export { Avatar } from './components/avatar.gts';
export { Dialog, Dialog as Modal } from './components/dialog.gts';
export { ExternalLink } from './components/external-link.gts';
export { Form } from './components/form.gts';
export { Key, KeyCombo } from './components/keys.gts';
export { StickyFooter } from './components/layout/sticky-footer.gts';
export { Link } from './components/link.gts';
export { Menu } from './components/menu.gts';
export { OTP, OTPInput } from './components/one-time-password/index.gts';
export { Popover } from './components/popover.gts';
export { Portal } from './components/portal.gts';
export { PortalTargets } from './components/portal-targets.gts';
export { TARGETS as PORTALS } from './components/portal-targets.gts';
export { Progress } from './components/progress.gts';
export { Scroller } from './components/scroller.gts';
export { Shadowed } from './components/shadowed.gts';
export { Switch } from './components/switch.gts';
export { Toggle } from './components/toggle.gts';
export { ToggleGroup } from './components/toggle-group.gts';
export { VisuallyHidden } from './components/visually-hidden.gts';
export { Zoetrope } from './components/zoetrope.ts';
export * from './helpers.ts';
