import { macroCondition, isDevelopingApp, importSync } from '@embroider/macros';
export { Dialog, Dialog as Modal } from './components/dialog.js';
export { ExternalLink } from './components/external-link.js';
export { Link } from './components/link.js';
export { Popover } from './components/popover.js';
export { Portal } from './components/portal.js';
export { TARGETS as PORTALS, PortalTargets } from './components/portal-targets.js';
export { Shadowed } from './components/shadowed.js';
export { Switch } from './components/switch.js';
export { Toggle } from './components/toggle.js';
export { service } from './helpers/service.js';

if (macroCondition(isDevelopingApp())) {
  importSync('./components/violations.css');
}
//# sourceMappingURL=index.js.map
