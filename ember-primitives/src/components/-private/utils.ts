/**
 * If the user provides an onChange or similar function, use that,
 * otherwise fallback to the uncontrolled toggle
 */
export function toggleWithFallback(
  uncontrolledToggle: (...args: unknown[]) => void,
   
  controlledToggle?: (...args: any[]) => void,
  ...args: unknown[]
) {
  if (controlledToggle) {
    return controlledToggle(...args);
  }

  uncontrolledToggle(...args);
}
