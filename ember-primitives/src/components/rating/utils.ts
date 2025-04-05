export function isString(x: unknown) {
  return typeof x === 'string';
}

export function lte(a: number, b: number) {
  return a <= b;
}

export function percentSelected(a: number, b: number) {
  const diff = b + 1 - a;

  if (diff < 0) return 0;
  if (diff > 1) return 100;
  if (a === b) return 100;

  const percent = diff * 100;

  return percent;
}
