export function isString(x: unknown) {
  return typeof x === 'string';
}

export function lte(a: number, b: number) {
  return a <= b;
}

export function shouldShowHalfIcon(iconHalf: unknown, percent: number): iconHalf is string {
  if (!iconHalf) return false;
  if (typeof iconHalf !== 'string') return false;

  return percent > 0 && percent < 100;
}

export function percentSelected(a: number, b: number) {
  const diff = b + 1 - a;

  if (diff <= 0) return 0;
  if (diff >= 1) return 100;

  const percent = diff * 100;

  return Math.round(percent);
}
