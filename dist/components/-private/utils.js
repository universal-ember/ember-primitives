/**
 * If the user provides an onChange or similar function, use that,
 * otherwise fallback to the uncontrolled toggle
 */
function toggleWithFallback(uncontrolledToggle, controlledToggle) {
  if (controlledToggle) {
    return controlledToggle();
  }
  uncontrolledToggle();
}

export { toggleWithFallback };
//# sourceMappingURL=utils.js.map
