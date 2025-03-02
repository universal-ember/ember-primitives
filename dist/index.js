import { macroCondition, isDevelopingApp, importSync } from '@embroider/macros';
export { Accordion } from './components/accordion.js';
export { Avatar } from './components/avatar.js';
export { Dialog, Dialog as Modal } from './components/dialog.js';
export { ExternalLink } from './components/external-link.js';
export { Form } from './components/form.js';
export { StickyFooter } from './components/layout/sticky-footer.js';
export { Link } from './components/link.js';
export { Menu } from './components/menu.js';
export { OTPInput } from './components/one-time-password/input.js';
export { OTP } from './components/one-time-password/otp.js';
export { Popover } from './components/popover.js';
export { Portal } from './components/portal.js';
export { TARGETS as PORTALS, PortalTargets } from './components/portal-targets.js';
export { Progress } from './components/progress.js';
export { Scroller } from './components/scroller.js';
export { Shadowed } from './components/shadowed.js';
export { Switch } from './components/switch.js';
export { Toggle } from './components/toggle.js';
export { ToggleGroup } from './components/toggle-group.js';
export { Zoetrope } from './components/zoetrope/index.js';
export { link } from './helpers/link.js';
export { service } from './helpers/service.js';

/**
 * DANGER: this is a *barrel file*
 *
 * It forces the whole library to be loaded and all dependencies.
 *
 * If you have a small app, you probably don't want to import from here -- instead import from each sub-path.
 */
if (macroCondition(isDevelopingApp())) {
  importSync('./components/violations.css');
}
//# sourceMappingURL=index.js.map
