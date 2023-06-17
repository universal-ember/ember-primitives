/**
 * If the user provides an onChange or similar function, use that,
 * otherwise fallback to the uncontrolled toggle
 */
export function toggleWithFallback(uncontrolledToggle: () => void, controlledToggle?: () => void) {
  if (controlledToggle) {
    return controlledToggle();
  }

  uncontrolledToggle();
}
