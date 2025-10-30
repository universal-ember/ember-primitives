
/**
 * If the user provides an onChange or similar function, use that,
 * otherwise fallback to the uncontrolled toggle
 */
function toggleWithFallback(uncontrolledToggle, controlledToggle, ...args) {
  if (controlledToggle) {
    return controlledToggle(...args);
  }
  uncontrolledToggle(...args);
}

export { toggleWithFallback };
//# sourceMappingURL=utils.js.map
