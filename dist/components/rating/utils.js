function isString(x) {
  return typeof x === 'string';
}
function lte(a, b) {
  return a <= b;
}
function percentSelected(a, b) {
  const diff = b + 1 - a;
  if (diff < 0) return 0;
  if (diff > 1) return 100;
  if (a === b) return 100;
  const percent = diff * 100;
  return percent;
}

export { isString, lte, percentSelected };
//# sourceMappingURL=utils.js.map
